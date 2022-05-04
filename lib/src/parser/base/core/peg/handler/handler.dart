// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

class PegHandler {
  final PegParserMutable mutable;

  const PegHandler(this.mutable);

  @internal
  PegMemoizationEntry? recall(Parser parser, int index, Context context) {
    PegMemoizationEntry? entry = mutable.memoMap.putIfAbsent(parser, PegMemoizationSubMap.new)[index];
    Head? head = mutable.heads[index];

    // If the head is not being grown, return the memoized result.
    if (head == null || !head.evaluationSet.contains(parser)) {
      return entry;
    }

    // If the current parser is not a part of the head and is not evaluated yet,
    // Add a failure to it.
    if (entry == null && !(head.involvedSet | <Parser>{head.parser}).contains(parser)) {
      return Parser.seedFailure.index(index).entry();
    }

    // Remove the current parser from the head's evaluation set.
    head.evaluationSet.remove(parser);
    entry!.value = parser.parsePeg(context, this);

    return entry;
  }

  @internal
  Context leftRecursiveResult(Parser parser, int index, PegMemoizationEntry entry) {
    PegLeftRecursion leftRecursion = entry.value as PegLeftRecursion;
    Head head = leftRecursion.head!;
    Context seed = leftRecursion.seed;

    /// If the rule of the parser is not the one being parsed,
    /// return the seed.
    if (head.parser != parser) {
      return seed;
    }

    /// Since it is the parser, assign it to the seed.
    Context seedContext = entry.value = seed;
    if (seedContext is ContextFailure) {
      return seedContext;
    }

    mutable.heads[index] = head;

    /// "Grow the seed."
    for (;;) {
      head.evaluationSet.addAll(head.involvedSet);
      Context result = parser.parsePeg(seedContext.index(index), this);
      if (result.state.index <= seedContext.state.index) {
        break;
      }
      entry.value = result;
    }
    mutable.heads.remove(index);

    return entry.value as Context;
  }

  @internal
  Context parseQuadraticMemoized(Parser parser, Context context) {
    int index = context.state.index;

    PegMemoizationEntry? entry = recall(parser, index, context);
    if (entry == null) {
      /// Create a new LR instance. Then, add it to the stack.
      PegLeftRecursion leftRecursion = PegLeftRecursion(seed: Parser.seedFailure, parser: parser, head: null);
      mutable.parserCallStack.add(leftRecursion);

      /// Save a new entry on `position` with the LR instance.
      entry = mutable.memoMap //
          .putIfAbsent(parser, PegMemoizationSubMap.new)
          .putIfAbsent(index, leftRecursion.entry);

      /// Evaluate the parser.
      Context ans = parser.parsePeg(context, this);

      /// Remove the created LR instance from the stack.
      mutable.parserCallStack.removeLast();

      /// If a descendant parser put a head in the lr then return the result of method [leftRecursiveResult()].
      if (leftRecursion.head != null) {
        leftRecursion.seed = ans;

        return leftRecursiveResult(parser, index, entry);
      }

      /// If it was a normal parser result, return the resulting context.
      else {
        entry.value = ans;

        return ans;
      }
    } else {
      MemoizationEntryValue result = entry.value;

      if (result is PegLeftRecursion) {
        /// If a previous call on this parser on this position
        /// has placed an LR instance, then this is a left-recursive call.
        /// Create a new head instance, and assign it to the LR instance.
        Head head = result.head = Head(parser: parser, evaluationSet: <Parser>{}, involvedSet: <Parser>{});

        /// While the LR of the current left-recursive parser is not yet found,
        /// Assign all the [lrStack] items to have the [lHead] as their own head.
        /// Also, add the [rule] of [lrStack.item] to the [lHead.involvedSet]
        for (PegLeftRecursion left
            in mutable.parserCallStack.reversed.takeWhile((PegLeftRecursion lr) => lr.head != head)) {
          head.involvedSet.add(left.parser);
          left.head = head;
        }

        return result.seed;
      } else if (result is Context) {
        return result;
      }
      Parser.never;
    }
  }

  @internal
  Context parseLinearMemoized(Parser parser, Context context) {
    int index = context.state.index;
    PegMemoizationSubMap subMap = mutable.memoMap.putIfAbsent(parser, PegMemoizationSubMap.new);
    PegMemoizationEntry? entry = subMap[index];

    if (entry != null) {
      return entry.value as Context;
    }

    if (parser.leftRecursive) {
      subMap[index] = context.failure("seed").entry();
      Context ctx = parser.parsePeg(context, this);
      if (ctx is ContextFailure) {
        return ctx;
      }
      subMap[index] = ctx.entry();

      for (;;) {
        Context inner = parser.parsePeg(context, this);
        if (inner is ContextFailure || inner.state.index <= ctx.state.index) {
          return ctx;
        }

        ctx = inner;
        subMap[index] = ctx.entry();
      }
    } else {
      Context result = parser.parsePeg(context, this);
      subMap[index] = result.entry();

      return result;
    }
  }

  @internal
  Context parsePureMemoized(Parser parser, Context context) {
    int index = context.state.index;
    PegMemoizationSubMap subMap = mutable.memoMap.putIfAbsent(parser, PegMemoizationSubMap.new);
    Context result = subMap.putIfAbsent(context.state.index, () {
      subMap[index] = context.failure("Left recursion detected.").entry();

      return subMap[index] = parser.parsePeg(context, this).entry();
    }).value as Context;

    return result;
  }

  @internal
  Context apply(Parser parser, Context context) {
    if (context is ContextFailure) {
      return context;
    }

    if (parser.memoize) {
      switch (context.state.mode) {
        case ParseMode.purePeg:
          return parsePureMemoized(parser, context);
        case ParseMode.linearPeg:
          return parseLinearMemoized(parser, context);
        case ParseMode.quadraticPeg:
          return parseQuadraticMemoized(parser, context);
        case ParseMode.gll:
          throw UnsupportedError("`ParseMode.gll` is only for GLL parsing mode!");
      }
    } else {
      return parser.parsePeg(context, this);
    }
  }
}

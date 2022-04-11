// ignore_for_file: deprecated_member_use_from_same_package

import "package:parser_peg/internal_all.dart";

class ParserEngine {
  static late final Never never = throw Error();
  static final Context seedFailure = Context.failure(State(input: ""), "seed");

  final List<LeftRecursion> parserCallStack = <LeftRecursion>[];
  final MemoizationMap memoMap = MemoizationMap();
  final Heads heads = Heads();

  MemoizationEntry? recall(Parser parser, int index, Context context) {
    MemoizationEntry? entry = memoMap.putIfAbsent(parser, MemoizationSubMap.new)[index];
    Head? head = heads[index];

    // If the head is not being grown, return the memoized result.
    if (head == null || !head.evaluationSet.contains(parser)) {
      return entry;
    }

    // If the current parser is not a part of the head and is not evaluated yet,
    // Add a failure to it.
    if (entry == null && !(head.involvedSet | <Parser>{head.parser}).contains(parser)) {
      return seedFailure.absolute(index).entry();
    }

    // Remove the current parser from the head's evaluation set.
    head.evaluationSet.remove(parser);
    entry!.value = parser.parse(context, this);

    return entry;
  }

  Context leftRecursiveResult(Parser parser, int index, MemoizationEntry entry) {
    LeftRecursion leftRecursion = entry.value as LeftRecursion;
    Head head = leftRecursion.head!;

    /// If the rule of the parser is not the one being parsed,
    /// return the seed.
    if (head.parser != parser) {
      return leftRecursion.seed;
    }

    /// Since it is the parser, assign it to the seed.
    Context seedContext = entry.value = leftRecursion.seed;
    if (seedContext is ContextFailure) {
      return seedContext;
    }

    heads[index] = head;

    /// "Grow the seed."
    for (;;) {
      head.evaluationSet.addAll(head.involvedSet);
      Context result = parser.parse(seedContext.absolute(index), this);
      if (result.state.index <= seedContext.state.index) {
        break;
      }
      entry.value = result;
    }
    heads.remove(index);

    return entry.value as Context;
  }

  Context runMemoized(Parser parser, Context context) {
    int index = context.state.index;

    MemoizationEntry? entry = recall(parser, index, context);
    if (entry == null) {
      /// Create a new LR instance. Then, add it to the stack.
      LeftRecursion leftRecursion = LeftRecursion(seed: seedFailure, parser: parser, head: null);
      parserCallStack.add(leftRecursion);

      /// Save a new entry on `position` with the LR instance.
      MemoizationSubMap subMap = memoMap.putIfAbsent(parser, MemoizationSubMap.new);
      subMap[index] = entry = leftRecursion.entry();

      /// Evaluate the parser.
      Context ans = parser.parse(context, this);

      /// Remove the created LR instance from the stack.
      parserCallStack.removeLast();

      /// If a descendant parser put a head in the lr then
      /// return the result of method `leftRecursiveResult`.
      if (leftRecursion.head != null) {
        leftRecursion.seed = ans;

        return leftRecursiveResult(parser, index, entry);
      }

      /// If it was a normal parser result,
      /// return the resulting context.
      else {
        entry.value = ans;

        return ans;
      }
    } else {
      MemoizationEntryValue result = entry.value;

      if (result is LeftRecursion) {
        /// If a previous call on this parser on this position
        /// has placed an LR instance, then this is a left-recursive call.
        /// Create a new head instance, and assign it to the LR instance.
        Head head = result.head = Head(parser: parser, evaluationSet: <Parser>{}, involvedSet: <Parser>{});

        /// While the LR of the current left-recursive parser is not yet found,
        /// Assign all the `lrStack` items to have the `lHead` as their own head.
        /// Also, add the `rule` of `lrStack.item` to the `lHead.involvedSet`
        for (LeftRecursion left in parserCallStack.reversed.takeWhile((LeftRecursion lr) => lr.head != head)) {
          head.involvedSet.add(left.parser);
          left.head = head;
        }

        return result.seed;
      } else if (result is Context) {
        return result;
      }
      never;
    }
  }

  Context apply(Parser parser, Context context) {
    if (context is ContextFailure) {
      return context;
    }

    return parser.memoize //
        ? runMemoized(parser, context)
        : parser.parse(context, this);
  }
}

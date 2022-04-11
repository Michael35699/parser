// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:parser_peg/internal_all.dart";

class ParserEngine {
  static late final Never _never = throw Error();
  static final Context _seedFailure = Context.failure(State(input: ""), "seed");

  final List<LeftRecursion> _lrStack = <LeftRecursion>[];
  final MemoizationMap _memoMap = MemoizationMap();
  final Heads heads = Heads();

  MemoEntry? recall(Parser parser, int index, Context context) {
    MemoEntry? entry = _memoMap.putIfAbsent(parser, HashMap<int, MemoEntry>.new)[index];
    Head? head = heads[index];

    // If the head is not being grown, return the memoized result.
    if (head == null || !head.evalSet.contains(parser)) {
      return entry;
    }

    // If the current parser is not a part of the head and is not evaluated yet,
    // Add a failure to it.
    if (entry == null && !(head.involvedSet | <Parser>{head.parser}).contains(parser)) {
      return MemoEntry(result: _seedFailure.absolute(index), index: index);
    }

    // Remove the current parser from the head's evaluation set.
    head.evalSet.remove(parser);
    Context ans = parser.parse(context, this);

    return entry!
      ..result = ans
      ..index = ans.state.index;
  }

  Context leftRecursiveResult(Parser parser, int index, MemoEntry entry) {
    LeftRecursion leftRecursion = entry.result as LeftRecursion;
    Head head = leftRecursion.head!;

    /// If the rule of the parser is not the one being parsed,
    /// return the seed.
    if (head.parser != parser) {
      return leftRecursion.seed;
    }

    /// Since it is the parser, assign it to the seed.
    Context seedContext = entry.result = leftRecursion.seed;
    if (seedContext is ContextFailure) {
      return seedContext;
    }

    heads[index] = head;

    /// "Grow the seed."
    for (;;) {
      head.evalSet.addAll(head.involvedSet);
      Context result = parser.parse(seedContext.absolute(index), this);
      if (result is ContextFailure || result.state.index <= seedContext.state.index) {
        break;
      }
      entry.result = result;
      entry.index = result.state.index;
    }
    heads.remove(index);

    return entry.result as Context;
  }

  Context _runMemoized(Parser parser, Context context) {
    int index = context.state.index;

    MemoEntry? entry = recall(parser, index, context);
    if (entry == null) {
      /// Create a new LR instance. Then, add it to the stack.
      LeftRecursion lr = LeftRecursion(seed: _seedFailure, parser: parser, head: null);
      _lrStack.add(lr);

      /// Save a new entry on `position` with the LR instance.
      MemoizationSubMap subMap = _memoMap.putIfAbsent(parser, MemoizationSubMap.new);
      subMap[index] = entry = MemoEntry(result: lr, index: index);

      /// Evaluate the parser.
      Context ans = parser.parse(context, this);

      /// Remove the created LR instance from the stack.
      _lrStack.removeLast();

      /// If a descendant parser put a head in the lr then
      /// return the result of `lrAnswer`.
      if (lr.head != null) {
        lr.seed = ans;
        entry.index = ans.state.index;

        return leftRecursiveResult(parser, index, entry);
      }

      /// If it was a normal parser result,
      /// return the resulting context.
      else {
        entry.index = ans.state.index;
        entry.result = ans;

        return ans;
      }
    } else {
      MemoEntryResult result = entry.result;
      if (result is LeftRecursion) {
        /// If a previous call on this parser on this position
        /// has placed an LR instance, then this is a left-recursive call.
        /// Create a new head instance, and assign it to the LR instance.
        Head lHead = result.head = Head(parser: parser, evalSet: <Parser>{}, involvedSet: <Parser>{});

        /// While the LR of the current left-recursive parser is not yet found,
        /// Assign all the `lrStack` items to have the `lHead` as their own head.
        /// Also, add the `rule` of `lrStack.item` to the `lHead.involvedSet`
        for (LeftRecursion lr in _lrStack.reversed.takeWhile((LeftRecursion lr) => lr.head != lHead)) {
          lHead.involvedSet.add(lr.parser);
          lr.head = lHead;
        }

        return result.seed;
      } else if (result is Context) {
        return result;
      }
      _never;
    }
  }

  Context apply(Parser parser, Context context) {
    if (context is ContextFailure) {
      return context;
    }

    return parser.memoize //
        ? _runMemoized(parser, context)
        : parser.parse(context, this);
  }
}

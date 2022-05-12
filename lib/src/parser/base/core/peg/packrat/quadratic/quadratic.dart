// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/quadratic.dart";

class QuadraticPackrat extends PegHandler {
  @override
  final QuadraticPackratMutable mutable = QuadraticPackratMutable();

  @internal
  MemoizationEntry? recall(Parser parser, int index, Context context) {
    MemoizationEntry? entry = mutable.memoMap.putIfAbsent(parser, MemoizationSubMap.new)[index];
    Head? head = mutable.heads[index];

    // If the head is not being grown, return the memoized result.
    if (head == null || !head.evaluationSet.contains(parser)) {
      return entry;
    }

    // If the current parser is not a part of the head and is not evaluated yet,
    // Add a failure to it.
    if (entry == null && !<Parser>{...head.involvedSet, head.parser}.contains(parser)) {
      return context.failure("seed").index(index).entry();
    }

    // Remove the current parser from the head's evaluation set.
    head.evaluationSet.remove(parser);
    entry!.value = parser.parsePeg(context, this);

    return entry;
  }

  @internal
  @inlineVm
  Context leftRecursiveResult(Parser parser, int index, MemoizationEntry entry) {
    LeftRecursion leftRecursion = entry.value as LeftRecursion;
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

    mutable.growing.add(parser);
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
    mutable.growing.remove(parser);

    return entry.value as Context;
  }

  @internal
  @inlineVm
  Context parseQuadraticMemoized(Parser parser, Context context) {
    int index = context.state.index;

    MemoizationEntry? entry = recall(parser, index, context);
    if (entry == null) {
      LeftRecursion leftRecursion = LeftRecursion(seed: context.failure("seed"), parser: parser, head: null);

      mutable.parserStack.add(leftRecursion);
      entry = mutable.memoMap[parser][index] = leftRecursion.entry();
      Context ans = parser.parsePeg(context, this);
      mutable.parserStack.removeLast();

      if (leftRecursion.head != null) {
        leftRecursion.seed = ans;

        return leftRecursiveResult(parser, index, entry);
      } else {
        entry.value = ans;

        return ans;
      }
    } else {
      MemoizationValue result = entry.value;

      if (result is LeftRecursion) {
        Head head = result.head ??= Head(parser: parser, evaluationSet: <Parser>{}, involvedSet: <Parser>{});

        for (LeftRecursion left in mutable.parserStack.reversed.takeWhile((LeftRecursion lr) => lr.head != head)) {
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

  @override
  @inlineVm
  Context parse(Parser parser, Context context) => parseQuadraticMemoized(parser, context);
}

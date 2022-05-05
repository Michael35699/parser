// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/linear.dart";

class LinearPackrat extends PegHandler {
  @override
  final LinearPackratMutable mutable = LinearPackratMutable();

  Context leftRecursiveResult(Parser parser, Context context) {
    int index = context.state.index;

    Context ctx = context;
    mutable.growing.add(parser);
    for (;;) {
      Context inner = parser.parsePeg(context, this);
      if (inner is ContextFailure || inner.state.index <= ctx.state.index) {
        break;
      }

      ctx = inner;
      mutable.memoMap[parser][index] = ctx.entry();
    }
    mutable.growing.remove(parser);

    return ctx;
  }

  @internal
  Context parseLinearMemoized(Parser parser, Context context) {
    int index = context.state.index;
    MemoizationEntry? entry = mutable.memoMap[parser][index];

    if (entry == null) {
      if (mutable.growing.contains(parser) && parser.prioritizeLeft) {
        mutable.memoMap[parser][index] = context.failure("right recursion in left recursion").entry();

        return parser.parsePeg(context, this);
      } else {
        LeftRecursion recursion = LeftRecursion();
        mutable.memoMap[parser][index] = recursion.entry();

        Context seed = parseLinearMemoized(parser, context);
        mutable.memoMap[parser][index] = seed.entry();

        if (recursion.detected) {
          return leftRecursiveResult(parser, context);
        } else {
          return seed;
        }
      }
    } else {
      MemoizationValue value = entry.value;
      if (value is LeftRecursion) {
        value.detected = true;

        return context.failure("seed");
      } else if (value is Context) {
        return value;
      }
      Parser.never;
    }
  }

  @override
  Context parse(Parser parser, Context context) => parseLinearMemoized(parser, context);
}

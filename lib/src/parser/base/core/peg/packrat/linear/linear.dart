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
    for (;;) {
      Context inner = parser.parsePeg(context, this);
      if (inner is ContextFailure || inner.state.index <= ctx.state.index) {
        return ctx;
      }

      ctx = inner;
      mutable.memoMap[parser][index] = ctx.entry();
    }
  }

  @internal
  Context parseLinearMemoized(Parser parser, Context context) {
    int index = context.state.index;

    MemoizationEntry? entry = mutable.memoMap[parser][index];

    if (entry == null) {
      LeftRecursion recursion = LeftRecursion();
      mutable.memoMap[parser][index] = recursion.entry();

      Context ctx = parser.parsePeg(context, this);
      mutable.memoMap[parser][index] = ctx.entry();

      if (recursion.detected) {
        return leftRecursiveResult(parser, context);
      } else {
        return ctx;
      }
    } else {
      MemoizationValue value = entry.value;
      if (value is LeftRecursion) {
        value.detected = true;

        return Parser.packratFailure;
      } else if (value is Context) {
        return value;
      }
      Parser.never;
    }
  }

  @override
  Context parse(Parser parser, Context context) => parseLinearMemoized(parser, context);
}

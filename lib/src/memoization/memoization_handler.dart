// ignore_for_file: always_specify_types, deprecated_member_use_from_same_package

import "package:parser_peg/internal_all.dart";

class MemoizationHandler {
  final MultiMap<Object, Context> memoizationMap;

  MemoizationHandler() : memoizationMap = MultiMap<Object, Context>();

  Context resolve(Parser parser, Context context) {
    int index = context.state.index;

    if (!parser.leftRecursive) {
      return memoizationMap[[parser, index]] ??= parser.parse(context, this);
    }

    Context? currentEntry = memoizationMap[[parser, index]];
    if (currentEntry != null) {
      return currentEntry;
    }

    memoizationMap[[parser, index]] = context
        .failure("Memoization seed. If this is seen, then it means that there is probably a mistake in the grammar.");

    Context ctx = memoizationMap[[parser, index]] = parser.parse(context, this);
    if (ctx.isFailure) {
      return ctx;
    }

    for (;;) {
      Context inner = parser.parse(context, this);
      if (inner.state.index <= ctx.state.index) {
        return ctx;
      }

      ctx = memoizationMap[[parser, index]] = inner;
    }
  }
}

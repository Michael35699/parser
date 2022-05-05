// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/pure.dart";

class PegPure extends PegHandler {
  @override
  final PegPureMutable mutable;

  const PegPure(this.mutable);

  @internal
  Context parsePureMemoized(Parser parser, Context context) {
    int index = context.state.index;
    PegMemoizationSubMap subMap = mutable.memoMap.putIfAbsent(parser, PegMemoizationSubMap.new);
    Context result = subMap.putIfAbsent(context.state.index, () {
      subMap[index] = context.failure("Left recursion detected.");

      return subMap[index] = parser.parsePeg(context, this);
    });

    return result;
  }

  @override
  Context parse(Parser parser, Context context) => parsePureMemoized(parser, context);
}

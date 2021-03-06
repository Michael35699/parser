// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/basic.dart";

class BasicPackrat extends PegHandler {
  @override
  final BasicPackratMutable mutable = BasicPackratMutable();

  @internal
  Context parsePureMemoized(Parser parser, Context context) {
    int index = context.state.index;
    Context result = mutable.memoMap[parser].putIfAbsent(index, () {
      mutable.memoMap[parser][index] = context.failure("Left recursion detected.");

      return mutable.memoMap[parser][index] = parser.parsePeg(context, this);
    });

    return result;
  }

  @override
  Context parse(Parser parser, Context context) => parsePureMemoized(parser, context);
}

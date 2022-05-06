// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/pure/left.dart";

class LeftPeg extends PegHandler {
  @override
  final LeftPegMutable mutable = LeftPegMutable();

  @internal
  @inlineVm
  Context leftRecursiveResult(Parser parser, Context context) {
    int index = context.state.index;
    SeedSubMap selectedSeedMap = mutable.seeds[parser];

    selectedSeedMap[index] = context.failure("seed");
    Context seed = parser.parsePeg(context, this);
    selectedSeedMap[index] = seed;
    for (;;) {
      Context inner = parser.parsePeg(context, this);
      if (inner is ContextFailure || inner.state.index <= seed.state.index) {
        break;
      }

      selectedSeedMap[index] = seed = inner;
    }
    selectedSeedMap.remove(index);

    return seed;
  }

  @inlineVm
  Context parseLinear(Parser parser, Context context) {
    int index = context.state.index;
    SeedSubMap growing = mutable.seeds[parser];

    if (growing.containsKey(index)) {
      return growing[index]!;
    } else {
      late bool prioritized = parser.prioritizeLeft ?? false;
      late bool isGrowing = growing.isNotEmpty;
      late bool definitelyRR = parser.definitelyRightRecursive;
      if (prioritized && isGrowing && definitelyRR) {
        growing[index] = context.failure("right recursion in left recursion");

        return parser.parsePeg(context, this);
      } else if (parser.leftRecursive) {
        return leftRecursiveResult(parser, context);
      } else {
        return parser.parsePeg(context, this);
      }
    }
  }

  @override
  @inlineVm
  Context parse(Parser parser, Context context) => parseLinear(parser, context);
}

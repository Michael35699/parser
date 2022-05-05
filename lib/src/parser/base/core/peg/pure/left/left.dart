// ignore_for_file: deprecated_member_use_from_same_package

import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/pure/left.dart";

class LeftPeg extends PegHandler {
  @override
  final LeftPegMutable mutable = LeftPegMutable();

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

  Context parseLinear(Parser parser, Context context) {
    int index = context.state.index;
    SeedSubMap growing = mutable.seeds[parser];

    if (growing.containsKey(index)) {
      return growing[index]!;
    } else {
      bool? priority = parser.prioritizeLeft;
      if (priority != null && priority && growing.isNotEmpty && parser.rightRecursive) {
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
  Context parse(Parser parser, Context context) => parseLinear(parser, context);
}

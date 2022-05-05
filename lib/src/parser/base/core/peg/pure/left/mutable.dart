import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/pure/left.dart";

class LeftPegMutable extends PegMutable {
  final SeedMap seeds = SeedMap(SeedSubMap.identity);
}

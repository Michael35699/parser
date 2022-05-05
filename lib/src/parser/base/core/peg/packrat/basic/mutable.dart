import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/basic.dart";

class BasicPackratMutable extends PegMutable {
  final MemoizationMap memoMap = MemoizationMap();
}

import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/linear.dart";

class LinearPackratMutable extends PegMutable {
  final Set<Parser> growing = <Parser>{};
  final MemoizationMap memoMap = MemoizationMap(MemoizationSubMap.new);
}

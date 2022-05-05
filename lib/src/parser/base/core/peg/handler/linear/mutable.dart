import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/linear/typedef.dart";

class LinearPegMutable extends PegMutable {
  final PegMemoizationMap memoMap = PegMemoizationMap(PegMemoizationSubMap.new);
}

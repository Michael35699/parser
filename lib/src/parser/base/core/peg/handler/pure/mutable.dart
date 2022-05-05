import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/pure.dart";

class PegPureMutable extends PegMutable {
  final PegMemoizationMap memoMap = PegMemoizationMap();
}

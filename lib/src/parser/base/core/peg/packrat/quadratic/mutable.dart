import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/quadratic.dart";

class QuadraticPackratMutable extends PegMutable {
  final List<LeftRecursion> parserStack = <LeftRecursion>[];
  final MemoizationMap memoMap = MemoizationMap();
  final Heads heads = Heads();
}

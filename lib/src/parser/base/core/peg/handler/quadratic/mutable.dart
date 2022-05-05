import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/quadratic/left_recursion.dart";
import "package:parser/src/parser/base/core/peg/handler/quadratic/typedef.dart";

class QuadraticPegMutable extends PegMutable {
  final List<LeftRecursion> parserStack = <LeftRecursion>[];
  final MemoizationMap memoMap = MemoizationMap();
  final Heads heads = Heads();
}

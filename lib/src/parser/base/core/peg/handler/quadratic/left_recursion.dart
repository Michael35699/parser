import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/quadratic.dart";

class LeftRecursion with QuadraticPegMemoValue {
  final Parser parser;
  Context seed;
  Head? head;

  LeftRecursion({required this.seed, required this.parser, required this.head});
}

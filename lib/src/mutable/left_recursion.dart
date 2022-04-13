import "package:parser/internal_all.dart";

class LeftRecursion with MemoizationEntryValue {
  final Parser parser;
  Context seed;
  Head? head;

  LeftRecursion({required this.seed, required this.parser, required this.head});
}

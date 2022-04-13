import "package:parser/internal_all.dart";

class PegLeftRecursion with MemoizationEntryValue {
  final Parser parser;
  Context seed;
  Head? head;

  PegLeftRecursion({required this.seed, required this.parser, required this.head});
}

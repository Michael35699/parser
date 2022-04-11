import "package:parser_peg/internal_all.dart";

class LeftRecursion with MemoEntryResult {
  final Parser parser;
  Context seed;
  Head? head;

  LeftRecursion({required this.seed, required this.parser, required this.head});
}

import "package:parser_peg/internal_all.dart";

class Head {
  final Parser parser;
  final Set<Parser> involvedSet;
  final Set<Parser> evaluationSet;

  Head({required this.parser, required this.involvedSet, required this.evaluationSet});
}

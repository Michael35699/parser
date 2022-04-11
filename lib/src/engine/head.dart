import "package:parser_peg/internal_all.dart";

class Head {
  final Parser parser;
  final Set<Parser> involvedSet;
  final Set<Parser> evalSet;

  Head({required this.parser, required this.involvedSet, required this.evalSet});
}

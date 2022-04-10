import "package:parser_peg/parser.dart";

enum LintLevel {
  suggestion(0),
  warning(1),
  error(2);

  final int significance;
  const LintLevel(this.significance);
}

abstract class LintRule {
  abstract final String title;
  abstract final Parser parser;

  Parser fix();
}

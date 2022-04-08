import "package:parser_peg/internal_all.dart";

Parser cycleStarParser(Parser parser) => parser.cycle() | success(const <ParseResult>[]);
Parser cycleStar(Object parser) => cycleStarParser(parser.$);

extension CycleStarExtension on Parser {
  Parser cycleStar() => cycleStarParser(this);
  Parser star() => cycleStar();
}

extension LazyCycleStarExtension on LazyParser {
  Parser cycleStar() => this.$.cycleStar();
  Parser star() => this.$.star();
}

extension StringCycleStarExtension on String {
  Parser cycleStar() => this.$.cycleStar();
  Parser star() => this.$.star();
}

import "package:parser/internal_all.dart";

Parser cycleEndParser(Parser parser) => parser >>> eoi();
Parser cycleEnd(Object parser) => cycleEndParser(parser.$);

extension ParserCycleEndExtension on Parser {
  Parser cycleEnd() => cycleEndParser(this);
}

extension LazyParserCycleEndExtension on LazyParser {
  Parser cycleEnd() => this.$.cycleEnd();
}

extension StringCycleEndExtension on String {
  Parser cycleEnd() => this.$.cycleEnd();
}

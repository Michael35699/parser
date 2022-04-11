import "package:parser_peg/internal_all.dart";

Parser cycleEndParser(Parser parser) => parser >>> eoi();
Parser cycleEnd(Object parser) => cycleEndParser(parser.$);

extension CycleEndExtension on Parser {
  Parser cycleEnd() => cycleEndParser(this);
}

extension LazyCycleEndExtension on LazyParser {
  Parser cycleEnd() => this.$.cycleEnd();
}

extension StringCycleEndExtension on String {
  Parser cycleEnd() => this.$.cycleEnd();
}

import "package:parser_peg/internal_all.dart";

Parser cycleNParser(Parser parser, int count) => SequenceParser(<Parser>[for (int _ in count.times) parser]);
Parser cycleN(Object parser, int count) => cycleNParser(parser.$, count);

extension CycleNExtension on Parser {
  Parser cycleN(int c) => cycleNParser(this, c);
  Parser times(int c) => cycleN(c);
  Parser operator *(int c) => cycleN(c);
}

extension LazyCycleNExtension on LazyParser {
  Parser cycleN(int c) => this.$.cycleN(c);
  Parser times(int c) => this.$.times(c);
  Parser operator *(int c) => this.$ * c;
}

extension StringCycleNExtension on String {
  Parser cycleN(int c) => this.$.cycleN(c);
  Parser times(int c) => this.$.times(c);
  Parser operator *(int c) => this.$ * c;
}

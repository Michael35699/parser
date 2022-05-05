import "package:parser/internal_all.dart";

Parser ws() => r"[\t ]+".optional();
Parser whitespace() => r"[\t ]+".optional();
Parser whitespaceNewline() => r"\s+".optional();

Parser trim(Object parser) => whitespace() >> parser.$ << whitespace();
Parser trimLeft(Object parser) => whitespace() >> parser.$;
Parser trimRight(Object parser) => parser.$ << whitespace();

Parser trimNewline(Object parser) => whitespaceNewline() >> parser.$ << whitespaceNewline();
Parser trimNewlineLeft(Object parser) => whitespaceNewline() >> parser.$;
Parser trimNewlineRight(Object parser) => parser.$ << whitespaceNewline();

extension ParserParserTrimmedExtension on Parser {
  Parser trim() => whitespace() >> this << whitespace();
  Parser trimLeft() => whitespace() >> this;
  Parser trimRight() => this << whitespace();

  Parser trimNewline() => whitespaceNewline() >> this << whitespaceNewline();
  Parser trimNewlineLeft() => whitespaceNewline() >> this;
  Parser trimNewlineRight() => this << whitespaceNewline();

  Parser t() => trim();
  Parser tl() => trimLeft();
  Parser tr() => trimRight();

  Parser tnl() => trimNewline();
  Parser tnlLeft() => trimNewlineLeft();
  Parser tnlRight() => trimNewlineRight();
}

extension LazyParserParserTrimmedExtension on LazyParser {
  Parser trim() => this.$.trim();
  Parser trimLeft() => this.$.trimLeft();
  Parser trimRight() => this.$.trimRight();

  Parser trimNewline() => this.$.trimNewline();
  Parser trimNewlineLeft() => this.$.trimNewlineLeft();
  Parser trimNewlineRight() => this.$.trimNewlineRight();

  Parser t() => trim();
  Parser tl() => trimLeft();
  Parser tr() => trimRight();

  Parser tnl() => trimNewline();
  Parser tnlLeft() => trimNewlineLeft();
  Parser tnlRight() => trimNewlineRight();
}

extension StringParserTrimmedExtension on String {
  Parser trim() => this.$.trim();
  Parser trimLeft() => this.$.trimLeft();
  Parser trimRight() => this.$.trimRight();

  Parser trimNewline() => this.$.trimNewline();
  Parser trimNewlineLeft() => this.$.trimNewlineLeft();
  Parser trimNewlineRight() => this.$.trimNewlineRight();

  Parser t() => trim();
  Parser tl() => trimLeft();
  Parser tr() => trimRight();

  Parser tnl() => trimNewline();
  Parser tnlLeft() => trimNewlineLeft();
  Parser tnlRight() => trimNewlineRight();
}

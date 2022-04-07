import "package:parser_peg/internal_all.dart";

RegExpParser ws() => r"[ \t]*".r();
RegExpParser whitespace() => r"[ \t]*".r();
RegExpParser whitespaceNewline() => r"[ \t\n\r]*".r();

Parser trim(Parser parser) => whitespace >> parser << whitespace;
Parser trimLeft(Parser parser) => whitespace >> parser;
Parser trimRight(Parser parser) => parser << whitespace;

Parser trimNewline(Parser parser) => whitespaceNewline >> parser << whitespaceNewline;
Parser trimNewlineLeft(Parser parser) => whitespaceNewline >> parser;
Parser trimNewlineRight(Parser parser) => parser << whitespaceNewline;

extension ParserTrimmedExtension on Parser {
  Parser trim() => whitespace >> this << whitespace;
  Parser trimLeft() => whitespace >> this;
  Parser trimRight() => this << whitespace;

  Parser trimNewline() => whitespaceNewline >> this << whitespaceNewline;
  Parser trimNewlineLeft() => whitespaceNewline >> this;
  Parser trimNewlineRight() => this << whitespaceNewline;

  Parser t() => trim();
  Parser tl() => trimLeft();
  Parser tr() => trimRight();

  Parser tnl() => trimNewline();
  Parser tnlLeft() => trimNewlineLeft();
  Parser tnlRight() => trimNewlineRight();
}

extension LazyParserTrimmedExtension on LazyParser {
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

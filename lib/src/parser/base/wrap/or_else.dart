import "package:parser/internal_all.dart";

Parser orElseParser(Parser parser, ParseResult alternative) => parser.cache() | success(alternative);

Parser orElse(Object parser, ParseResult alternative) => orElseParser(parser.$, alternative);

extension ParserOrElseExtension on Parser {
  Parser orElse(ParseResult alternative) => orElseParser(this, alternative);
  Parser operator ~/(ParseResult alternative) => orElse(alternative);
}

extension LazyParserOrElseExtension on LazyParser {
  Parser orElse(ParseResult alternative) => this.$.orElse(alternative);
  Parser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

extension StringOrElseExtension on String {
  Parser orElse(ParseResult alternative) => this.$.orElse(alternative);
  Parser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

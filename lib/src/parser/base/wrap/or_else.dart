import "package:parser_peg/internal_all.dart";

Parser orElseParser(Parser parser, ParseResult alternative) => parser.cache() | success(alternative);

Parser orElse(Object parser, ParseResult alternative) => orElseParser(parser.$, alternative);

extension OrElseExtension on Parser {
  Parser orElse(ParseResult alternative) => orElseParser(this, alternative);
  Parser operator ~/(ParseResult alternative) => orElse(alternative);
}

extension LazyOrElseExtension on LazyParser {
  Parser orElse(ParseResult alternative) => this.$.orElse(alternative);
  Parser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

extension StringOrElseExtension on String {
  Parser orElse(ParseResult alternative) => this.$.orElse(alternative);
  Parser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

import "package:parser_peg/internal_all.dart";

class OrElseParser extends SynthesizedParser {
  @override
  Parser synthesized;
  final ParseResult alternative;
  Parser get parser => children[0];

  OrElseParser(Parser parser, this.alternative)
      : synthesized = parser | success(alternative),
        super(<Parser>[parser]);

  @override
  OrElseParser cloneSelf() => OrElseParser(parser, alternative);
}

OrElseParser orElse(Parser parser, ParseResult alternative) => OrElseParser(parser, alternative);

extension OrElseExtension on Parser {
  OrElseParser orElse(ParseResult alternative) => OrElseParser(this, alternative);
  OrElseParser operator ~/(ParseResult alternative) => orElse(alternative);
}

extension LazyOrElseExtension on LazyParser {
  OrElseParser orElse(ParseResult alternative) => this.$.orElse(alternative);
  OrElseParser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

extension StringOrElseExtension on String {
  OrElseParser orElse(ParseResult alternative) => this.$.orElse(alternative);
  OrElseParser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

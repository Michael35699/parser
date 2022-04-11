import "package:parser_peg/internal_all.dart";

class UnmappedParser extends WrapParser {
  @override
  Parser get parser => children[0];

  UnmappedParser(Parser parser) : super(<Parser>[parser]);
  UnmappedParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context) => parser.apply(context.copyWith.state(map: false));

  @override
  Parser get base => parser.base;

  @override
  UnmappedParser empty() => UnmappedParser.empty();
}

extension UnmappedParserExtension on Parser {
  UnmappedParser unmapped() => UnmappedParser(this);
}

extension LazyUnmappedParserExtension on LazyParser {
  UnmappedParser unmapped() => this.$.unmapped();
}

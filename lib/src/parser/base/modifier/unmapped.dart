import "package:parser_peg/internal_all.dart";

class UnmappedParser extends WrapParser {
  Parser get parser => children[0];

  UnmappedParser(Parser parser) : super(<Parser>[parser]);

  @override
  Context parse(Context context, MemoizationHandler handler) =>
      parser.parseCtx(context.copyWith.state(map: false), handler);

  @override
  UnmappedParser cloneSelf() => UnmappedParser(parser);

  @override
  Parser get base => parser.base;
}

extension UnmappedParserExtension on Parser {
  UnmappedParser unmapped() => UnmappedParser(this);
}

extension LazyUnmappedParserExtension on LazyParser {
  UnmappedParser unmapped() => this.$.unmapped();
}

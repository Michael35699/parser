import "package:parser/internal_all.dart";

class UnmappedParser extends WrapParser {
  @override
  Parser get parser => children[0];

  UnmappedParser(Parser parser) : super(<Parser>[parser]);
  UnmappedParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) =>
      parser.pegApply(context.copyWith.state(map: false), mutable);

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      trampoline.push(parser, context.copyWith.state(map: false), continuation);

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

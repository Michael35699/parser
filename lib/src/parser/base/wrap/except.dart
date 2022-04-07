import "package:parser_peg/internal_all.dart";

class ExceptParser extends WrapParser {
  Parser get parser => children[0];
  Parser get except => children[1];

  ExceptParser(Parser parser, Parser except) : super(<Parser>[parser, except]);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    Context result = except.parseCtx(context, handler).maybeMap(
          failure: (_) => parser.parseCtx(context, handler),
          orElse: () => context.failure("Failed except parser"),
        );

    return result;
  }

  @override
  ExceptParser cloneSelf() => ExceptParser(parser, except);

  @override
  Parser get base => parser.base;
}

extension ParserExceptExtension on Parser {
  ExceptParser except(Object other) => ExceptParser(this, other.$);
  ExceptParser operator -(Object other) => except(other);
}

extension LazyParserExceptExtension on LazyParser {
  ExceptParser except(Object other) => this.$.except(other);
  ExceptParser operator -(Object other) => except(other);
}

extension StringParserExceptExtension on String {
  ExceptParser except(Object other) => this.$.except(other);
  ExceptParser operator -(Object other) => except(other);
}

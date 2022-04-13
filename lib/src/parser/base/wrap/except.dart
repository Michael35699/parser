import "package:parser/internal_all.dart";

class ExceptParser extends WrapParser {
  @override
  Parser get parser => children[0];
  Parser get except => children[1];

  ExceptParser(Parser parser, Parser except) : super(<Parser>[parser, except]);
  ExceptParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context result = except.pegApply(context, mutable).maybeMap(
          failure: (_) => parser.pegApply(context, mutable),
          orElse: () => context.failure("Failed except parser"),
        );

    return result;
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(except, context, (Context ctx) {
      ctx.map(
        success: (ContextSuccess ctx) => continuation(context.failure("Failed except parser")),
        ignore: (ContextIgnore ctx) => continuation(context.failure("Failed except parser")),
        failure: (ContextFailure ctx) => trampoline.push(parser, context, continuation),
      );
    });
  }

  @override
  Parser get base => parser.base;

  @override
  ExceptParser empty() => ExceptParser.empty();
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

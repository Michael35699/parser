import "package:parser/internal_all.dart";

class OptionalParser extends WrapParser {
  @override
  Parser get parser => children[0];

  OptionalParser(Parser parser) : super(<Parser>[parser]);
  OptionalParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context result = handler.apply(parser, context);
    if (result is! ContextFailure) {
      return result;
    } else {
      return context.success(null);
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context context) {
      if (context is! ContextFailure) {
        continuation(context);
      } else {
        continuation(context.success(null));
      }
    });
  }

  @override
  OptionalParser empty() => OptionalParser.empty();
}

OptionalParser optional(Parser parser) => OptionalParser(parser);

extension ParserOptionalExtension on Parser {
  OptionalParser optional() => OptionalParser(this);
}

extension LazyParserOptionalExtension on LazyParser {
  OptionalParser optional() => this.$.optional();
}

extension StringOptionalExtension on String {
  OptionalParser optional() => this.$.optional();
}

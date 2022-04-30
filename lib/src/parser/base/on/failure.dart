import "package:parser/internal_all.dart";

class OnFailureParser extends WrapParser {
  @override
  Parser get parser => children[0];

  final String message;

  OnFailureParser(Parser parser, this.message) : super(<Parser>[parser]);
  OnFailureParser.empty(this.message) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context ctx = parser.pegApply(context, mutable);

    if (ctx is! ContextFailure) {
      return ctx;
    } else {
      return ctx.failure(message);
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context context) {
      if (context is! ContextFailure) {
        continuation(context);
      } else {
        continuation(context.failure(message));
      }
    });
  }

  @override
  Parser get base => parser.base;

  @override
  OnFailureParser empty() => OnFailureParser.empty(message);
}

extension ParserOnFailureExtension on Parser {
  OnFailureParser failure(String message) => OnFailureParser(this, message);
}

extension LazyParserOnFailureParserExtension on LazyParser {
  OnFailureParser failure(String message) => this.$.failure(message);
}

extension StringOnFailureParserExtension on String {
  OnFailureParser failure(String message) => this.$.failure(message);
}

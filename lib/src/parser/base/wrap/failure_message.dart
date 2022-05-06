import "package:parser/internal_all.dart";

class FailureMessageParser extends WrapParser {
  @override
  Parser get parser => children[0];

  final String message;

  FailureMessageParser(Parser parser, this.message) : super(<Parser>[parser]);
  FailureMessageParser.empty(this.message) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);

    if (ctx is! ContextFailure) {
      return ctx;
    } else {
      return ctx.failure(message).generated();
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context context) {
      if (context is! ContextFailure) {
        continuation(context);
      } else {
        continuation(context.failure(message).generated());
      }
    });
  }

  @override
  FailureMessageParser empty() => FailureMessageParser.empty(message);
}

extension ParserFailureMessageExtension on Parser {
  FailureMessageParser message(String message) => FailureMessageParser(this, message);
}

extension LazyParserFailureMessageExtension on LazyParser {
  FailureMessageParser message(String message) => this.$.message(message);
}

extension StringFailureMessageExtension on String {
  FailureMessageParser message(String message) => this.$.message(message);
}

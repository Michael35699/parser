import "package:parser/internal_all.dart";

class OnSuccessParser extends WrapParser {
  @override
  Parser get parser => children[0];

  final ParseResult value;

  OnSuccessParser(Parser parser, this.value) : super(<Parser>[parser]);
  OnSuccessParser.empty(this.value) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);

    if (ctx is! ContextFailure) {
      return ctx.success(value);
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is! ContextFailure) {
        continuation(ctx.success(value));
      } else {
        continuation(ctx);
      }
    });
  }

  @override
  OnSuccessParser empty() => OnSuccessParser.empty(value);
}

extension ParserOnSuccessExtension on Parser {
  OnSuccessParser success(ParseResult value) => OnSuccessParser(this, value);
}

extension LazyParserOnSuccessExtension on LazyParser {
  OnSuccessParser success(ParseResult value) => this.$.success(value);
}

extension StringOnSuccessExtension on String {
  OnSuccessParser success(ParseResult value) => this.$.success(value);
}

OnSuccessParser onSuccess(Object parser, ParseResult value) => OnSuccessParser(parser.$, value);

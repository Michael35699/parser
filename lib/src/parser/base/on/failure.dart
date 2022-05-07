import "package:parser/internal_all.dart";

class OnFailureParser extends WrapParser {
  @override
  Parser get parser => children[0];

  final ParseResult value;

  OnFailureParser(Parser parser, this.value) : super(<Parser>[parser]);
  OnFailureParser.empty(this.value) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);

    if (ctx is ContextFailure) {
      return context.success(value);
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextFailure) {
        continuation(context.success(value));
      } else {
        continuation(ctx);
      }
    });
  }

  @override
  OnFailureParser empty() => OnFailureParser.empty(value);
}

OnFailureParser onFailureParser(Parser parser, ParseResult alternative) => OnFailureParser(parser, alternative);
OnFailureParser onFailure(Object parser, ParseResult alternative) => onFailureParser(parser.$, alternative);

extension ParserOnFailureExtension on Parser {
  OnFailureParser failure(ParseResult alternative) => onFailureParser(this, alternative);
  OnFailureParser operator ~/(ParseResult alternative) => failure(alternative);
}

extension LazyParserOnFailureExtension on LazyParser {
  OnFailureParser failure(ParseResult alternative) => this.$.failure(alternative);
  OnFailureParser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

extension StringOnFailureExtension on String {
  OnFailureParser failure(ParseResult alternative) => this.$.failure(alternative);
  OnFailureParser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

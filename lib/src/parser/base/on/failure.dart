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
      return ctx.success(value);
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context context) {
      if (context is ContextFailure) {
        continuation(context.success(value));
      } else {
        continuation(context);
      }
    });
  }

  @override
  OnSuccessParser empty() => OnSuccessParser.empty(value);
}

OnFailureParser onFailureParser(Parser parser, ParseResult alternative) => OnFailureParser(parser, alternative);
OnFailureParser onFailure(Object parser, ParseResult alternative) => onFailureParser(parser.$, alternative);

extension ParserOnFailureExtension on Parser {
  Parser onFailure(ParseResult alternative) => onFailureParser(this, alternative);
  Parser operator ~/(ParseResult alternative) => onFailure(alternative);
}

extension LazyParserOnFailureExtension on LazyParser {
  Parser onFailure(ParseResult alternative) => this.$.onFailure(alternative);
  Parser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

extension StringOnFailureExtension on String {
  Parser onFailure(ParseResult alternative) => this.$.onFailure(alternative);
  Parser operator ~/(ParseResult alternative) => this.$ ~/ alternative;
}

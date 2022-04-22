import "package:parser/internal_all.dart";

class OnSuccessParser extends WrapParser {
  @override
  Parser get parser => children[0];

  final Object? value;

  OnSuccessParser(Parser parser, this.value) : super(<Parser>[parser]);
  OnSuccessParser.empty(this.value) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context ctx = parser.pegApply(context, mutable);

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
  Parser get base => parser.base;

  @override
  OnSuccessParser empty() => OnSuccessParser.empty(value);
}

extension OnSuccessParserExtension on Parser {
  OnSuccessParser success(String message) => OnSuccessParser(this, message);
}

extension LazyOnSuccessParserExtension on LazyParser {
  OnSuccessParser success(String message) => this.$.success(message);
}

extension StringOnSuccessParserExtension on String {
  OnSuccessParser success(String message) => this.$.success(message);
}

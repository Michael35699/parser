import "package:parser/internal_all.dart";

class DropLeftParser extends WrapParser with SequentialParser {
  Parser get left => children[0];
  @override
  Parser get parser => children[1];

  DropLeftParser(Parser left, Parser parser) : super(<Parser>[left, parser]);
  DropLeftParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(left, context);
    if (ctx is ContextFailure) {
      return ctx;
    }

    return handler.apply(parser, ctx);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(left, context, (Context ctx) {
      if (ctx is ContextFailure) {
        return continuation(ctx);
      }

      return trampoline.push(parser, ctx, continuation);
    });
  }

  @override
  DropLeftParser empty() => DropLeftParser.empty();
}

extension ParserDropLeftExtension on Parser {
  DropLeftParser dropLeft(Object right) => DropLeftParser(this, right.$);
  Parser operator >>(Object right) => dropLeft(right);
}

extension LazyParserDropLeftParserExtension on LazyParser {
  DropLeftParser dropLeft(Object right) => this.$.dropLeft(right);
  Parser operator >>(Object right) => this.$ >> right;
}

extension StringDropLeftParserExtension on String {
  DropLeftParser dropLeft(Object right) => this.$.dropLeft(right);
  Parser operator >>(Object right) {
    if (right is String) {
      return this.urng(right);
    }
    return this.$ >> right;
  }
}

import "package:parser/internal_all.dart";

class DropParser extends WrapParser {
  @override
  Parser get parser => children[0];

  DropParser(Parser parser) : super(<Parser>[parser]);
  DropParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);

    if (ctx is! ContextFailure) {
      return ctx.empty();
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context context) {
      if (context is! ContextFailure) {
        continuation(context.empty());
      } else {
        continuation(context);
      }
    });
  }

  @override
  Parser get base => parser.base;

  @override
  DropParser empty() => DropParser.empty();
}

DropParser drop(Object parser) => DropParser(parser.$);

extension ParserDropExtension on Parser {
  DropParser drop() => DropParser(this);
  DropParser operator -() => drop();
}

extension LazyParserDropExtension on LazyParser {
  DropParser drop() => this.$.drop();
  DropParser operator -() => -this.$;
}

extension StringDropExtension on String {
  DropParser drop() => this.$.drop();
  DropParser operator -() => -this.$;
}

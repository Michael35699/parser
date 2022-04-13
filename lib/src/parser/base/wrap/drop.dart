import "package:parser/internal_all.dart";

class DropParser extends WrapParser {
  @override
  Parser get parser => children[0];

  DropParser(Parser parser) : super(<Parser>[parser]);
  DropParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    Context ctx = parser.pegApply(context, mutable);

    if (ctx is! ContextFailure) {
      return ctx.ignore();
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, Continuation continuation) {
    trampoline.push(parser, context, (Context context) {
      if (context is! ContextFailure) {
        continuation(context.ignore());
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

extension DropExtension on Parser {
  DropParser drop() => DropParser(this);
  DropParser operator -() => drop();
}

extension LazyDropExtension on LazyParser {
  DropParser drop() => this.$.drop();
  DropParser operator -() => -this.$;
}

extension StringDropExtension on String {
  DropParser drop() => this.$.drop();
  DropParser operator -() => -this.$;
}

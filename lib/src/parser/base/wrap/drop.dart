import "package:parser_peg/internal_all.dart";

class DropParser extends WrapParser {
  Parser get parser => children[0];

  DropParser(Parser parser) : super(<Parser>[parser]);
  DropParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    Context ctx = parser.parseCtx(context, handler);

    if (ctx is! ContextFailure) {
      return ctx.ignore();
    } else {
      return ctx;
    }
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

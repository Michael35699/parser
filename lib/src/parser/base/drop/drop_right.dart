import "package:parser_peg/internal_all.dart";

class DropRightParser extends WrapParser {
  Parser get parser => children[0];
  Parser get right => children[1];

  DropRightParser(Parser parser, Parser right) : super(<Parser>[parser, right]);
  DropRightParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    Context ctx = parser.parseCtx(context, handler);
    if (ctx is ContextFailure) {
      return ctx;
    }

    Context last = right.parseCtx(ctx, handler);
    if (last is ContextFailure) {
      return last;
    }

    if (ctx is ContextSuccess) {
      return last.success(ctx.mappedResult, ctx.unmappedResult);
    }

    return last.ignore();
  }

  @override
  DropRightParser cloneSelf(Map<Parser, Parser> cloned) => DropRightParser(parser, right);

  @override
  Parser get base => parser.base;

  @override
  DropRightParser empty() => DropRightParser.empty();
}

extension DropRightParserExtension on Parser {
  DropRightParser dropRight(Object right) => DropRightParser(this, right.$);
  DropRightParser operator <<(Object right) => dropRight(right);
}

extension LazyDropRightParserExtension on LazyParser {
  DropRightParser dropRight(Object right) => this.$.dropRight(right);
  DropRightParser operator <<(Object right) => this.$ << right;
}

extension StringDropRightParserExtension on String {
  DropRightParser dropRight(Object right) => this.$.dropRight(right);
  DropRightParser operator <<(Object right) => this.$ << right;
}

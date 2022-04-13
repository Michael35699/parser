import "package:parser/internal_all.dart";

class DropRightParser extends WrapParser with SequentialParser {
  @override
  Parser get parser => children[0];
  Parser get right => children[1];

  DropRightParser(Parser parser, Parser right) : super(<Parser>[parser, right]);
  DropRightParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserMutable mutable) {
    Context ctx = parser.apply(context, mutable);
    if (ctx is ContextFailure) {
      return ctx;
    }

    Context last = right.apply(ctx, mutable);
    if (last is ContextFailure) {
      return last;
    }

    if (ctx is ContextSuccess) {
      return last.success(ctx.mappedResult, ctx.unmappedResult);
    }

    return last;
  }

  @override
  Parser get base => parser.base;

  @override
  DropRightParser empty() => DropRightParser.empty();
}

extension DropRightParserExtension on Parser {
  DropRightParser dropRight(Object right) => DropRightParser(this, right.$);
  Parser operator <<(Object right) {
    Parser self = this;
    if (self is DropLeftParser) {
      return self.parser.dropLeftRight(self.left, right);
    } else {
      return dropRight(right);
    }
  }
}

extension LazyDropRightParserExtension on LazyParser {
  DropRightParser dropRight(Object right) => this.$.dropRight(right);
  Parser operator <<(Object right) => this.$ << right;
}

extension StringDropRightParserExtension on String {
  DropRightParser dropRight(Object right) => this.$.dropRight(right);
  Parser operator <<(Object right) => this.$ << right;
}

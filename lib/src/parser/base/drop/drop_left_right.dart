import "package:parser/internal_all.dart";

class DropLeftRightParser extends WrapParser with SequentialParser {
  Parser get left => children[0];
  @override
  Parser get parser => children[1];
  Parser get right => children[2];

  DropLeftRightParser(Parser left, Parser parser, Parser right) : super(<Parser>[left, parser, right]);
  DropLeftRightParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserMutable mutable) {
    Context ctx = left.apply(context, mutable);
    if (ctx is ContextFailure) {
      return ctx;
    }

    Context res = parser.apply(ctx, mutable);
    if (res is ContextFailure) {
      return res;
    }

    Context last = right.apply(res, mutable);
    if (last is ContextFailure) {
      return last;
    }

    if (res is ContextSuccess) {
      return last.success(res.mappedResult, res.unmappedResult);
    }

    return last.ignore();
  }

  @override
  Parser get base => parser.base;

  @override
  DropLeftRightParser empty() => DropLeftRightParser.empty();
}

extension DropLeftRightParserExtension on Parser {
  DropLeftRightParser dropLeftRight(Object left, Object right) => DropLeftRightParser(left.$, this, right.$);
}

extension LazyDropLeftRightParserExtension on LazyParser {
  DropLeftRightParser dropLeftRight(Object left, Object right) => this.$.dropLeftRight(left, right);
}

extension StringDropLeftRightParserExtension on String {
  DropLeftRightParser dropLeftRight(Object left, Object right) => this.$.dropLeftRight(left, right);
}

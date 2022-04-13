import "package:parser_peg/internal_all.dart";

class DropLeftParser extends WrapParser with SequentialParser {
  Parser get left => children[0];
  @override
  Parser get parser => children[1];

  DropLeftParser(Parser left, Parser parser) : super(<Parser>[left, parser]);
  DropLeftParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserMutable mutable) {
    Context ctx = left.apply(context, mutable);
    if (ctx is ContextFailure) {
      return ctx;
    }

    return parser.apply(ctx, mutable);
  }

  @override
  Parser get base => parser.base;

  @override
  DropLeftParser empty() => DropLeftParser.empty();
}

extension DropLeftParserExtension on Parser {
  DropLeftParser dropLeft(Object right) => DropLeftParser(this, right.$);
  Parser operator >>(Object right) => dropLeft(right);
}

extension LazyDropLeftParserExtension on LazyParser {
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

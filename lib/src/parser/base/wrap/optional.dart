import "package:parser_peg/internal_all.dart";

class OptionalParser extends WrapParser {
  @override
  Parser get parser => children[0];

  OptionalParser(Parser parser) : super(<Parser>[parser]);
  OptionalParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserMutable mutable) {
    Context result = parser.apply(context, mutable);
    if (result is! ContextFailure) {
      return result;
    } else {
      return context.success(null);
    }
  }

  @override
  Parser get base => parser.base;

  @override
  OptionalParser empty() => OptionalParser.empty();
}

OptionalParser optional(Parser parser) => OptionalParser(parser);

extension OptionalExtension on Parser {
  OptionalParser optional() => OptionalParser(this);
}

extension LazyOptionalExtension on LazyParser {
  OptionalParser optional() => this.$.optional();
}

extension StringOptionalExtension on String {
  OptionalParser optional() => this.$.optional();
}

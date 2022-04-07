import "package:parser_peg/internal_all.dart";

Parser _optional(Parser parser) => parser | success(null);

Parser optional(Parser parser) => _optional(parser);

extension OptionalExtension on Parser {
  Parser optional() => _optional(this);
}

extension LazyOptionalExtension on LazyParser {
  Parser optional() => _optional(this.$);
}

extension StringOptionalExtension on String {
  Parser optional() => _optional(this.$);
}

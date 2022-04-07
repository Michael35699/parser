import "package:parser_peg/internal_all.dart";

extension GeneralParserExtension<T extends Object> on T {
  Parser get $ => Parser.resolve(this);
}

extension LazyParserMethodsExtension on LazyParser {
  Context runCtx(String input, {bool? map, bool? end}) => this.$.runCtx(input, map: map, end: end);
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => this.$.run(input, map: map, end: end);
  Parser build() => this.$.build();

  ThunkParser thunk() => ThunkParser(this);
}

extension RunParserMethodExtension<R> on T Function<T extends R>(String, {bool? map, bool? end}) {
  R unmapped(String input, {bool? map, bool? end}) => this(input, map: false, end: end);
}

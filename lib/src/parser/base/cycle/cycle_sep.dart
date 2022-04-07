import "package:parser_peg/internal_all.dart";

Parser cycleSeparatedParser(Parser parser, Parser separator) =>
    (parser.cache() & (separator.cache() & parser.cache()).star).map(
        $2((ParseResult left, List<ParseResult> rest) =>
            <ParseResult>[left, for (List<ParseResult> item in rest.cast()) ...item]),
        replace: true);

Parser cycleSeparated(Object main, Object sep) => cycleSeparatedParser(main.$, sep.$);

extension CycleSeparatedExtension on Parser {
  Parser cycleSep(Object separator) => cycleSeparatedParser(this, separator.$);
  Parser sep(Object separator) => cycleSep(separator);
  Parser sepBy(Object separator) => cycleSep(separator);
  Parser operator %(Object separator) => cycleSep(separator);
}

extension LazyCycleSeparatedExtension on LazyParser {
  Parser cycleSep(Object separator) => this.$.cycleSep(separator);
  Parser sepBy(Object separator) => this.$.sepBy(separator);
  Parser sep(Object separator) => this.$.sep(separator);
  Parser operator %(Object separator) => this.$ % separator;
}

extension StringCycleSeparatedExtension on String {
  Parser cycleSep(Object separator) => this.$.cycleSep(separator);
  Parser sep(Object separator) => this.$.sepBy(separator);
  Parser sepBy(Object separator) => this.$.sepBy(separator);
  Parser operator %(Object separator) => this.$ % separator;
}

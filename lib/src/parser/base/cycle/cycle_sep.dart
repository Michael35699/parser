import "package:parser_peg/internal_all.dart";

class CycleSeparatedParser extends SynthesizedParser {
  @override
  Parser synthesized;

  Parser get parser => children[0];
  Parser get separator => children[1];

  CycleSeparatedParser(Parser parser, Parser separator)
      : synthesized = (parser.cache() & (separator.cache() & parser.cache()).star).map(
            $2((ParseResult left, List<ParseResult> rest) =>
                <ParseResult>[left, for (List<ParseResult> item in rest.cast()) ...item]),
            replace: true),
        super(<Parser>[parser, separator]);

  @override
  CycleSeparatedParser cloneSelf() => CycleSeparatedParser(parser, separator);
}

CycleSeparatedParser cycleSeparated(Object main, Object sep) => CycleSeparatedParser(main.$, sep.$);

extension CycleSeparatedExtension on Parser {
  CycleSeparatedParser cycleSep(Object separator) => CycleSeparatedParser(this, separator.$);
  CycleSeparatedParser sep(Object separator) => cycleSep(separator);
  CycleSeparatedParser sepBy(Object separator) => cycleSep(separator);
  CycleSeparatedParser operator %(Object separator) => cycleSep(separator);
}

extension LazyCycleSeparatedExtension on LazyParser {
  CycleSeparatedParser cycleSep(Object separator) => this.$.cycleSep(separator);
  CycleSeparatedParser sepBy(Object separator) => this.$.sepBy(separator);
  CycleSeparatedParser sep(Object separator) => this.$.sep(separator);
  CycleSeparatedParser operator %(Object separator) => this.$ % separator;
}

extension StringCycleSeparatedExtension on String {
  CycleSeparatedParser cycleSep(Object separator) => this.$.cycleSep(separator);
  CycleSeparatedParser sep(Object separator) => this.$.sepBy(separator);
  CycleSeparatedParser sepBy(Object separator) => this.$.sepBy(separator);
  CycleSeparatedParser operator %(Object separator) => this.$ % separator;
}

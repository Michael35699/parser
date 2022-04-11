import "package:parser_peg/internal_all.dart";

// Parser cycleSeparatedParser(Parser parser, Parser separator) =>
//     (parser.cache() & (separator.cache() & parser.cache()).star()).map(
//         $2((ParseResult left, List<ParseResult> rest) =>
//             <ParseResult>[left, for (List<ParseResult> item in rest.cast()) ...item]),
//         replace: true);

class CycleSeparatedParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  Parser get separator => children[1];

  CycleSeparatedParser(Parser parser, Parser separator) : super(<Parser>[parser, separator]);
  CycleSeparatedParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserEngine engine) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = engine.apply(parser, context);
    if (ctx is ContextFailure) {
      return ctx;
    }
    ctx.addResult(mapped, unmapped);

    for (;;) {
      Context temp1 = engine.apply(parser, ctx);
      if (temp1 is ContextFailure) {
        break;
      }
      temp1.addResult(mapped, unmapped);

      Context temp2 = engine.apply(parser, temp1);
      if (temp2 is ContextFailure) {
        break;
      }
      temp2.addResult(mapped, unmapped);

      ctx = temp2;
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  CycleSeparatedParser empty() => CycleSeparatedParser.empty();

  @override
  Parser get base => parser.base;
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

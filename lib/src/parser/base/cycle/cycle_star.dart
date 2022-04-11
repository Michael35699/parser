import "package:parser_peg/internal_all.dart";

// Parser cycleStarParser(Parser parser) => parser.cycle() | success(const <ParseResult>[]);

class CycleStarParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];

  CycleStarParser(Parser parser) : super(<Parser>[parser]);
  CycleStarParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserEngine engine) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = context;
    for (;;) {
      Context temp = engine.apply(parser, ctx);
      if (temp is ContextFailure) {
        break;
      }
      temp.addResult(mapped, unmapped);

      ctx = temp;
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  CycleStarParser empty() => CycleStarParser.empty();

  @override
  Parser get base => parser.base;
}

CycleStarParser cycleStar(Object parser) => CycleStarParser(parser.$);

extension CycleStarExtension on Parser {
  CycleStarParser cycleStar() => CycleStarParser(this);
  CycleStarParser star() => cycleStar();
}

extension LazyCycleStarExtension on LazyParser {
  CycleStarParser cycleStar() => this.$.cycleStar();
  CycleStarParser star() => this.$.star();
}

extension StringCycleStarExtension on String {
  CycleStarParser cycleStar() => this.$.cycleStar();
  CycleStarParser star() => this.$.star();
}

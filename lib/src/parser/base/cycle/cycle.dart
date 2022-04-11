import "package:parser_peg/internal_all.dart";

class CycleParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];

  CycleParser(Parser parser) : super(<Parser>[parser]);
  CycleParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserEngine engine) {
    Context ctx = parser.apply(context, engine);
    if (ctx.isFailure) {
      return ctx;
    }

    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];
    ctx.addResult(mapped, unmapped);

    for (;;) {
      Context temp = parser.apply(ctx, engine);
      if (temp.isFailure) {
        break;
      }

      ctx = temp..addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  Parser get base => parser.base;

  @override
  CycleParser empty() => CycleParser.empty();
}

extension CycleExtension on Parser {
  CycleParser cycle() => CycleParser(this);
  CycleParser plus() => cycle();
}

extension LazyCycleExtension on LazyParser {
  CycleParser cycle() => this.$.cycle();
  CycleParser plus() => this.$.plus();
}

extension StringCycleExtension on String {
  CycleParser cycle() => this.$.cycle();
  CycleParser plus() => this.$.plus();
}

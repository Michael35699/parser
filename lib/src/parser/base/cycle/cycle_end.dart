import "package:parser_peg/internal_all.dart";

class CycleEndParser extends WrapParser {
  CycleEndParser(Parser parser) : super(<Parser>[parser]);
  CycleEndParser.empty() : super(<Parser>[]);

  Parser get parser => children[0];

  @override
  Context parse(Context context, MemoizationHandler handler) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];
    Context ctx = context;

    while (ctx.state.index < ctx.state.input.length) {
      ctx = parser.parseCtx(ctx, handler);
      if (ctx.isFailure) {
        return ctx;
      }

      ctx.addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  Parser get base => parser.base;

  @override
  CycleEndParser empty() => CycleEndParser.empty();
}

extension CycleEndExtension on Parser {
  Parser cycleEnd() => CycleEndParser(this);
}

extension LazyCycleEndExtension on LazyParser {
  Parser cycleEnd() => this.$.cycleEnd();
}

extension StringCycleEndExtension on String {
  Parser cycleEnd() => this.$.cycleEnd();
}

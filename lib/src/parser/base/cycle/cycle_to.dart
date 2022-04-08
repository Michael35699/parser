import "package:parser_peg/internal_all.dart";

class CycleToParser extends WrapParser {
  Parser get parser => children[0];
  Parser get delimiter => children[1];

  CycleToParser(Parser delimiter, Parser parser) : super(<Parser>[parser, delimiter]);
  CycleToParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];
    Context ctx = context;
    if (!delimiter.parseCtx(ctx, handler).isFailure) {
      return ctx.failure("Delimiter detected");
    }

    ctx = parser.parseCtx(ctx, handler);
    if (ctx.isFailure) {
      return ctx;
    }

    ctx.addResult(mapped, unmapped);
    for (;;) {
      if (!delimiter.parseCtx(ctx, handler).isFailure) {
        break;
      }

      Context temp = parser.parseCtx(ctx, handler);
      if (ctx.isFailure) {
        break;
      }

      ctx = temp..addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  Parser get base => parser.base;

  @override
  CycleToParser empty() => CycleToParser.empty();
}

extension CycleToExtension on Parser {
  Parser cycleTo(Object delimiter) => CycleToParser(Parser.resolve(delimiter), this);
  Parser operator >>>(Object delimiter) => cycleTo(delimiter);
}

extension LazyCycleToExtension on LazyParser {
  Parser cycleTo(Object delimiter) => this.$.cycleTo(delimiter);
  Parser operator >>>(Object delimiter) => this.$ >>> delimiter;
}

extension StringCycleToExtension on String {
  Parser cycleTo(Object delimiter) => this.$.cycleTo(delimiter);
  Parser operator >>>(Object delimiter) => this.$ >>> delimiter;
}

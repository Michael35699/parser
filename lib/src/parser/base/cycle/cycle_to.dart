import "package:parser/internal_all.dart";

class CycleToParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  Parser get delimiter => children[1];

  CycleToParser(Parser delimiter, Parser parser) : super(<Parser>[parser, delimiter]);
  CycleToParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserMutable mutable) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];
    Context ctx = context;
    if (delimiter.apply(ctx, mutable) is! ContextFailure) {
      return ctx.failure("Delimiter detected");
    }

    ctx = parser.apply(ctx, mutable);
    if (ctx.isFailure) {
      return ctx;
    }

    ctx.addResult(mapped, unmapped);
    for (;;) {
      if (delimiter.apply(ctx, mutable) is! ContextFailure) {
        break;
      }

      Context temp = parser.apply(ctx, mutable);
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
  Parser to(Object delimiter) => cycleTo(delimiter);
  Parser operator >>>(Object delimiter) => cycleTo(delimiter);
}

extension LazyCycleToExtension on LazyParser {
  Parser cycleTo(Object delimiter) => this.$.cycleTo(delimiter);
  Parser to(Object delimiter) => this.$.to(delimiter);
  Parser operator >>>(Object delimiter) => this.$ >>> delimiter;
}

extension StringCycleToExtension on String {
  Parser cycleTo(Object delimiter) => this.$.cycleTo(delimiter);
  Parser to(Object delimiter) => this.$.to(delimiter);
  Parser operator >>>(Object delimiter) => this.$ >>> delimiter;
}

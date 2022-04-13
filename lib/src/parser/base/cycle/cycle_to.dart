import "package:parser/internal_all.dart";

class CycleToParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  Parser get delimiter => children[1];

  CycleToParser(Parser delimiter, Parser parser) : super(<Parser>[parser, delimiter]);
  CycleToParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];
    Context ctx = context;
    if (delimiter.pegApply(ctx, mutable) is! ContextFailure) {
      return ctx.failure("Delimiter detected");
    }

    ctx = parser.pegApply(ctx, mutable);
    if (ctx.isFailure) {
      return ctx;
    }

    ctx.addResult(mapped, unmapped);
    for (;;) {
      if (delimiter.pegApply(ctx, mutable) is! ContextFailure) {
        break;
      }

      Context temp = parser.pegApply(ctx, mutable);
      if (ctx.isFailure) {
        break;
      }

      ctx = temp..addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    void run(Context context, List<ParseResult> mapped, List<ParseResult> unmapped) {
      trampoline.push(delimiter, context, (Context result) {
        result.map(
          success: (ContextSuccess result) => continuation(context.success(mapped, unmapped)),
          ignore: (ContextIgnore result) => continuation(result.success(mapped, unmapped)),
          failure: (ContextFailure result) {
            trampoline.push(parser, context, (Context result) {
              result.map(
                success: (ContextSuccess context) => run(
                  context,
                  <ParseResult>[...mapped, context.mappedResult],
                  <ParseResult>[...unmapped, context.unmappedResult],
                ),
                ignore: (ContextIgnore context) => run(context, mapped, unmapped),
                failure: continuation,
              );
            });
          },
        );
      });
    }

    trampoline.push(delimiter, context, (Context context) {
      context.map(
        success: (ContextSuccess context) => continuation(context.failure(unexpected("delimiter"))),
        ignore: (ContextIgnore context) => continuation(context.failure(unexpected("delimiter"))),
        failure: (ContextFailure context) {
          trampoline.push(parser, context, (Context context) {
            context.map(
              success: (ContextSuccess context) => run(
                context,
                <ParseResult>[context.mappedResult],
                <ParseResult>[context.unmappedResult],
              ),
              ignore: (ContextIgnore context) => run(context, <ParseResult>[], <ParseResult>[]),
              failure: continuation,
            );
          });
        },
      );
    });
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

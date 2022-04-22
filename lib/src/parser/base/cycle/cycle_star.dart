import "package:parser/internal_all.dart";

// Parser cycleStarParser(Parser parser) => parser.cycle() | success(const <ParseResult>[]);

class CycleStarParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];

  CycleStarParser(Parser parser) : super(<Parser>[parser]);
  CycleStarParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = context;
    for (;;) {
      Context temp = parser.pegApply(ctx, mutable);
      if (temp is ContextFailure) {
        break;
      }
      temp.addResult(mapped, unmapped);

      ctx = temp;
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    void run(Context context, List<dynamic> mapped, List<dynamic> unmapped) {
      trampoline.push(parser, context, (Context result) {
        result.map(
          success: (ContextSuccess context) => run(
            context,
            <ParseResult>[...mapped, context.mappedResult],
            <ParseResult>[...unmapped, context.unmappedResult],
          ),
          ignore: (ContextIgnore context) => run(context, mapped, unmapped),
          failure: (ContextFailure context) => continuation(context.success(mapped, unmapped)),
        );
      });
    }

    trampoline.push(parser, context, (Context ctx) {
      ctx.map(
        success: (ContextSuccess ctx) => run(ctx, <ParseResult>[ctx.mappedResult], <ParseResult>[ctx.unmappedResult]),
        ignore: (ContextIgnore ctx) => run(ctx, <ParseResult>[], <ParseResult>[]),
        failure: (ContextFailure ctx) => continuation(context.success(<ParseResult>[], <ParseResult>[])),
      );
    });
  }

  @override
  CycleStarParser empty() => CycleStarParser.empty();
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

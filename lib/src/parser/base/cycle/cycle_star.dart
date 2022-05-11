import "package:parser/internal_all.dart";

// Parser cycleStarParser(Parser parser) => parser.cycle() | success(const <ParseResult>[]);

class CycleStarParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];

  CycleStarParser(Parser parser) : super(<Parser>[parser]);
  CycleStarParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = context;
    for (;;) {
      Context temp = handler.apply(parser, ctx);
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
        if (result is ContextSuccess) {
          run(result, mapped << result.mappedResult, unmapped << result.unmappedResult);
        } else if (result is ContextEmpty) {
          run(result, mapped, unmapped);
        } else if (result is ContextFailure) {
          continuation(result.success(mapped, unmapped));
        }
      });
    }

    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextSuccess) {
        return run(ctx, <ParseResult>[ctx.mappedResult], <ParseResult>[ctx.unmappedResult]);
      } else if (ctx is ContextEmpty) {
        return run(ctx, <ParseResult>[], <ParseResult>[]);
      } else if (ctx is ContextFailure) {
        return continuation(context.success(<ParseResult>[], <ParseResult>[]));
      }
    });
  }

  @override
  CycleStarParser empty() => CycleStarParser.empty();
}

CycleStarParser cycleStar(Object parser) => CycleStarParser(parser.$);

extension ParserCycleStarExtension on Parser {
  CycleStarParser cycleStar() => CycleStarParser(this);
  CycleStarParser star() => cycleStar();
}

extension LazyParserCycleStarExtension on LazyParser {
  CycleStarParser cycleStar() => this.$.cycleStar();
  CycleStarParser star() => this.$.star();
}

extension StringCycleStarExtension on String {
  CycleStarParser cycleStar() => this.$.cycleStar();
  CycleStarParser star() => this.$.star();
}

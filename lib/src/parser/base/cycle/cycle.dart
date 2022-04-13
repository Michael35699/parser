import "package:parser/internal_all.dart";

class CycleParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];

  CycleParser(Parser parser) : super(<Parser>[parser]);
  CycleParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context ctx = parser.pegApply(context, mutable);
    if (ctx.isFailure) {
      return ctx;
    }

    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];
    ctx.addResult(mapped, unmapped);

    for (;;) {
      Context temp = parser.pegApply(ctx, mutable);
      if (temp.isFailure) {
        break;
      }

      ctx = temp..addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    void run(Context context, List<ParseResult> mapped, List<ParseResult> unmapped) {
      trampoline.push(parser, context, (Context context) {
        if (context is ContextSuccess) {
          run(context, mapped << context.mappedResult, unmapped << context.unmappedResult);
        } else if (context is ContextIgnore) {
          run(context, mapped, unmapped);
        } else {
          continuation(context.success(mapped, unmapped));
        }
      });
    }

    trampoline.push(parser, context, (Context context) {
      if (context is ContextSuccess) {
        run(context, <ParseResult>[context.mappedResult], <ParseResult>[context.unmappedResult]);
      } else if (context is ContextIgnore) {
        run(context, <ParseResult>[], <ParseResult>[]);
      } else {
        continuation(context);
      }
    });
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

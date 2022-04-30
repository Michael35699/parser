import "package:parser/internal_all.dart";

class CycleSeparatedParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  Parser get separator => children[1];

  CycleSeparatedParser(Parser parser, Parser separator) : super(<Parser>[parser, separator]);
  CycleSeparatedParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = parser.pegApply(context, mutable);
    if (ctx is ContextFailure) {
      return ctx;
    }
    ctx.addResult(mapped, unmapped);

    for (;;) {
      Context temp1 = separator.pegApply(ctx, mutable);
      if (temp1 is ContextFailure) {
        break;
      }
      temp1.addResult(mapped, unmapped);

      Context temp2 = parser.pegApply(temp1, mutable);
      if (temp2 is ContextFailure) {
        break;
      }
      temp2.addResult(mapped, unmapped);

      ctx = temp2;
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    void run(Context context, List<ParseResult> mapped, List<ParseResult> unmapped) {
      void parseMain(Context innerContext, ParseResult separator, {required bool putSeparator}) {
        trampoline.push(parser, innerContext, (Context result) {
          if (result is ContextSuccess) {
            run(result, <ParseResult>[
              ...mapped,
              if (putSeparator) separator,
              result.mappedResult,
            ], <ParseResult>[
              ...unmapped,
              if (putSeparator) separator,
              result.unmappedResult,
            ]);
          } else if (result is ContextIgnore) {
            run(result, <ParseResult>[
              ...mapped,
              if (putSeparator) separator,
            ], <ParseResult>[
              ...unmapped,
              if (putSeparator) separator,
            ]);
          } else {
            continuation(context.success(mapped, unmapped));
          }
        });
      }

      trampoline.push(separator, context, (Context context) {
        if (context is ContextSuccess) {
          parseMain(context, context.mappedResult, putSeparator: true);
        } else if (context is ContextIgnore) {
          parseMain(context, null, putSeparator: false);
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
  CycleSeparatedParser empty() => CycleSeparatedParser.empty();
}

CycleSeparatedParser cycleSeparated(Object main, Object sep) => CycleSeparatedParser(main.$, sep.$);

extension ParserCycleSeparatedExtension on Parser {
  CycleSeparatedParser cycleSep(Object separator) => CycleSeparatedParser(this, separator.$);
  CycleSeparatedParser sep(Object separator) => cycleSep(separator);
  CycleSeparatedParser sepBy(Object separator) => cycleSep(separator);
  CycleSeparatedParser operator %(Object separator) => cycleSep(separator);
}

extension LazyParserCycleSeparatedExtension on LazyParser {
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

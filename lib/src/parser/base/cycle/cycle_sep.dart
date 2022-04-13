import "package:parser/internal_all.dart";

// Parser cycleSeparatedParser(Parser parser, Parser separator) =>
//     (parser.cache() & (separator.cache() & parser.cache()).star()).map(
//         $2((ParseResult left, List<ParseResult> rest) =>
//             <ParseResult>[left, for (List<ParseResult> item in rest.cast()) ...item]),
//         replace: true);

class CycleSeparatedParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  Parser get separator => children[1];

  CycleSeparatedParser(Parser parser, Parser separator) : super(<Parser>[parser, separator]);
  CycleSeparatedParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) {
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
  void parseGll(Context context, Trampoline trampoline, Continuation continuation) {
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

      trampoline.push(separator, context, (Context r) {
        r.map(
          success: (ContextSuccess context) => parseMain(context, context.mappedResult, putSeparator: true),
          ignore: (ContextIgnore context) => parseMain(context, null, putSeparator: false),
          failure: (ContextFailure context) => continuation(context.success(mapped, unmapped)),
        );
      });
    }

    trampoline.push(parser, context, (Context context) {
      context.map(
        success: (ContextSuccess context) =>
            run(context, <ParseResult>[context.mappedResult], <ParseResult>[context.unmappedResult]),
        ignore: (ContextIgnore context) => run(context, <ParseResult>[], <ParseResult>[]),
        failure: continuation,
      );
    });
  }

  @override
  CycleSeparatedParser empty() => CycleSeparatedParser.empty();

  @override
  Parser get base => parser.base;
}

CycleSeparatedParser cycleSeparated(Object main, Object sep) => CycleSeparatedParser(main.$, sep.$);

extension CycleSeparatedExtension on Parser {
  CycleSeparatedParser cycleSep(Object separator) => CycleSeparatedParser(this, separator.$);
  CycleSeparatedParser sep(Object separator) => cycleSep(separator);
  CycleSeparatedParser sepBy(Object separator) => cycleSep(separator);
  CycleSeparatedParser operator %(Object separator) => cycleSep(separator);
}

extension LazyCycleSeparatedExtension on LazyParser {
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

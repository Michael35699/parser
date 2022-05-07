import "package:parser/internal_all.dart";

class CycleToParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  Parser get delimiter => children[1];

  CycleToParser(Parser delimiter, Parser parser) : super(<Parser>[parser, delimiter]);
  CycleToParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];
    Context ctx = context;
    if (handler.apply(delimiter, context) is! ContextFailure) {
      return ctx.failure(unexpected("delimiter"));
    }

    ctx = handler.apply(parser, ctx);
    if (ctx.isFailure) {
      return ctx;
    }

    ctx.addResult(mapped, unmapped);
    for (;;) {
      if (handler.apply(delimiter, context) is! ContextFailure) {
        break;
      }

      Context temp = handler.apply(parser, ctx);
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
      trampoline.push(delimiter, context, (Context result) {
        if (result is! ContextFailure) {
          return continuation(context.success(mapped, unmapped));
        }

        trampoline.push(parser, context, (Context result) {
          if (result is ContextSuccess) {
            run(result, mapped << result.mappedResult, unmapped << result.unmappedResult);
          } else if (result is ContextEmpty) {
            run(result, mapped, unmapped);
          } else {
            continuation(result);
          }
        });
      });
    }

    trampoline.push(delimiter, context, (Context context) {
      if (context is! ContextFailure) {
        return continuation(context.failure(unexpected("delimiter")));
      }

      trampoline.push(parser, context, (Context context) {
        if (context is ContextSuccess) {
          run(context, <ParseResult>[context.mappedResult], <ParseResult>[context.unmappedResult]);
        } else if (context is ContextEmpty) {
          run(context, <ParseResult>[], <ParseResult>[]);
        } else {
          continuation(context);
        }
      });
    });
  }

  @override
  CycleToParser empty() => CycleToParser.empty();
}

extension ParserCycleToExtension on Parser {
  Parser cycleTo(Object delimiter) => CycleToParser(Parser.resolve(delimiter), this);
  Parser to(Object delimiter) => cycleTo(delimiter);
  Parser operator >>>(Object delimiter) => cycleTo(delimiter);
}

extension LazyParserCycleToExtension on LazyParser {
  Parser cycleTo(Object delimiter) => this.$.cycleTo(delimiter);
  Parser to(Object delimiter) => this.$.to(delimiter);
  Parser operator >>>(Object delimiter) => this.$ >>> delimiter;
}

extension StringCycleToExtension on String {
  Parser cycleTo(Object delimiter) => this.$.cycleTo(delimiter);
  Parser to(Object delimiter) => this.$.to(delimiter);
  Parser operator >>>(Object delimiter) => this.$ >>> delimiter;
}

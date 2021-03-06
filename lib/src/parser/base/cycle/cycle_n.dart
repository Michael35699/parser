import "package:parser/internal_all.dart";

// Parser cycleNParser(Parser parser, int count) => SequenceParser(<Parser>[for (int _ in count.times) parser]);

class CycleNParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  final int count;

  CycleNParser(Parser parser, this.count) : super(<Parser>[parser]);
  CycleNParser.empty(this.count) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = context;
    for (int i = 0; i < count; i++) {
      ctx = handler.apply(parser, ctx);
      if (ctx is ContextFailure) {
        return ctx;
      }

      ctx.addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    void run(Context context, List<ParseResult> mapped, List<ParseResult> unmapped, int count) {
      if (count >= this.count) {
        return continuation(context.success(mapped, mapped));
      }

      trampoline.push(parser, context, (Context context) {
        if (context is ContextSuccess) {
          run(context, <ParseResult>[...mapped, context.mappedResult],
              <ParseResult>[...unmapped, context.unmappedResult], count + 1);
        } else if (context is ContextEmpty) {
          run(context, mapped, unmapped, count + 1);
        } else {
          continuation(context);
        }
      });
    }

    trampoline.push(parser, context, (Context context) {
      if (context is ContextSuccess) {
        run(context, <ParseResult>[context.mappedResult], <ParseResult>[context.unmappedResult], 1);
      } else if (context is ContextEmpty) {
        run(context, <ParseResult>[], <ParseResult>[], 1);
      } else {
        continuation(context);
      }
    });
  }

  @override
  CycleNParser empty() => CycleNParser.empty(count);
}

Parser cycleN(Object parser, int count) => CycleNParser(parser.$, count);

extension ParserCycleNExtension on Parser {
  CycleNParser cycleN(int c) => CycleNParser(this, c);
  CycleNParser times(int c) => cycleN(c);
  CycleNParser operator *(int c) => cycleN(c);
}

extension LazyParserCycleNExtension on LazyParser {
  CycleNParser cycleN(int c) => this.$.cycleN(c);
  CycleNParser times(int c) => this.$.times(c);
  CycleNParser operator *(int c) => this.$ * c;
}

extension StringCycleNExtension on String {
  CycleNParser cycleN(int c) => this.$.cycleN(c);
  CycleNParser times(int c) => this.$.times(c);
  CycleNParser operator *(int c) => this.$ * c;
}

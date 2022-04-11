import "package:parser_peg/internal_all.dart";

// Parser cycleNParser(Parser parser, int count) => SequenceParser(<Parser>[for (int _ in count.times) parser]);

class CycleNParser extends WrapParser with CyclicParser {
  @override
  Parser get parser => children[0];
  final int count;

  CycleNParser(Parser parser, this.count) : super(<Parser>[parser]);
  CycleNParser.empty(this.count) : super(<Parser>[]);

  @override
  Context parse(Context context, ParserEngine engine) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = context;
    for (int i = 0; i < count; i++) {
      ctx = engine.apply(parser, ctx);
      if (ctx is ContextFailure) {
        return ctx;
      }

      ctx.addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  CycleNParser empty() => CycleNParser.empty(count);

  @override
  Parser get base => parser.base;
}

Parser cycleN(Object parser, int count) => CycleNParser(parser.$, count);

extension CycleNExtension on Parser {
  CycleNParser cycleN(int c) => CycleNParser(this, c);
  CycleNParser times(int c) => cycleN(c);
  CycleNParser operator *(int c) => cycleN(c);
}

extension LazyCycleNExtension on LazyParser {
  CycleNParser cycleN(int c) => this.$.cycleN(c);
  CycleNParser times(int c) => this.$.times(c);
  CycleNParser operator *(int c) => this.$ * c;
}

extension StringCycleNExtension on String {
  CycleNParser cycleN(int c) => this.$.cycleN(c);
  CycleNParser times(int c) => this.$.times(c);
  CycleNParser operator *(int c) => this.$ * c;
}

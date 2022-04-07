import "package:parser_peg/internal_all.dart";

// class CycleNParser extends WrapParserMixin {
//   final int count;

//   CycleNParser(this.count, this.parser);

//   @override
//   final Parser parser;

//   @override
//   Context parse(Context context, MemoizationHandler handler) {
//     List<dynamic> mappedResults = <dynamic>[];
//     List<dynamic> unmappedResults = <dynamic>[];

//     Context ctx = context;
//     for (int i = 0; i < count; i++) {
//       ctx = parser.parseContext(ctx, handler);
//       if (ctx.isFailure) {
//         return ctx;
//       }

//       ctx.whenOrNull(success: (_, dynamic mapped, dynamic unmapped) {
//         mappedResults.add(mapped);
//         unmappedResults.add(unmapped);
//       });
//     }

//     return ctx.success(mappedResults, unmappedResults);
//   }
// }

// extension CycleNParserExtension on Parser {
//   CycleNParser cycleN(int c) => CycleNParser(c, this);
//   CycleNParser operator *(int c) => cycleN(c);
// }

class CycleNParser extends SynthesizedParser {
  final int count;
  @override
  Parser synthesized;
  Parser get parser => children[0];

  CycleNParser(Parser parser, this.count)
      : synthesized = SequenceParser(<Parser>[for (int _ in count.times) parser]),
        super(<Parser>[parser]);

  @override
  CycleNParser cloneSelf() => CycleNParser(parser, count);
}

CycleNParser cycleN(Parser parser, int count) => CycleNParser(parser, count);

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

// import "package:parser_peg/all.dart";

// class CycleStarParser extends WrapParserMixin {
//   @override
//   final Parser parser;

//   CycleStarParser(this.parser);

//   @override
//   Context parse(Context context, MemoizationHandler handler) {
//     List<dynamic> mappedResults = <dynamic>[];
//     List<dynamic> unmappedResults = <dynamic>[];
//     Context ctx = context;

//     for (;;) {
//       ctx = parser(ctx, handler);
//       if (ctx.isFailure) {
//         break;
//       }

//       ctx.whenOrNull(success: (_, dynamic mapped, dynamic unmapped) {
//         mappedResults.add(mapped);
//         unmappedResults.add(unmapped);
//       });
//     }

//     return ctx.success(mappedResults, unmappedResults);
//   }
// }

// extension CycleStarExtension on Parser {
//   Parser get cycleStar => CycleStarParser(this);
//   Parser get star => cycleStar;
// }

import "package:parser_peg/internal_all.dart";

class CycleStarParser extends SynthesizedParser {
  @override
  Parser synthesized;
  Parser get parser => children[0];

  CycleStarParser(Parser parser)
      : synthesized = parser.cycle() | success(<ParseResult>[]),
        super(<Parser>[parser]);

  @override
  CycleStarParser cloneSelf() => CycleStarParser(parser);
}

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

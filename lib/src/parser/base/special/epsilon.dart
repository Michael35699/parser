import "package:parser_peg/internal_all.dart";

class EpsilonParser extends SpecialParserMixin {
  @override
  Context parse(Context context, MemoizationHandler handler) => context.success("");
}

EpsilonParser epsilon() => EpsilonParser();

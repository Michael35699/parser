import "package:parser_peg/internal_all.dart";

class EpsilonParser extends SpecialParser {
  @override
  Context parse(Context context, MemoizationHandler handler) => context.success("");
}

EpsilonParser epsilon() => EpsilonParser();

import "package:parser_peg/internal_all.dart";

class EpsilonParser extends SpecialParser {
  @override
  Context parse(Context context, MemoizationHandler handler) => context.success("");

  @override
  String toString() => "ε";
}

EpsilonParser epsilon() => EpsilonParser();

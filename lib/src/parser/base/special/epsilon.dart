import "package:parser_peg/internal_all.dart";

class EpsilonParser extends SpecialParser {
  static final EpsilonParser singleton = EpsilonParser._();

  factory EpsilonParser() => singleton;
  EpsilonParser._();

  @override
  Context parse(Context context, ParserMutable mutable) => context.success("");

  @override
  String toString() => "ε";
}

EpsilonParser epsilon() => EpsilonParser();

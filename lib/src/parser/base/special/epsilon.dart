import "package:parser/internal_all.dart";

class EpsilonParser extends SpecialParser {
  static final EpsilonParser singleton = EpsilonParser._();

  factory EpsilonParser() => singleton;
  EpsilonParser._();

  @override
  Context parsePure(Context context) => context.success("");

  @override
  String toString() => "ε";
}

EpsilonParser epsilon() => EpsilonParser();

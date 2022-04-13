import "package:parser/internal_all.dart";

class EpsilonParser extends SpecialParser {
  static final EpsilonParser singleton = EpsilonParser._();

  factory EpsilonParser() => singleton;
  EpsilonParser._();

  @override
  Context parsePeg(Context context, ParserMutable mutable) => context.success("");

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) => continuation(context.success(""));

  @override
  String toString() => "ε";
}

EpsilonParser epsilon() => EpsilonParser();

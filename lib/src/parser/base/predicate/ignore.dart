import "package:parser/internal_all.dart";

class IgnoreParser extends SpecialParser {
  IgnoreParser();

  @override
  Context parsePeg(Context context, ParserMutable mutable) => context.ignore();

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) => continuation(context.ignore());
}

IgnoreParser ignore() => IgnoreParser();

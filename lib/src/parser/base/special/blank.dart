import "package:parser/internal_all.dart";

class BlankParser extends SpecialParser {
  static final BlankParser singleton = BlankParser._();

  factory BlankParser() => singleton;
  BlankParser._();

  @override
  Context parsePeg(Context context, PegHandler handler) => context.failure("Blank");

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      continuation(context.failure("Blank"));
}

BlankParser blank() => BlankParser();

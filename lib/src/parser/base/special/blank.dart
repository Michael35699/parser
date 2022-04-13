import "package:parser/internal_all.dart";

class BlankParser extends SpecialParser {
  static final BlankParser singleton = BlankParser._();

  factory BlankParser() => singleton;
  BlankParser._();

  @override
  Context parse(Context context, ParserMutable mutable) => context.failure("Blank");
}

BlankParser blank() => BlankParser();

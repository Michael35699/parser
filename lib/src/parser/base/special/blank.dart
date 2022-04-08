import "package:parser_peg/internal_all.dart";

class BlankParser extends SpecialParser {
  @override
  Context parse(Context context, MemoizationHandler handler) => context.failure("Blank");
}

BlankParser blank() => BlankParser();

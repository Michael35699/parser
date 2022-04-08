import "package:parser_peg/internal_all.dart";

class IgnoreParser extends SpecialParser {
  IgnoreParser();

  @override
  Context parse(Context context, MemoizationHandler handler) => context.ignore();
}

IgnoreParser ignore() => IgnoreParser();

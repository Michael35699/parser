import "package:parser_peg/internal_all.dart";

class IgnoreParser extends SpecialParserMixin {
  IgnoreParser();

  @override
  Context parse(Context context, MemoizationHandler handler) => context.ignore();
}

IgnoreParser ignore() => IgnoreParser();

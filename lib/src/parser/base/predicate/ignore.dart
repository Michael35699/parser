import "package:parser_peg/internal_all.dart";

class IgnoreParser extends SpecialParser {
  IgnoreParser();

  @override
  Context parse(Context context, ParserMutable mutable) => context.ignore();
}

IgnoreParser ignore() => IgnoreParser();

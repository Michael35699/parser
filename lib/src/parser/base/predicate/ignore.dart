import "package:parser_peg/internal_all.dart";

class IgnoreParser extends SpecialParser {
  IgnoreParser();

  @override
  Context parse(Context context, ParserEngine engine) => context.ignore();
}

IgnoreParser ignore() => IgnoreParser();

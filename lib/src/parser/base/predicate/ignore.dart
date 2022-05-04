import "package:parser/internal_all.dart";

class IgnoreParser extends SpecialParser {
  IgnoreParser();

  @override
  Context parsePure(Context context) => context.ignore();
}

IgnoreParser ignore() => IgnoreParser();

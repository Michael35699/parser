import "package:parser/internal_all.dart";

class EmptyParser extends SpecialParser {
  EmptyParser();

  @override
  Context parsePure(Context context) => context.empty();
}

EmptyParser empty() => EmptyParser();

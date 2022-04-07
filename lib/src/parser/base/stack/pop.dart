import "package:parser_peg/internal_all.dart";

class PopParser extends SpecialParserMixin {
  final dynamic object;

  PopParser(this.object);

  @override
  Context parse(Context context, MemoizationHandler handler) => context.pop(object).ignore();
}

PopParser pop(dynamic object) => PopParser(object);

import "package:parser_peg/internal_all.dart";

class PushParser extends SpecialParser {
  final dynamic object;

  PushParser(this.object);

  @override
  Context parse(Context context) => context.push(object).ignore();
}

PushParser push(dynamic object) => PushParser(object);

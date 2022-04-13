import "package:parser/internal_all.dart";

class PushParser extends SpecialParser {
  final dynamic object;

  PushParser(this.object);

  @override
  Context parse(Context context, ParserMutable mutable) => context.push(object).ignore();
}

PushParser push(dynamic object) => PushParser(object);

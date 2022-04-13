import "package:parser/internal_all.dart";

class PopParser extends SpecialParser {
  final dynamic item;

  PopParser(this.item);

  @override
  Context parse(Context context, ParserMutable mutable) => context.pop(item).ignore();
}

PopParser pop(dynamic item) => PopParser(item);

extension PopParserExtension on Parser {
  Parser pop(dynamic item) => this >> pop(item);
}

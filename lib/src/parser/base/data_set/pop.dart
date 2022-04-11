import "package:parser_peg/internal_all.dart";

class PopParser extends SpecialParser {
  final dynamic item;

  PopParser(this.item);

  @override
  Context parse(Context context, ParserEngine engine) => context.pop(item).ignore();
}

PopParser pop(dynamic item) => PopParser(item);

extension PopParserExtension on Parser {
  Parser pop(dynamic item) => this >> pop(item);
}

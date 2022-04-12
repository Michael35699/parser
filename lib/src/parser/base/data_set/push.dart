import "package:parser_peg/internal_all.dart";

class PushParser extends SpecialParser {
  final dynamic item;

  PushParser(this.item);

  @override
  Context parse(Context context, ParserMutable mutable) => context.push(item).ignore();
}

PushParser push(dynamic item) => PushParser(item);

extension PushParserExtension on Parser {
  Parser push(dynamic item) => this >> push(item);
}

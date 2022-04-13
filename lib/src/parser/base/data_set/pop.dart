import "package:parser/internal_all.dart";

class PopParser extends SpecialParser {
  final dynamic item;

  PopParser(this.item);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) => context.pop(item).ignore();

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      continuation(context.pop(item).ignore());
}

PopParser pop(dynamic item) => PopParser(item);

extension PopParserExtension on Parser {
  Parser pop(dynamic item) => this >> pop(item);
}

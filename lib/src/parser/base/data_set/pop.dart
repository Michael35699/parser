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

PopParser _pop(dynamic item) => _pop(item);
PopParser pop(dynamic item) => PopParser(item);

extension ParserPopExtension on Parser {
  Parser pop(dynamic item) => this >> _pop(item);
}

extension LazyParserPopParserExtension on Lazy<Parser> {
  Parser pop(dynamic item) => this.$ >> _pop(item);
}

extension StringPopParserExtension on String {
  Parser pop(dynamic item) => this.$ >> _pop(item);
}

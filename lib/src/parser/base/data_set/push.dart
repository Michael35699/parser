import "package:parser/internal_all.dart";

class PushParser extends SpecialParser {
  final dynamic item;

  PushParser(this.item);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) => context.push(item).ignore();

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      continuation(context.push(item).ignore());
}

PushParser _push(dynamic item) => _push(item);
PushParser push(dynamic item) => PushParser(item);

extension ParserPushExtension on Parser {
  Parser push(dynamic item) => this >> _push(item);
}

extension LazyParserPushParserExtension on Lazy<Parser> {
  Parser push(dynamic item) => this.$ >> _push(item);
}

extension StringPushParserExtension on String {
  Parser push(dynamic item) => this.$ >> _push(item);
}

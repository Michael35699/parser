import "package:parser/internal_all.dart";

class PopParser extends SpecialParser {
  PopParser();

  @override
  Context parsePure(Context context) => context.pop().empty();
}

PopParser _pop() => PopParser();
PopParser pop() => PopParser();

extension ParserPopExtension on Parser {
  Parser pop() => this << _pop();
}

extension LazyParserPopParserExtension on Lazy<Parser> {
  Parser pop() => this.$ << _pop();
}

extension StringPopParserExtension on String {
  Parser pop() => this.$ << _pop();
}

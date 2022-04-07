import "package:parser_peg/internal_all.dart";

mixin LazyParserMixin on Parser {
  abstract final LazyParser lazyParser;
  bool get memoizeBody;

  Parser? _computed;
  Parser get computed => _computed ??= lazyParser();

  @override
  Iterable<Parser> get children sync* {
    yield computed;
  }


  @override
  Parser get base => computed;
}

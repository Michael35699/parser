import "package:parser_peg/internal_all.dart";

abstract class LazyLoadParser extends Parser {
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

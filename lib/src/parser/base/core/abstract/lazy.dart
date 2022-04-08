import "package:parser_peg/internal_all.dart";

abstract class LazyLoadParser extends Parser {
  abstract final LazyParser lazyParser;
  bool get memoizeBody;

  Parser? computedInner;
  Parser get computed => computedInner ??= lazyParser();

  LazyLoadParser();
  LazyLoadParser.eager(this.computedInner);

  @override
  Iterable<Parser> get children sync* {
    yield computed;
  }

  @override
  Parser get base => computed;
}

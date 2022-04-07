import "package:parser_peg/internal_all.dart";

abstract class ChildlessParser extends Parser {
  @override
  bool get memoize => true;

  @override
  Iterable<Parser> get children sync* {}

  @override
  Parser cloneSelf() => this;

  @override
  Parser get base => this;
}

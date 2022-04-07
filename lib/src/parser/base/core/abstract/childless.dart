import "package:parser_peg/internal_all.dart";

abstract class ChildlessParser extends Parser {
  @override
  bool get memoize => true;

  @override
  Iterable<Parser> get children sync* {}

  @override
  Parser cloneSelf(Map<Parser, Parser> cloned) => this;

  @override
  Parser transformChildren(TransformHandler handler, Map<Parser, Parser> transformed) => this;

  @override
  Parser get base => this;
}

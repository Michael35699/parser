import "package:parser_peg/internal_all.dart";

abstract class WrapParser extends Parser {
  @override
  final List<Parser> children;

  WrapParser(this.children);


  @override
  Parser cloneSelf(Map<Parser, Parser> cloned) {
    WrapParser parser = cloned[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.clone());
    }

    return parser;
  }

  @override
  Parser transformChildren(TransformHandler handler, Map<Parser, Parser> transformed) {
    WrapParser parser = transformed[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.transform(handler, transformed));
    }

    return parser;
  }

  WrapParser empty();
}

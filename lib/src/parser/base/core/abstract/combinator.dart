import "package:parser_peg/internal_all.dart";

abstract class CombinatorParser extends Parser {
  @override
  final List<Parser> children;

  CombinatorParser(this.children);

  @override
  Parser get base => this;

  @override
  CombinatorParser cloneSelf(Map<Parser, Parser> cloned) {
    CombinatorParser parser = cloned[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.clone(cloned));
    }

    return parser;
  }

  @override
  CombinatorParser transformChildren(TransformHandler handler, Map<Parser, Parser> transformed) {
    CombinatorParser parser = transformed[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.transform(handler, transformed));
    }

    return parser;
  }

  CombinatorParser empty();
}

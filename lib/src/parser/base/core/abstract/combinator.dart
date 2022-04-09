import "dart:collection";

import "package:parser_peg/internal_all.dart";

abstract class CombinatorParser extends Parser {
  @override
  final List<Parser> children;

  CombinatorParser(this.children);

  @override
  Parser get base => this;

  @override
  CombinatorParser cloneSelf(HashMap<Parser, Parser> cloned) {
    CombinatorParser parser = cloned[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.clone(cloned));
    }

    return parser;
  }

  @override
  CombinatorParser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed) {
    transformed[this] = this;
    for (int i = 0; i < children.length; i++) {
      children[i] = children[i].transform(handler, transformed);
    }

    return this;
  }

  CombinatorParser empty();
}


import "package:parser/internal_all.dart";

abstract class CombinatorParser extends Parser {
  @override
  final List<Parser> children;

  CombinatorParser(this.children);

  @override
  Parser get base => this;

  @override
  Parser get unwrapped => this;

  @override
  CombinatorParser cloneSelf(ParserCacheMap cloned) {
    CombinatorParser parser = cloned[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.clone(cloned));
    }

    return parser;
  }

  @override
  CombinatorParser transformChildren(TransformHandler handler, ParserCacheMap transformed) {
    transformed[this] = this;
    for (int i = 0; i < children.length; i++) {
      children[i] = children[i].transform(handler, transformed);
    }

    return this;
  }

  CombinatorParser empty();
}

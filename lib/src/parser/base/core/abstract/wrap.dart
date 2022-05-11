import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

abstract class WrapParser extends Parser {
  @override
  final List<Parser> children;

  WrapParser(this.children);

  Parser get parser;

  @override
  @nonVirtual
  Parser get unwrapped => parser;

  @override
  @nonVirtual
  Parser get base => parser.base;

  @nonVirtual
  @override
  WrapParser cloneSelf(ParserCacheMap cloned) {
    WrapParser parser = cloned[this] = empty();
    for (int i = 0; i < children.length; i++) {
      parser.children.add(children[i].clone(cloned));
    }
    return parser;
  }

  @nonVirtual
  @override
  WrapParser transformChildren(TransformHandler handler, ParserCacheMap transformed) {
    transformed[this] = this;
    for (int i = 0; i < children.length; i++) {
      children[i] = children[i].transform(handler, transformed);
    }

    return this;
  }

  WrapParser empty();
}

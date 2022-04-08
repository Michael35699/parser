import "dart:collection";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class WrapParser extends Parser {
  @override
  final List<Parser> children;

  WrapParser(this.children);

  @nonVirtual
  @override
  WrapParser cloneSelf(HashMap<Parser, Parser> cloned) {
    WrapParser parser = cloned[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.clone(cloned));
    }

    return parser;
  }

  @nonVirtual
  @override
  WrapParser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed) {
    WrapParser parser = transformed[this] = empty();
    for (Parser p in children) {
      parser.children.add(p.transform(handler, transformed));
    }

    return parser;
  }

  WrapParser empty();
}

import "dart:collection";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class ChildlessParser extends Parser {
  @override
  bool get memoize => true;

  @nonVirtual
  @override
  List<Parser> get children => const <Parser>[];

  @nonVirtual
  @override
  Parser cloneSelf(HashMap<Parser, Parser> cloned) => this;

  @nonVirtual
  @override
  Parser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed) => this;

  @nonVirtual
  @override
  Parser get base => this;

  @nonVirtual
  @override
  Parser get unwrapped => this;
}

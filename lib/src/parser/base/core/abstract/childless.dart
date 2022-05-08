
import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

abstract class ChildlessParser extends Parser {
  @override
  bool get memoize => true;

  @nonVirtual
  @override
  List<Parser> get children => const <Parser>[];

  @nonVirtual
  @override
  Parser cloneSelf(ParserCacheMap cloned) => this;

  @nonVirtual
  @override
  Parser transformChildren(TransformHandler handler, ParserCacheMap transformed) => this;

  @nonVirtual
  @override
  Parser get base => this;

  @nonVirtual
  @override
  Parser get unwrapped => this;
}

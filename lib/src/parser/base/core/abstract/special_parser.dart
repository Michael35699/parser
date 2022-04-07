import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class SpecialParserMixin extends Parser {
  @override
  bool get memoize => true;

  @override
  Iterable<Parser> get children sync* {}

  @nonVirtual
  @override
  Parser cloneSelf() => this;

  @override
  Parser get base => this;
}

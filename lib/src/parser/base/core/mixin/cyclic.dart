import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

mixin CyclicParser on Parser {
  Parser get parser;

  @nonVirtual
  @override
  Parser get base => this;
}

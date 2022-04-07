import "package:parser_peg/internal_all.dart";

abstract class CombinatorParserMixin extends Parser {
  @override
  final List<Parser> children;

  CombinatorParserMixin(this.children);

  @override
  void replace<T extends Parser>(ParserPredicate target, TransformHandler<T> result) {
    super.replace(target, result);

    for (int i = 0; i < children.length; i++) {
      children[i] = children[i].applyTransformation(target, result);
    }
  }

  @override
  Parser get base => this;
}

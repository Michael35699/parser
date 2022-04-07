import "package:parser_peg/internal_all.dart";

abstract class WrapParser extends Parser {
  @override
  final List<Parser> children;

  WrapParser(this.children);

  @override
  set memoize(bool value) {
    for (Parser element in children) {
      element.memoize = true;
    }
  }

  @override
  void replace<T extends Parser>(ParserPredicate target, TransformHandler<T> result) {
    super.replace(target, result);

    for (int i = 0; i < children.length; i++) {
      children[i] = children[i].applyTransformation(target, result);
    }
  }
}

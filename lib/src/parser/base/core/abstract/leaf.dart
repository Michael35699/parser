import "package:parser_peg/internal_all.dart";

abstract class LeafParserMixin extends Parser {
  @override
  bool get memoize => true;

  @override
  Context parse(Context context, MemoizationHandler handler) {
    String input = context.state.input;
    int index = context.state.index;

    int? newIndex = parseLeaf(input, index);

    if (newIndex == null) {
      return context.failure(failureMessage);
    } else {
      String result = input.substring(index, newIndex);

      return context.absolute(newIndex).success(result);
    }
  }

  @override
  Iterable<Parser> get children sync* {}

  String get failureMessage;
  int? parseLeaf(String input, int index);

  @override
  Parser get base => this;

  @override
  Parser cloneSelf(Map<Parser, Parser> cloned) => this;

  @override
  Parser transformChildren(TransformHandler handler, Map<Parser, Parser> transformed) => this;
}

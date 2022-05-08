import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

abstract class LeafParser extends SpecialParser {
  @nonVirtual
  @override
  bool get memoize => true;

  @nonVirtual
  @override
  bool get leftRecursive => false;

  @nonVirtual
  @override
  Context parsePure(Context context) {
    String input = context.state.buffer;
    int index = context.state.index;

    int? newIndex = parseLeaf(input, index);

    if (newIndex == null) {
      return context.failure(failureMessage);
    } else {
      String result = input.substring(index, newIndex);

      return context.index(newIndex).success(result);
    }
  }

  String get failureMessage;
  int? parseLeaf(String input, int index);

  @override
  bool hasEqualProperties(LeafParser target) {
    return super.hasEqualProperties(target) && this == target;
  }
}

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

abstract class LeafParser extends ChildlessParser {
  @nonVirtual
  @override
  bool get memoize => true;

  @nonVirtual
  @override
  bool get leftRecursive => false;

  @nonVirtual
  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    String input = context.state.input;
    int index = context.state.index;

    int? newIndex = parseLeaf(input, index);

    if (newIndex == null) {
      return context.failure(failureMessage);
    } else {
      String result = input.substring(index, newIndex);

      return context.index(newIndex).success(result);
    }
  }

  @nonVirtual
  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    String input = context.state.input;
    int index = context.state.index;

    int? newIndex = parseLeaf(input, index);

    if (newIndex == null) {
      continuation(context.failure(failureMessage));
    } else {
      String result = input.substring(index, newIndex);

      continuation(context.index(newIndex).success(result));
    }
  }

  String get failureMessage;
  int? parseLeaf(String input, int index);

  @override
  bool hasEqualProperties(LeafParser target) {
    return super.hasEqualProperties(target) && this == target;
  }
}

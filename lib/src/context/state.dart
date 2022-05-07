import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/src/context/parse_mode.dart";

part "state.freezed.dart";

@freezed
class State with _$State {
  factory State({
    required String input,
    required ParseMode parseMode,
    @Default(0) int index,
    @Default(double.infinity) num precedence,
    @Default(<int>[]) List<int> indentStack,
    @Default(<dynamic>[]) List<dynamic> dataStack,
    PegMode? pegMode,
    PackratMode? packratMode,
  }) = StateDefault;
  State._();

  String get padded => input.split("\n").map((String c) => "$c ").join("\n");
  State get normalize => copyWith(precedence: -1);

  /// Given the index and the string, return the line number.
  int get line => padded.substring(0, index + 1).split("\n").length;

  /// Given the index and the string, return the column number.
  int get column => padded.substring(0, index + 1).split("\n")[line - 1].length;
}

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

part "context.freezed.dart";

/// Immutable class that contains a state object and additional properties.
@freezed
class Context with MemoizationEntryValue, _$Context {
  const Context._();
  const factory Context.ignore(State state) = ContextIgnore;
  const factory Context.failure(
    State state,
    String message, {
    @Default(false) bool artificial,
  }) = ContextFailure;
  const factory Context.success(
    State state,
    ParseResult mappedResult,
    ParseResult unmappedResult,
  ) = ContextSuccess;

  @override
  String toString() => when(
        success: (_, ParseResult result, ParseResult unmapped) =>
            (result == unmapped) || (const DeepCollectionEquality().equals(result, unmapped))
                ? "[Success]: $result"
                : "[Success]: $unmapped --> $result",
        failure: (_, String message, __) => "[Failure]: $message",
        ignore: (_) => "[Ignore]",
      );

  /// Returns a ContextIgnore.
  ContextIgnore ignore() => Context.ignore(state) as ContextIgnore;

  /// Returns a ContextFailure with the basic message.
  ContextFailure failure(String message) => Context.failure(state, message) as ContextFailure;

  /// Returns a ContextSuccess with the given results.
  ContextSuccess success(ParseResult result, [ParseResult unmappedResult = #NO]) =>
      Context.success(state, result, unmappedResult == #NO ? result : unmappedResult) as ContextSuccess;

  /// Returns a context whose index is advanced by `n`
  Context advance(int n) => copyWith.state(index: state.index + n);

  // Returns a context whose index is set to `n`
  Context index(int n) => copyWith.state(index: n);

  // Returns a context whose `indentStack` is replaced.
  Context indent(List<int> indentStack) => copyWith.state(indentStack: indentStack);

  bool get isSpecificSuccess => whenOrNull(success: (_, __, ___) => true) ?? false;
  bool get isSuccess => whenOrNull(failure: (_, __, ___) => false) ?? true;
  bool get isFailure => !isSuccess;

  // ignore: avoid_returning_this
  Context addResult(List<ParseResult> mapped, List<ParseResult> unmapped) {
    whenOrNull(success: (_, ParseResult m, ParseResult um) {
      mapped.add(m);
      unmapped.add(um);
    });
    return this;
  }

  Context push(dynamic value) => copyWith.state(dataSet: <dynamic>{...state.dataSet, value});
  Context pop(dynamic value) => copyWith.state(dataSet: state.dataSet.where((dynamic v) => v != value).toSet());

  static String highlightIndent(String input) {
    int i = 0;
    for (; i < input.length && input[i].trim().isEmpty; i++) {}

    return "${"·" * i}${input.substring(i)}";
  }

  /// Takes a line and shortens it as necessary. Returns a list of three strings, would really appreciate
  /// using the Record type proposal here.
  static List<String> shortenLine(int threshold, String line, int pointer) {
    String cleanedLine = highlightIndent(line);

    if (pointer < 0) {
      return <String>["", "·", line];
    }
    if (pointer > line.length) {
      return <String>[line, ".", ""];
    }

    String before = cleanedLine.substring(0, pointer);
    String at = cleanedLine[pointer];
    String after = cleanedLine.substring(pointer + 1);

    String shortenedBefore = before.length >= threshold //
        ? "...${before.substring(before.length - threshold)}"
        : before;
    String now = at.trim().isEmpty ? "·" : at;
    String shortenedAfter = after.length >= threshold //
        ? "${after.substring(0, threshold)}..."
        : after;

    return <String>[shortenedBefore, now, shortenedAfter];
  }

  /// Generates a readable error message from a context state object.
  String generateFailureMessage() {
    const int threshold = 12;
    const String lineIndent = "  ";

    Context self = this;
    State data = state;

    if (self is! ContextFailure) {
      throw UnsupportedError("Generating a failure message is only supported for the ContextFailure type.");
    }

    int line = data.line;
    int column = data.column;
    String input = data.padded;

    List<String> lineParts = shortenLine(threshold, input.split("\n")[line - 1], column - 1);
    String specificLine = "$lineIndent${lineParts.join()}";
    String cursorBuffer = " " * lineParts[0].length;

    String displayLineNumber = "$line";
    String barBuffer = " " * displayLineNumber.length;
    String noNumberBar = "$barBuffer |";
    String numberedBar = "$displayLineNumber |";

    String full = """
Failure: ${self.message}
$barBuffer--> $line:$column
$noNumberBar
$numberedBar$specificLine
$noNumberBar$cursorBuffer  ^
$noNumberBar
    """;

    return full;
  }
}

extension ContextFailureMethods on ContextFailure {
  ContextFailure withFailureMessage() => copyWith(message: generateFailureMessage());

  ContextFailure generated() => copyWith(artificial: true);
}

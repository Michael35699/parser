import "package:parser/internal_all.dart";

class IndentParser extends SpecialParser {
  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    String input = context.state.input;
    int index = context.state.index;

    if (index >= input.length || input[index] != "\n") {
      return context.failure(expected.the("beginning of a line"));
    }

    int newLines = 0;
    index++;
    while (index < input.length && input[index] == "\n") {
      index++;
      newLines++;
    }

    int column = 0;
    while (<String>{" ", "\t"}.contains(input[index])) {
      column++;
      index++;
    }

    List<int> stack = context.state.indentStack;
    late List<ParseResult> result = <ParseResult>[
      <ParseResult>[for (int i = 0; i < newLines; i++) #newline],
      #indent
    ];
    late List<int> newStack = <int>[...stack, column];
    late Context toReturn = Context.success(context.state.copyWith(indentStack: newStack, index: index), result, this);

    /// If the indentation stack is empty
    /// and there is a detected indent, then return 'success.'
    ///
    /// If the indentation stack is not empty,
    /// but the current indentation is greater than the previous one,
    /// also return success.
    if (stack.isEmpty && column > 0 || column > stack.last) {
      return toReturn;
    }

    return context.failure(expected.an("indentation"));
  }

  @override
  void parseGll(Context context, Trampoline trampoline, Continuation continuation) {
    String input = context.state.input;
    int index = context.state.index;

    if (index >= input.length || input[index] != "\n") {
      return continuation(context.failure(expected.the("beginning of a line")));
    }

    int newLines = 0;
    index++;
    while (index < input.length && input[index] == "\n") {
      index++;
      newLines++;
    }

    int column = 0;
    while (<String>{" ", "\t"}.contains(input[index])) {
      column++;
      index++;
    }

    List<int> stack = context.state.indentStack;
    late List<dynamic> result = <dynamic>[
      <dynamic>[for (int i = 0; i < newLines; i++) "#newline"],
      "#indent"
    ];
    late List<int> newStack = <int>[...stack, column];
    late Context toReturn = Context.success(context.state.copyWith(indentStack: newStack, index: index), result, this);

    /// If the indentation stack is empty
    /// and there is a detected indent, then return 'success.'
    ///
    /// If the indentation stack is not empty,
    /// but the current indentation is greater than the previous one,
    /// also return success.
    if (stack.isEmpty && column > 0 || column > stack.last) {
      return continuation(toReturn);
    }

    return continuation(context.failure(expected.an("indentation")));
  }
}

final Parser indent = IndentParser();

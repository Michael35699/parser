import "package:parser/internal_all.dart";

class IndentParser extends SpecialParser {
  @override
  Context parsePure(Context context) {
    String buffer = context.state.buffer;
    int index = context.state.index;

    if (index >= buffer.length || buffer[index] != "\n") {
      return context.failure(expected.the("beginning of a line"));
    }

    int newLines = 0;
    index++;
    while (index < buffer.length && buffer[index] == "\n") {
      index++;
      newLines++;
    }

    int column = 0;
    while (<String>{" ", "\t"}.contains(buffer[index])) {
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
}

final Parser indent = IndentParser();

import "package:parser/internal_all.dart";

class DedentParser extends SpecialParser {
  @override
  Context parsePure(Context context) {
    /// I literally don't understand this.

    String buffer = context.state.buffer;
    int index = context.state.index;

    if (index >= buffer.length) {
      return context.success(#dedent);
    }

    if (buffer[index] != "\n") {
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
      #dedent
    ];

    if (stack.isEmpty) {
      return context.failure("Unexpected dedentation call on empty stack");
    }

    int indentation = stack.last;

    if (column == 0) {
      return context.indent(stack.sublist(0, stack.length - 1)).success(result);
    }

    if (column < indentation) {
      List<int> newStack = stack.sublist(0, stack.length - 1);

      if (newStack.isEmpty && column > 0) {
        String message = "Unexpected illegal dedentation (Received $column, expected =0)";

        return context.failure(message);
      }

      if ((newStack.isEmpty && column == 0) || (newStack.last == column)) {
        return context.indent(newStack).success(result);
      }
    }

    String message = expected.a("dedentation. (Received $column, expected <${stack.isEmpty ? 0 : stack.last})");
    return context.failure(message);
  }
}

final Parser dedent = DedentParser();

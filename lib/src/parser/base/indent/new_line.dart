import "package:parser/internal_all.dart";

class NewLineParser extends SpecialParser {
  @override
  Context parse(Context context, ParserMutable mutable) {
    String input = context.state.input;
    int index = context.state.index;

    if (index >= input.length || input[index] != "\n") {
      return context.failure(expected.a("newline"));
    }

    int newlineCount = ++index - index + 1;
    for (; index < input.length && input[index] == "\n"; index++, newlineCount++) {}

    int column = 0;
    while (index < input.length && <String>{" ", "\t"}.contains(input[index])) {
      column++;
      index++;
    }

    List<Symbol> newlines = <Symbol>[for (int i = 0; i < newlineCount; i++) #newline];
    List<int> stack = context.state.indentStack;
    if (stack.isEmpty) {
      if (column > 0) {
        return context.failure("Unexpected indentation");
      }

      return context.index(index).success(newlines);
    } else {
      int indentation = stack.last;

      if (column < indentation) {
        return context.failure("Unexpected dedentation");
      } else if (column > indentation) {
        return context.failure("Unexpected indentation");
      }
      return context.index(index).success(newlines);
    }
  }
}

final Parser newline = NewLineParser();

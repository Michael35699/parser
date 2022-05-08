import "package:parser/internal_all.dart";

class NewLineParser extends SpecialParser {
  @override
  Context parsePure(Context context) {
    String buffer = context.state.buffer;
    int index = context.state.index;

    if (index >= buffer.length || buffer[index] != "\n") {
      return context.failure(expected.a("newline"));
    }

    int newlineCount = ++index - index + 1;
    for (; index < buffer.length && buffer[index] == "\n"; index++, newlineCount++) {}

    int column = 0;
    while (index < buffer.length && <String>{" ", "\t"}.contains(buffer[index])) {
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

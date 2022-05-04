import "package:parser/internal_all.dart";

class AlignPointParser extends SpecialParser {
  @override
  Context parsePeg(Context context, PegHandler handler) {
    String input = context.state.input;
    int index = context.state.index;

    if (index >= input.length) {
      return context.failure(expected.the("beginning of a line"));
    }

    int column = 0;
    while (index - column > 0 && input[index - column] != "\n") {
      column++;
    }

    List<int> stack = context.state.indentStack;
    if (stack.isEmpty) {
      List<int> stack = <int>[column];

      return context.indent(stack).success(#align);
    } else {
      int indentation = stack.last;

      if (column > indentation) {
        return context.indent(<int>[...stack, column]).success(#align);
      } else {
        return context.failure(expected.a("$column>$indentation indentation"));
      }
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    String input = context.state.input;
    int index = context.state.index;

    if (index >= input.length) {
      return continuation(context.failure(expected.the("beginning of a line")));
    }

    int column = 0;
    while (index - column > 0 && input[index - column] != "\n") {
      column++;
    }

    List<int> stack = context.state.indentStack;
    if (stack.isEmpty) {
      List<int> stack = <int>[column];

      return continuation(Context.success(context.state.copyWith(indentStack: stack), "#align", this));
    } else {
      int indentation = stack.last;

      if (column > indentation) {
        return continuation(
            Context.success(context.state.copyWith(indentStack: <int>[...stack, column]), "#align", this));
      } else {
        return continuation(context.failure(expected.a("$column>$indentation indentation")));
      }
    }
  }
}

AlignPointParser align() => AlignPointParser();

extension ParserAlignPointExtension on Parser {
  Parser alignLeft() => align() & this;
  Parser alignRight() => this & align();
}

extension LazyParserAlignPointExtension on LazyParser {
  Parser alignLeft() => this.$.alignLeft();
  Parser alignRight() => this.$.alignRight();
}

extension StringAlignPointExtension on String {
  Parser alignLeft() => this.$.alignLeft();
  Parser alignRight() => this.$.alignRight();
}

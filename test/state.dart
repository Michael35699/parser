import "package:parser/context.dart";
import "package:parser/src/util/shared/unindent.dart";
import "package:test/test.dart";

void main() {
  String input = """
    foo bar baz
    foo bar baz
    foo bar baz
  """
      .unindent();
  State base = State(input: input, index: 4, parseMode: ParseMode.packrat);

  group("methods", () {
    test("padding", () {
      String padded = base.padded;
      expect(padded, """
foo bar baz 
foo bar baz 
foo bar baz """);
      expect(base.input, input);
    });
    test("column & line", () {
      State inner = base.copyWith();
      expect(inner.line, 1);
      expect(inner.column, 5);
      inner = inner.copyWith(index: 15);
      expect(inner.line, 2);
      expect(inner.column, 3);
    });
  });
}

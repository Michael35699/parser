import "package:parser/parser.dart" as parser;
import "package:parser/util.dart";

int counter = 0;

typedef Parser = parser.Parser;

Parser code() => "{" & code.star().trim() & "}" | ~"}" >> parser.source();

void main() {
  const String input =
      "{ constantly running dart code here: {block} {these can be used in actual code blocks. Amazing right?} }";

  print(time(count: 50, () => code.peg.pure(input)));
  print(time(count: 50, () => code.peg.left(input)));
  print(time(count: 50, () => code.packrat.basic(input)));
  print(time(count: 50, () => code.packrat.linear(input)));
  print(time(count: 50, () => code.packrat.quadratic(input)));
}

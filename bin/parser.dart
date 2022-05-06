// import "package:parser/src/util/shared/time.dart";
import "package:parser/example/parser/math.dart" as math_parser;
import "package:parser/parser.dart" as parser;
import "package:parser/src/util/shared/time.dart";

int counter = 0;

typedef Parser = parser.Parser;

Parser peg() => "s".plus();
Parser explicitLeft() => explicitLeft & "s" | "s";
Parser implicitLeft() => implicitLeft & implicitLeft | "s"
  ..left();
Parser explicitRight() => "s" & explicitRight | "s";
Parser implicitRight() => implicitRight & implicitRight | "s"
  ..right();

void main() {
  const int count = 50;
  const String input =
      "71 + 40 + 38 ^ 93 / 99 + 85 / 30 - 49 - 78 - 81 + 85 ~/ 45 + 65 - 83 - 14 / 16 + 96 + 97 - 92 ~/ 88 * 17 - 40 ^ 27 * 68 + 98 * 33 * 48 * 59 + 67 / 38 * 29 ^ 57 - 30 * 97 ^ 42 * 14 ~/ 52 + 53 ~/ 76 + 42 * 27 ^ 57 ~/ 17 * 53 * 22 ~/ 20 - 85 ^ 74 + 28 ~/ 20 / 78";

  Parser parser = math_parser.infix();
  print(time(count: count, () => parser.run(input)));
}

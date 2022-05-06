// import "package:parser/src/util/shared/time.dart";
// import "package:parser/example/parser/math.dart" as math_parser;
import "package:parser/example/parser/calculator/calculator.dart";
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
  const String input = "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss"
      "sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss";

  for (MapEntry<String, Parser> entry in <String, Parser>{
    "peg": parser.thunk(peg),
    "explicitLeft": parser.thunk(explicitLeft),
    "implicitLeft": parser.thunk(implicitLeft),
    "explicitRight": parser.thunk(explicitRight),
    "implicitRight": parser.thunk(implicitRight),
  }.entries) {
    print("----- ${entry.key} -----");
    time(count: count, name: "Pure-left", () => entry.value.peg.left(input));
    time(count: count, name: "Packrat-Linear", () => entry.value.packrat.linear(input));
    time(count: count, name: "Packrat-Quadratic", () => entry.value.packrat.quadratic(input));
    print("");
  }
  parser.Parser calculator = expression();
  print(calculator.run("sin(2π)(2 add 8)"));
}

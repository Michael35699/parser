import "dart:math";

import "package:parser/example/parser/math/infix.dart";
import "package:parser/internal_all.dart";

part "utils.dart";

String generateInput() {
  const int max = 100;
  const List<String> operators = <String>["+", "-", "*", "/", "~/", "%", "^"];

  Random random = Random.secure();
  int randomNumber() => random.nextInt(max - 10) + 10;
  String randomOperator() => operators[random.nextInt(operators.length)];

  StringBuffer buffer = StringBuffer(randomNumber());
  for (int _ in 50.times) {
    buffer
      ..write(" ")
      ..write(randomOperator())
      ..write(" ")
      ..write(randomNumber());
  }

  return buffer.toString();
}

void main() {
  Parser parser = infixMath.build();
  String input = generateInput();
  ParserSetMapping firstSets = parser.firstSets;
  parser.transformWhere(
    (Parser p) => p is SequenceParser && p.children.length == 3 && p.children[1].base is StringParser,
    (SequenceParser p) => p.children[0] & p.children[1].drop() & p.children[2],
  );

  print(firstSets[parser]);
  time(() => parser.unmapped.peg.linear(input));
  time(() => parser.unmapped.peg.quadratic(input));
}

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

  time.average(50, () => parser.unmapped.peg.quadratic(input));
  time.average(50, () => parser.unmapped.peg.linear(input));
}

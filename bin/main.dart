import "dart:math";

import "package:parser/example/parser/math/infix.dart";
import "package:parser/internal_all.dart";

part "utils.dart";

String generateInput() {
  Random random = Random.secure();
  const int max = 100;
  const List<String> operators = <String>["+", "-", "*", "^", "~/", "/"];

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
  String input = generateInput();
  print(input);

  print(infixMath.gll(input));
}

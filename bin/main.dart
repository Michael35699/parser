import "dart:math";

import "package:parser/example/parser/math/infix.dart";
import "package:parser/internal_all.dart";

part "utils.dart";

String generateInput() {
  const int max = 100;
  const List<String> operators = <String>["+", "-", "*", "^", "~/", "/"];

  Random random = Random.secure();
  int randomNumber() => random.nextInt(max - 10) + 10;
  String randomOperator() => operators[random.nextInt(operators.length)];

  StringBuffer buffer = StringBuffer(randomNumber());
  for (int _ in 20.times) {
    buffer
      ..write(" ")
      ..write(randomOperator())
      ..write(" ")
      ..write(randomNumber());
  }

  return buffer.toString();
}

void main() {
  print(infixMath.gll(generateInput()));
}

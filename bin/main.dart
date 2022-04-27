import "dart:math";

import "package:parser/example/parser/math/infix.dart";
import "package:parser/internal_all.dart";

part "utils.dart";

String generateInput() {
  const List<String> operators = <String>["+", "-", "*", "^", "~/", "/"];
  const int min = 10;
  const int max = 100;
  Random random = Random();

  String randomOperator() => operators[random.nextInt(operators.length)];
  int randomNumber() => random.nextInt(max - min) + min;

  StringBuffer buffer = StringBuffer(randomNumber());
  for (int _ in 50.times) {
    buffer << " " << randomOperator() << " " << randomNumber();
  }

  return buffer.toString();
}

extension<T> on T {
  R also<R>(R Function(T) callback) => callback(this);
}

extension on StringBuffer {
  StringBuffer operator <<(Object? item) => this..write(item);
}

void main() {
  String input = generateInput();
  print(input);

  print(infixMath.peg<num>(input).also((_) => _.toInt() & 1 << 12 | 1));
}

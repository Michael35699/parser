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
    buffer
      ..write(" ")
      ..write(randomOperator())
      ..write(" ")
      ..write(randomNumber());
  }

  return buffer.toString();
}

extension TT<T> on T {
  R also<R>(R Function(T) callback) => callback(this);
}

void main() {
  Parser parser = infixMath.unmapped.end.build();

  print(parser.gll<Object?>("0 * 1 +", except: log.error));
}

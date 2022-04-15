import "dart:math";

import "package:parser/parser.dart";
import "package:parser/util.dart";

part "utils.dart";

Parser math() =>
    1.$ ^ math[0] & -"^".t & math[1] ^ $2(pow) | //
    0.$ ^ number;

void main() {
  const String input = "1^2^3";
  Parser parser = math.undropped.unmapped.build();
  print(parser.gll(input).toList());
  print(parser.peg(input));
}

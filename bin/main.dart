import "dart:math";

import "package:parser/parser.dart";
import "package:parser/util.dart";

part "utils.dart";

Parser math() => addition.$;
Parser addition() =>
    addition & "+".t & multiplication ^ $3((num l, _, num r) => l + r) | //
    addition & "-".t & multiplication ^ $3((num l, _, num r) => l - r) |
    multiplication;
Parser multiplication() =>
    multiplication & "*".t & negative ^ $3((num l, _, num r) => l * r) | //
    multiplication & "/".t & negative ^ $3((num l, _, num r) => l / r) |
    negative;
Parser negative() =>
    "-".t & negative ^ $2((_, num v) => -v) | //
    power;
Parser power() =>
    atom & "^".t & power ^ $3((num l, _, num r) => pow(l, r)) | //
    atom;
Parser atom() =>
    digit.plus() ^ $join() >>> int.parse | //
    "(".t & addition & ")".t ^ $at(1);

void main() {
  const String input = "1 + 2 * 3";
  Parser mapped = math.build();
  Parser unmapped = math.unmapped.build();

  print(mapped.gll(input).toList());
  print(mapped.peg(input));
  print(unmapped.gll(input).toList());
  print(unmapped.peg(input));
}

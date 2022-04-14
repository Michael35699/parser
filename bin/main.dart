import "dart:math";

import "package:parser/internal_all.dart";

part "utils.dart";

Parser math() => addition.$;
Parser addition() =>
    addition & "+".t() & multiplication ^ $3((num l, _, num r) => l + r) | //
    addition & "-".t() & multiplication ^ $3((num l, _, num r) => l - r) |
    multiplication;
Parser multiplication() =>
    multiplication & "*".t() & negative ^ $3((num l, _, num r) => l * r) | //
    multiplication & "/".t() & negative ^ $3((num l, _, num r) => l / r) |
    negative;
Parser negative() =>
    "-".t() & negative ^ $2((_, num v) => -v) | //
    power;
Parser power() =>
    atom & "^".t() & power ^ $3((num l, _, num r) => pow(l, r)) | //
    atom;
Parser atom() =>
    ("0" >> "9").plus() ^ $join() >>> int.parse | //
    "(".t() >> addition << ")".t();

void main() {
  const String input = "1 + 2 * 3";
  Parser mapped = math.thunk();
  Parser unmapped = math.unmapped.thunk();

  time(() {
    print << mapped.run(input);
  });
  time(() {
    print << unmapped.run(input);
  });
}

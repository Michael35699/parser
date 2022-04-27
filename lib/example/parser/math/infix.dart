import "dart:math";

import "package:parser/parser.dart";

Parser infixMath() => _addition.thunk();

Parser _addition() =>
    _addition & "+".t & _multiplication ^ $3((num l, _, num r) => l + r) |
    _addition & "-".t & _multiplication ^ $3((num l, _, num r) => l - r) |
    _multiplication;

Parser _multiplication() =>
    _multiplication & "*".t & _power ^ $3((num l, _, num r) => l * r) |
    _multiplication & "/".t & _power ^ $3((num l, _, num r) => r == 0 ? l : l / r) |
    _multiplication & "~/".t & _power ^ $3((num l, _, num r) => r == 0 ? l : l ~/ r) |
    _multiplication & "%".t & _power ^ $3((num l, _, num r) => r == 0 ? l : l % r) |
    _power;

Parser _power() =>
    _negative & "^".t & _power ^ $3((num l, _, num r) => pow(l, r)) |
    _negative & "**".t & _power ^ $3((num l, _, num r) => pow(l, r)) |
    _negative;

Parser _negative() => "-".tr & _negative ^ $2((_, num v) => -v) | _atomic;
Parser _atomic() => _number.flat() ^ $type(int.parse) | "(".t & _addition & ")".t;
Parser _number() => _number & _digit | _digit;
Parser _digit() => "0" >> "9";

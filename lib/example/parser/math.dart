import "dart:math" as math;

import "package:parser/parser.dart" as parser;

parser.Parser infix() => _addition.thunk();

parser.Parser _addition() =>
    _addition & "+".t & _multiplication ^ parser.$3((num l, _, num r) => l + r) |
    _addition & "-".t & _multiplication ^ parser.$3((num l, _, num r) => l - r) |
    _multiplication;

parser.Parser _multiplication() =>
    _multiplication & "*".t & _power ^ parser.$3((num l, _, num r) => l * r) |
    _multiplication & "/".t & _power ^ parser.$3((num l, _, num r) => r == 0 ? l : l / r) |
    _multiplication & "~/".t & _power ^ parser.$3((num l, _, num r) => r == 0 ? l : l ~/ r) |
    _multiplication & "%".t & _power ^ parser.$3((num l, _, num r) => r == 0 ? l : l % r) |
    _power;

parser.Parser _power() =>
    _negative & "^".t & _power ^ parser.$3((num l, _, num r) => math.pow(l, r)) |
    _negative & "**".t & _power ^ parser.$3((num l, _, num r) => math.pow(l, r)) |
    _negative;

parser.Parser _negative() => "-".tr & _negative ^ parser.$2((_, num v) => -v) | _atomic;
parser.Parser _atomic() => _number.flat() ^ parser.$type(int.parse) | "(".t & _addition & ")".t;
parser.Parser _number() => _number & _digit | _digit;
parser.Parser _digit() => "0" >> "9";

parser.Parser prefix() =>
    "+".t & prefix.t & prefix.t ^ parser.$3((_, num l, num r) => l + r) |
    "-".t & prefix.t & prefix.t ^ parser.$3((_, num l, num r) => l - r) |
    "*".t & prefix.t & prefix.t ^ parser.$3((_, num l, num r) => l * r) |
    "/".t & prefix.t & prefix.t ^ parser.$3((_, num l, num r) => l / r) |
    "~/".t & prefix.t & prefix.t ^ parser.$3((_, num l, num r) => l ~/ r) |
    "%".t & prefix.t & prefix.t ^ parser.$3((_, num l, num r) => l % r) |
    "^".t & prefix.t & prefix.t ^ parser.$3((_, num l, num r) => math.pow(l, r)) |
    "(".t & prefix.t & ")" ^ parser.$3((_, num v, __) => v) |
    "[0-9]+".r ^ parser.$type(int.parse);

parser.Parser postfix() =>
    postfix.t & postfix.t & "+" ^ parser.$3((num l, num r, _) => l + r) |
    postfix.t & postfix.t & "-" ^ parser.$3((num l, num r, _) => l - r) |
    postfix.t & postfix.t & "*" ^ parser.$3((num l, num r, _) => l * r) |
    postfix.t & postfix.t & "/" ^ parser.$3((num l, num r, _) => l / r) |
    postfix.t & postfix.t & "~/" ^ parser.$3((num l, num r, _) => l ~/ r) |
    postfix.t & postfix.t & "%" ^ parser.$3((num l, num r, _) => l % r) |
    postfix.t & postfix.t & "^" ^ parser.$3((num l, num r, _) => math.pow(l, r)) |
    "(" & postfix.t & ")" ^ parser.$3((_, num v, __) => v) |
    "[0-9]+".r ^ parser.$type(int.parse);

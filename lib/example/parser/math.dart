import "dart:math" as math;

import "package:parser/parser.dart" as parser;

parser.Parser infix() => _addition.thunk();

parser.Parser _addition() => parser.blank | //
    _addition & "+".t & _addition |
    _addition & "-".t & _addition |
    _multiplication
  ..left();

parser.Parser _multiplication() => parser.blank | //
    _multiplication & "*".t & _multiplication |
    _multiplication & "/".t & _multiplication |
    _multiplication & "~/".t & _multiplication |
    _multiplication & "%".t & _multiplication |
    _power
  ..left();

parser.Parser _power() => parser.blank | //
    _power & "^".t & _power |
    _power & "**".t & _power |
    _negative
  ..right();

parser.Parser _negative() => "-".tr & _negative | _atomic;
parser.Parser _atomic() => _number.flat() | "(".t >> _addition << ")".t;
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

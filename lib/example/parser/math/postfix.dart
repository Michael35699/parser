import "dart:math";

import "package:parser/parser.dart";

Parser postfixMath() => _expression.thunk();
Parser _expression() =>
    _expression.t & _expression.t & "+" ^ $3((num l, num r, _) => l + r) |
    _expression.t & _expression.t & "-" ^ $3((num l, num r, _) => l - r) |
    _expression.t & _expression.t & "*" ^ $3((num l, num r, _) => l * r) |
    _expression.t & _expression.t & "/" ^ $3((num l, num r, _) => l / r) |
    _expression.t & _expression.t & "~/" ^ $3((num l, num r, _) => l ~/ r) |
    _expression.t & _expression.t & "%" ^ $3((num l, num r, _) => l % r) |
    _expression.t & _expression.t & "^" ^ $3((num l, num r, _) => pow(l, r)) |
    "(" & _expression.t & ")" ^ $3((_, num v, __) => v) |
    "[0-9]+".r ^ $type(int.parse);

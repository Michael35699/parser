import "dart:math";

import "package:parser/parser.dart";

Parser prefixMath() => _expression.thunk();
Parser _expression() =>
    "+".t & _expression.t & _expression.t ^ $3((_, num l, num r) => l + r) |
    "-".t & _expression.t & _expression.t ^ $3((_, num l, num r) => l - r) |
    "*".t & _expression.t & _expression.t ^ $3((_, num l, num r) => l * r) |
    "/".t & _expression.t & _expression.t ^ $3((_, num l, num r) => l / r) |
    "~/".t & _expression.t & _expression.t ^ $3((_, num l, num r) => l ~/ r) |
    "%".t & _expression.t & _expression.t ^ $3((_, num l, num r) => l % r) |
    "^".t & _expression.t & _expression.t ^ $3((_, num l, num r) => pow(l, r)) |
    "(".t & _expression.t & ")" ^ $3((_, num v, __) => v) |
    "[0-9]+".r ^ $type(int.parse);

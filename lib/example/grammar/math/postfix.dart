import "dart:math";

import "package:parser/parser.dart";

class PostfixMathGrammar with Grammar {
  @override
  Parser start() => expr.$;
  Parser expr() =>
      expr.t & expr.t & "+" ^ $3((num l, num r, _) => l + r) |
      expr.t & expr.t & "-" ^ $3((num l, num r, _) => l - r) |
      expr.t & expr.t & "*" ^ $3((num l, num r, _) => l * r) |
      expr.t & expr.t & "/" ^ $3((num l, num r, _) => l / r) |
      expr.t & expr.t & "~/" ^ $3((num l, num r, _) => l ~/ r) |
      expr.t & expr.t & "%" ^ $3((num l, num r, _) => l % r) |
      expr.t & expr.t & "^" ^ $3((num l, num r, _) => pow(l, r)) |
      "(" & expr.t & ")" ^ $3((_, num v, __) => v) |
      "[0-9]+".r ^ $type(int.parse);
}

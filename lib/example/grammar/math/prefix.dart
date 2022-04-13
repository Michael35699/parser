import "dart:math";

import "package:parser_peg/parser_peg.dart";

class PrefixMathGrammar with Grammar {
  @override
  Parser start() => expr.$;
  Parser expr() =>
      "+".t & expr.t & expr.t ^ $3((_, num l, num r) => l + r) |
      "-".t & expr.t & expr.t ^ $3((_, num l, num r) => l - r) |
      "*".t & expr.t & expr.t ^ $3((_, num l, num r) => l * r) |
      "/".t & expr.t & expr.t ^ $3((_, num l, num r) => l / r) |
      "~/".t & expr.t & expr.t ^ $3((_, num l, num r) => l ~/ r) |
      "%".t & expr.t & expr.t ^ $3((_, num l, num r) => l % r) |
      "^".t & expr.t & expr.t ^ $3((_, num l, num r) => pow(l, r)) |
      "(".t & expr.t & ")" ^ $3((_, num v, __) => v) |
      "[0-9]+".r ^ $type(int.parse);
}

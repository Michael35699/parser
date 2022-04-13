import "dart:math";

import "package:parser/parser.dart";

class InfixMathGrammar with Grammar {
  @override
  Parser start() => expr.$;
  Parser expr() =>
      4.$ ^ expr[4] & "+".t & expr[3] ^ $3((num l, _, num r) => l + r) |
      4.$ ^ expr[4] & "-".t & expr[3] ^ $3((num l, _, num r) => l - r) |
      3.$ ^ expr[3] & "*".t & expr[2] ^ $3((num l, _, num r) => l * r) |
      3.$ ^ expr[3] & "/".t & expr[2] ^ $3((num l, _, num r) => l / r) |
      3.$ ^ expr[3] & "~/".t & expr[2] ^ $3((num l, _, num r) => l ~/ r) |
      3.$ ^ expr[3] & "%".t & expr[2] ^ $3((num l, _, num r) => l % r) |
      2.$ ^ expr[3] & "^".t & expr[2] ^ $3((num l, _, num r) => pow(l, r)) |
      1.$ ^ "-".tr & expr[1] ^ $2((_, num v) => -v) |
      0.$ ^ "(".t & expr[4] & ")".t ^ $3((_, num v, __) => v) |
      0.$ ^ "[0-9]+".r ^ $type(int.parse);
}

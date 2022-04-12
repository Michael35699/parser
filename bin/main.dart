import "package:parser_peg/internal_all.dart";

part "utils.dart";

Parser infixMath() => _addition.$;
Parser _addition() => _addition & "+" & _multiplication | _multiplication;
Parser _multiplication() => _multiplication & "*" & _atomic | _atomic;
Parser _atomic() => "[0-9]+".r ^ $type(int.parse) | "(".t & _addition & ")".t;

void main() {
  Parser built = calculatorParser.build();
  print << built.simplified().generateAsciiTree();
}

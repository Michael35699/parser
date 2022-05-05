import "package:parser/internal_all.dart";

part "utils.dart";

Parser expr() => expr & "-".t & expr | number;

void main() {
  print << expr.run("1-2-3");
}

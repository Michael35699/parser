import "package:parser/parser.dart" as parser;

parser.Parser expr() {
  parser.Parser built = parser.never();

  built |= expr & "+" & expr;
  built |= expr & "-" & expr;
  built |= parser.number;
  // built <<= parser.leftRecursive();

  return built;
}

void main() {
  print(expr.end.run("1-2-3", except: print));
  print(expr.generateAsciiTree());
}

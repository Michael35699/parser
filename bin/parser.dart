import "package:parser/parser.dart" as parser;

// Declarative style
parser.Parser expr() =>
    expr & "+" & expr ^ parser.$3((num l, _, num r) => l + r) | //
    expr & "-" & expr ^ parser.$3((num l, _, num r) => l - r) |
    parser.number;

int count = 0;

// Imperative style (WARNING: These are memoized, so as much as possible make them PURE FUNCTIONS.)
parser.Parser expression() {
  parser.Parser addition = expression & "+" & expression;
  addition ^= parser.$3((num left, _, num right) {
    return left + right;
  });

  parser.Parser subtraction = expression & "-" & expression;
  subtraction ^= parser.$3((num left, _, num right) {
    return left - right;
  });

  return addition | subtraction | parser.number();
}

void main() {
  print(expression.end.run("1+2+3", except: print));
  print(count);
}

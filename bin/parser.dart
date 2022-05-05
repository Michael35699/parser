// import "package:parser/src/util/shared/time.dart";
import "package:parser/example/parser/math.dart" as math_parser;
import "package:parser/parser.dart" as parser;

int counter = 0;

typedef Parser = parser.Parser;

void main() {
  Parser built = math_parser.postfix.unmapped();
  print(built.peg.left<Object>("1 2 3 + +"));
}

// import "package:parser/src/util/shared/time.dart";
import "package:parser/example/parser/math.dart" as math_parser;
import "package:parser/parser.dart" as parser;

int counter = 0;

typedef Parser = parser.Parser;

void main() {
  print(math_parser.infix.run("1 + 2 * 3 + 4 + 5 + 8"));
}

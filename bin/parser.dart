// import "package:parser/src/util/shared/time.dart";
// import "package:parser/example/parser/math.dart" as math_parser;
import "package:parser/parser.dart" as parser;

int counter = 0;

typedef Parser = parser.Parser;

Parser S() => S & S | "s"
  ..left();

void main() {
  Parser built = S.build();
  print(Parser.isRightRecursive(built));
  print(Parser.isDefinitelyRightRecursive(built));
  print(built.packrat("ssssss"));
  // print(built.packrat("1 2 3 + +"));
}

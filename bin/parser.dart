import "package:parser/parser.dart" as parser;

int counter = 0;

typedef Parser = parser.Parser;

Parser S() => S & S | "a";

void main() {
  const String input = "aaaaaaa";
  print(S.end.peg(input));
}

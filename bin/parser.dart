import "package:parser/parser.dart" as parser;

int counter = 0;

typedef Parser = parser.Parser;

Parser s() => s & "s" | "s";

void main() {
  print(s.run("ssssssssss"));
}

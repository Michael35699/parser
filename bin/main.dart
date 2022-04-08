import "package:parser_peg/internal_all.dart";

Parser parser() => parser & "p" | "p";

void main() {
  time(() {
    print(parser.run("pppp"));
  });
}

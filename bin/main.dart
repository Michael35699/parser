import "dart:io" show File;

import "package:parser_peg/internal_all.dart";

String get input => File("assets/text.grammar").readAsStringSync();

ChoiceParser parser() =>
    1.$ ^ parser[0] & "c" | //
    0.$ ^ "e";

void main() {
  Parser transformed = Parser.clone(parser.$[double.negativeInfinity]);
  print(transformed.run("ecccc"));
}

import "package:parser/parser.dart";
import "package:parser/util.dart";

part "utils.dart";

Parser S() => epsilon & S & "+".t & "1".t | "1".t;

void main() {
  Parser parser = S.build();
  time(() {
    print(parser.peg.linear("1 + 1 + 1"));
  });
}

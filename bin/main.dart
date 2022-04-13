import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => A & "a" | "a";
Parser A() => S & "d" | "d";

void main() {
  const String input = "adadadadada";
  Parser built = S.build();
  time.named("PEG", () {
    print << Parser.runPeg(built, input, end: false);
  });
  time.named("GLL", () {
    Parser.runGll(built, input).forEach(print);
  });
}

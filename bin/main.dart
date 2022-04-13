import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => A & "a" | "a";
Parser A() => S & "d" | "d";

void main() {
  const String input = "adadadadada";
  time.named("PEG", () {
    print << Parser.runPeg(S(), input, end: false);
  });
  time.named("GLL", () {
    Parser.runGll(S(), input).forEach(print);
  });
}

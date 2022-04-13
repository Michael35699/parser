import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => S & "a" | "a";

void main() {
  const String input = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  Parser built = S.build();
  Analyzer analyzer = Analyzer(built);
  analyzer.deepCheck();
  time.named("GLL", () {
    Parser.runGll(built, input).toList();
  });
  time.named("PEG^0", () {
    Parser.runPeg(built, input, end: false, mode: ParseMode.purePeg);
  });
  time.named("PEG^1", () {
    Parser.runPeg(built, input, end: false, mode: ParseMode.linearPeg);
  });
  time.named("PEG^2", () {
    Parser.runPeg(built, input, end: false, mode: ParseMode.squaredPeg);
  });
}

import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => S & "a" | "a";

void main() {
  const String input = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  Parser built = S.build();
  Analyzer analyzer = Analyzer(built);
  analyzer.deepCheck();

  time.named("GLL", () => built.gll(input).first);
  // time.named("PEG^0", () => built.peg.pure(input));
  time.named("PEG^1", () => built.peg.linear(input));
  time.named("PEG^2", () => built.peg.squared(input));
}

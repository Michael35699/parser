import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => S & "a" | "a";

void main() {
  const String input = "aaaaaaaa";

  Parser built = S.build();
  time.named("GLL", () => built.gll(input).toList());
  time.named("PEG", () => built.peg(input));
}

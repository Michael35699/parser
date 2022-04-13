import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => "a" & S | "a";

void main() {
  const String input = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  Parser built = S.build();
  time.named("GLL", () => built.gll(input).first);
  time.named("PEG^0", () => built.peg.pure(input));
  time.named("PEG^1", () => built.peg.linear(input));
  time.named("PEG^2", () => built.peg.squared(input));
  time.named("PEG^3", () => built.run(input));
}

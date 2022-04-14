import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => "a" | S & S;
void main() {
  const String input = "aaaaaaaaa";

  Parser built = S.build();
  time.named("PEG", () => print << built.gll(input).toList().length);
}

import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => "a" | S & S;
void main() {
  const String input = "aaaaa";

  Parser built = S.build();
  time.named("PEG", () {
    built.gll(input).forEach(print);
    return null;
  });
}

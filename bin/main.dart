import "package:parser_peg/internal_all.dart";

void main() {
  time(() {
    print(infixMath.run("-1 + 2 * 3 ^ 4 / 5 - 6 % 8 * 9 + 10 - 12-1 + 2 * 3"));
  });
}

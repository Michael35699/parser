// ignore_for_file: always_specify_types
import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => S & "a" | "a";

void main() {
  time(() {
    print(S.end.peg("aaaaaaaaa"));
  });
}

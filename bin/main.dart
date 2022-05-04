// ignore_for_file: always_specify_types
import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => S & S | "a".p;

void main() {
  time(() {
    print(S.peg("aaaaaaaaa"));
  });
}

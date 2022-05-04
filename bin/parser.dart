// ignore_for_file: always_specify_types
import "package:parser/internal_all.dart";

part "utils.dart";

Parser S() => S & "a" | "a";

extension SomeExtension<T> on T? {
  void also(void Function(T?) callback) => callback(this);
}

void main() {
  time(() {
    print(S.end.peg("aaaaaaaaa"));
  });
}

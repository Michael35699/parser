import "package:parser/internal_all.dart";

mixin Grammar {
  Parser start();

  T run<T extends Object?>(String input, {bool? map, bool? end}) => start().run<T>(input, map: map, end: end);
  Context runCtx(String input, {bool? end}) => start().runCtx(input, end: end);
}

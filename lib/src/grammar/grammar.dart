import "package:parser_peg/internal_all.dart";

mixin Grammar {
  Parser start();

  T run<T extends Object?>(String input, {bool? map, bool? end}) => start().run<T>(input, end: end);
  Context runCtx(String input, {bool? end}) => start().runCtx(input, end: end);
}

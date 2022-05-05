import "package:parser/internal_all.dart";

mixin Grammar {
  Parser start();

  R run<R extends ParseResult>(String input) => start.packrat(input);
  Context runCtx(String input) => start.runCtx(input);
  R packrat<R extends ParseResult>(String input, {PackratMode? mode}) => start.packrat(input, mode: mode);
  Context packratCtx(String input, {PackratMode? mode}) => start.packratCtx(input, mode: mode);

  Iterable<R> gll<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) =>
      start.gll(input, except: except);
  Iterable<Context> gllCtx(String input) => start.gllCtx(input);
}

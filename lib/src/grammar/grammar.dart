import "package:parser/internal_all.dart";

mixin Grammar {
  Parser start();

  R run<R extends ParseResult>(String input) => start.peg(input);
  Context runCtx(String input) => start.runCtx(input);
  R peg<R extends ParseResult>(String input, {ParseMode? mode}) => start.peg(input, mode: mode);
  Context pegCtx(String input, {ParseMode? mode}) => start.pegCtx(input, mode: mode);

  Iterable<R> gll<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) =>
      start.gll(input, except: except);
  Iterable<Context> gllCtx(String input) => start.gllCtx(input);
}

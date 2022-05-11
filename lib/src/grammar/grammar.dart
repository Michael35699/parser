import "package:parser/internal_all.dart";

mixin Grammar {
  Parser start();

  R run<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) => start.run(input, except: except);
  Context runCtx(String input) => start.runCtx(input);
  R packrat<R extends ParseResult>(String input, {PackratMode? mode, R Function(ContextFailure)? except}) =>
      start.packrat(input, mode: mode, except: except);
  Context packratCtx(String input, {PackratMode? mode}) => start.packratCtx(input, mode: mode);
  R peg<R extends ParseResult>(String input, {PegMode? mode, R Function(ContextFailure)? except}) =>
      start.peg(input, mode: mode, except: except);
  Context pegCtx(String input, {PegMode? mode}) => start.pegCtx(input, mode: mode);

  Iterable<R> gll<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) =>
      start.gll(input, except: except);
  Iterable<Context> gllCtx(String input) => start.gllCtx(input);
}

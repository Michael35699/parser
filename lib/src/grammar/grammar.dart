import "package:parser/internal_all.dart";

mixin Grammar {
  Parser start();

  R run<R extends ParseResult>(String input) => Parser.runPeg(start.$, input);
  Context runCtx(String input) => Parser.runCtxPeg(start.$, input);
  R peg<R extends ParseResult>(String input, {ParseMode? mode}) => Parser.runPeg(start.$, input, mode: mode);
  Context pegCtx(String input, {ParseMode? mode}) => Parser.runCtxPeg(start.$, input, mode: mode);
  Iterable<R> gll<R extends ParseResult>(String input, {Symbol? gllRun}) => Parser.runGll(start.$, input);
  Iterable<Context> gllCtx(String input, {Symbol? gllRun}) => Parser.runCtxGll(start.$, input);
}

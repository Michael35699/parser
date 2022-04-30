import "package:parser/internal_all.dart";

T _runPeg<T extends ParseResult>(Parser parser, String input, {ParseMode? mode, T Function(ContextFailure)? except}) {
  assert(mode != ParseMode.gll, "Running `ParseMode.gll` in runPeg method.");

  Context result = _runCtxPeg(parser, input, mode: mode);

  if (result is ContextFailure) {
    return except?.call(result) ?? (throw ParseException(result.message));
  } else if (result is ContextSuccess) {
    return result.mappedResult as T;
  }
  throw ParseException("Detected ignore context. Check the grammar.");
}

Context _runCtxPeg(Parser parser, String input, {ParseMode? mode}) {
  assert(mode != ParseMode.gll, "Running `ParseMode.gll` in runPeg method.");

  mode ??= ParseMode.quadraticPeg;

  Parser built = parser.build();
  String formatted = input.replaceAll("\r", "").unindent();
  PegParserMutable mutable = PegParserMutable();
  Context context = Context.ignore(State(input: formatted, mode: mode));
  Context result = built.pegApply(context, mutable);

  if (result is ContextFailure) {
    return result.withFailureMessage();
  } else {
    return result;
  }
}

extension ParserPegExtension on Parser {
  R run<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) =>
      _runPeg(this, input, mode: ParseMode.quadraticPeg, except: except);
  Context runCtx(String input) => _runCtxPeg(this, input, mode: ParseMode.quadraticPeg);

  R peg<R extends ParseResult>(String input, {ParseMode? mode, R Function(ContextFailure)? except}) =>
      _runPeg(this, input, mode: mode, except: except);
  Context pegCtx(String input, {ParseMode? mode}) => _runCtxPeg(this, input, mode: mode);
}

extension LazyParserPegParserExtension on Lazy<Parser> {
  R run<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) =>
      _runPeg(this.$, input, mode: ParseMode.quadraticPeg, except: except);
  Context runCtx(String input) => _runCtxPeg(this.$, input, mode: ParseMode.quadraticPeg);

  R peg<R extends ParseResult>(String input, {ParseMode? mode, R Function(ContextFailure)? except}) =>
      _runPeg(this.$, input, mode: mode, except: except);
  Context pegCtx(String input, {ParseMode? mode}) => _runCtxPeg(this.$, input, mode: mode);
}

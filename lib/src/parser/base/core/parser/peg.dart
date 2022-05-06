import "package:parser/internal_all.dart";

T _runPeg<T extends ParseResult>(Parser parser, String input, {PegMode? mode, T Function(ContextFailure)? except}) {
  Context result = _runCtxPeg(parser, input, mode: mode);

  if (result is ContextFailure) {
    if (except == null) {
      throw ParseException(result.withFailureMessage().message);
    }
    return except(result);
  } else if (result is ContextSuccess) {
    return result.mappedResult as T;
  }
  throw ParseException("Detected ignore context. Check the grammar.");
}

Context _runCtxPeg(Parser parser, String input, {PegMode? mode}) {
  mode ??= PegMode.left;

  Parser built = parser.build();
  String formatted = input.replaceAll("\r", "").unindent();
  PegHandler handler = PegHandler.peg(mode);
  Context context = Context.empty(State(input: formatted, parseMode: ParseMode.peg, pegMode: mode));
  Context result = handler.apply(built, context);

  return result;
}

extension ParserPegExtension on Parser {
  R peg<R extends ParseResult>(String input, {PegMode? mode, ExceptFunction<R>? except}) =>
      _runPeg(this, input, mode: mode, except: except);
  Context pegCtx(String input, {PegMode? mode}) => _runCtxPeg(this, input, mode: mode);
}

extension LazyParserPegParserExtension on Lazy<Parser> {
  R peg<R extends ParseResult>(String input, {PegMode? mode, ExceptFunction<R>? except}) => //
      this.$.peg(input, mode: mode, except: except);
  Context pegCtx(String input, {PegMode? mode}) => this.$.pegCtx(input, mode: mode);
}

extension PegExtendedFunctionExtension on //
    R Function<R extends ParseResult>(String input, {PegMode? mode, ExceptFunction<R>? except}) {
  R pure<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      this(input, mode: PegMode.pure, except: except);
  R left<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      this(input, mode: PegMode.left, except: except);
}

extension PegContextExtendedFunctionExtension on //
    Context Function(String input, {PegMode? mode}) {
  Context pure(String input) => this(input, mode: PegMode.pure);
  Context left(String input) => this(input, mode: PegMode.left);
}

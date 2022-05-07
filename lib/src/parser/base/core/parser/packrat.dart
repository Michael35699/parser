import "package:parser/internal_all.dart";

T _runPackrat<T extends ParseResult>(Parser parser, String input,
    {PackratMode? mode, T Function(ContextFailure)? except}) {
  Context result = _runCtxPackrat(parser, input, mode: mode);

  if (result is ContextFailure) {
    ContextFailure message = result.withFailureMessage();
    if (except == null) {
      throw ParseException(message.message);
    }
    return except(message);
  } else if (result is ContextSuccess) {
    return result.mappedResult as T;
  }
  throw ParseException("Detected ignore context. Check the grammar.");
}

Context _runCtxPackrat(Parser parser, String input, {PackratMode? mode}) {
  mode ??= PackratMode.quadratic;

  Parser built = parser.build();
  String formatted = input.replaceAll("\r", "").unindent();
  PegHandler handler = PegHandler.packrat(mode);
  Context context = Context.empty(State(input: formatted, parseMode: ParseMode.packrat, packratMode: mode));
  Context result = handler.apply(built, context);

  return result;
}

extension ParserPackratExtension on Parser {
  R run<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      _runPackrat(this, input, mode: PackratMode.quadratic, except: except);
  Context runCtx(String input) => _runCtxPackrat(this, input, mode: PackratMode.quadratic);

  R packrat<R extends ParseResult>(String input, {PackratMode? mode, ExceptFunction<R>? except}) =>
      _runPackrat(this, input, mode: mode, except: except);
  Context packratCtx(String input, {PackratMode? mode}) => _runCtxPackrat(this, input, mode: mode);
}

extension LazyParserPackratParserExtension on Lazy<Parser> {
  R run<R extends ParseResult>(String input, {ExceptFunction<R>? except}) => //
      this.$.run(input, except: except);
  Context runCtx(String input) => this.$.runCtx(input);

  R packrat<R extends ParseResult>(String input, {PackratMode? mode, ExceptFunction<R>? except}) => //
      this.$.packrat(input, mode: mode, except: except);
  Context packratCtx(String input, {PackratMode? mode}) => this.$.packratCtx(input, mode: mode);
}

extension PackratExtendedFunctionExtension on //
    R Function<R extends ParseResult>(String input, {PackratMode? mode, ExceptFunction<R>? except}) {
  R basic<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      this(input, mode: PackratMode.basic, except: except);
  R linear<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      this(input, mode: PackratMode.linear, except: except);
  R quadratic<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      this(input, mode: PackratMode.quadratic, except: except);
}

extension PackratContextExtendedFunctionExtension on //
    Context Function(String input, {PackratMode? mode}) {
  Context basic(String input) => this(input, mode: PackratMode.basic);
  Context linear(String input) => this(input, mode: PackratMode.linear);
  Context quadratic(String input) => this(input, mode: PackratMode.quadratic);
}

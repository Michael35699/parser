import "package:parser/internal_all.dart";

T _runPeg<T extends ParseResult>(Parser parser, String input, {PegMode? mode, T Function(ContextFailure)? except}) {
  Context result = _runCtxPeg(parser, input, mode: mode);

  if (result is ContextFailure) {
    if (except == null) {
      throw ParseException(result.message);
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
  Context context = Context.ignore(State(input: formatted, parseMode: ParseMode.peg, pegMode: mode));
  Context result = handler.apply(built, context);

  if (result is ContextFailure) {
    return result.withFailureMessage();
  } else {
    return result;
  }
}

extension ParserPegExtension on Parser {
  R peg<R extends ParseResult>(String input, {PegMode? mode, R Function(ContextFailure)? except}) =>
      _runPeg(this, input, mode: mode, except: except);
  Context pegCtx(String input, {PegMode? mode}) => _runCtxPeg(this, input, mode: mode);
}

extension LazyParserPegParserExtension on Lazy<Parser> {
  R peg<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) => //
      this.$.peg(input, except: except);
  Context pegCtx(String input) => this.$.pegCtx(input);
}

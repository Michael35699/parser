import "package:parser/internal_all.dart";

Iterable<T> _runGll<T extends ParseResult>(Parser parser, String input, {T Function(ContextFailure)? except}) sync* {
  Iterable<Context> results = _runCtxGll(parser, input);

  for (Context ctx in results) {
    if (ctx is ContextSuccess) {
      yield ctx.mappedResult as T;
    } else if (ctx is ContextFailure) {
      if (except == null) {
        throw ParseException(ctx.message);
      }
      yield except(ctx);
    }
  }
}

Iterable<Context> _runCtxGll(Parser parser, String input) sync* {
  ContextFailure? longestFailure;
  Parser built = parser.build();
  String formatted = input.replaceAll("\r", "").unindent();
  Trampoline trampoline = Trampoline();
  Context context = Context.ignore(State(input: formatted, parseMode: ParseMode.gll));
  List<ContextSuccess> successes = <ContextSuccess>[];

  trampoline.push(built, context, (Context context) {
    if (context is ContextSuccess) {
      successes.add(context);
    } else if (context is ContextFailure) {
      longestFailure = longestFailure == null
          ? context
          : longestFailure!.state.index < context.state.index
              ? context
              : longestFailure;
    }
  });

  bool hasYielded = false;
  do {
    while (successes.isEmpty && trampoline.stack.isNotEmpty) {
      trampoline.step();
    }

    while (successes.isNotEmpty) {
      yield successes.removeLast();

      hasYielded |= true;
    }
  } while (trampoline.stack.isNotEmpty);

  if (!hasYielded && longestFailure != null) {
    yield longestFailure!.withFailureMessage();
  }
}

extension ParserGllExtension on Parser {
  Iterable<R> gll<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) =>
      _runGll(this, input, except: except);

  Iterable<Context> gllCtx(String input) => _runCtxGll(this, input);
}

extension LazyParserGllParserExtension on Lazy<Parser> {
  Iterable<R> gll<R extends ParseResult>(String input, {R Function(ContextFailure)? except}) =>
      _runGll(this.$, input, except: except);

  Iterable<Context> gllCtx(String input) => _runCtxGll(this.$, input);
}

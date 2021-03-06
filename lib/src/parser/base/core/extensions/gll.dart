import "package:parser/internal_all.dart";

Iterable<T> _runGll<T extends ParseResult>(Parser parser, String input, {T Function(ContextFailure)? except}) sync* {
  Iterable<Context> results = _runCtxGll(parser, input);

  for (Context ctx in results) {
    if (ctx is ContextSuccess) {
      yield ctx.mappedResult as T;
    } else if (ctx is ContextFailure) {
      ContextFailure context = ctx.withFailureMessage();
      if (except == null) {
        throw ParseException(context.message);
      }
      yield except(context);
    }
  }
}

Iterable<Context> _runCtxGll(Parser parser, String input) sync* {
  ContextFailure? longestFailure;
  Parser built = parser.build();
  String formatted = input.replaceAll("\r", "").unindent();
  Trampoline trampoline = Trampoline();
  Context context = Context.empty(State(buffer: formatted));
  List<Context> successes = <Context>[];

  trampoline.push(built, context, (Context context) {
    if (context is! ContextFailure) {
      successes.add(context);
    } else {
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
    yield longestFailure!;
  }
}

extension ParserGllExtension on Parser {
  Iterable<R> gll<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      _runGll(this, input, except: except);

  Iterable<Context> gllCtx(String input) => _runCtxGll(this, input);
}

extension LazyParserGllParserExtension on Lazy<Parser> {
  Iterable<R> gll<R extends ParseResult>(String input, {ExceptFunction<R>? except}) =>
      _runGll(this.$, input, except: except);

  Iterable<Context> gllCtx(String input) => _runCtxGll(this.$, input);
}

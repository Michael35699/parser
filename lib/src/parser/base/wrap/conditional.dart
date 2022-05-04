import "dart:collection";

import "package:parser/internal_all.dart";

class ConditionalParser extends SpecialParser {
  final HashMap<Context, Parser> _saved = HashMap<Context, Parser>();

  final Parser Function(Context) function;
  final Parser parser;

  ConditionalParser(this.parser, this.function);

  Parser resolve(Context context) => _saved[context] ??= function(context);

  @override
  Context parsePeg(Context context, PegHandler handler) =>
      ((Context ctx) => handler.apply(function(context), ctx))(handler.apply(parser, context));

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      trampoline.push(parser, context, (Context ctx) {
        trampoline.push(function(context), ctx, continuation);
      });
}

extension ParserConditionalExtension on Parser {
  ConditionalParser conditional(Parser Function(Context) fn) => ConditionalParser(this, fn);
}

extension LazyParserConditionalParserExtension on Lazy<Parser> {
  ConditionalParser conditional(Parser Function(Context) fn) => ConditionalParser(this.$, fn);
}

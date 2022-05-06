import "package:parser/internal_all.dart";

class ConditionalParser extends WrapParser {
  final Parser Function(Context) function;

  @override
  Parser get parser => children[0];

  ConditionalParser(Parser parser, this.function) : super(<Parser>[parser]);
  ConditionalParser.empty(this.function) : super(<Parser>[]);

  Parser resolve(Context context) => function(context);

  @override
  Context parsePeg(Context context, PegHandler handler) =>
      ((Context ctx) => handler.apply(function(context), ctx))(handler.apply(parser, context));

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      trampoline.push(parser, context, (Context ctx) {
        trampoline.push(function(context), ctx, continuation);
      });

  @override
  ConditionalParser empty() => ConditionalParser.empty(function);
}

extension ParserConditionalExtension on Parser {
  ConditionalParser conditional(Parser Function(Context) fn) => ConditionalParser(this, fn);
}

extension LazyParserConditionalExtension on Lazy<Parser> {
  ConditionalParser conditional(Parser Function(Context) fn) => ConditionalParser(this.$, fn);
}

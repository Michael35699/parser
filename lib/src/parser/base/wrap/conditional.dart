import "dart:collection";

import "package:parser_peg/internal_all.dart";

class ConditionalParser extends SpecialParser {
  final HashMap<Context, Parser> _saved = HashMap<Context, Parser>();

  final Parser Function(Context) function;
  final Parser parser;

  ConditionalParser(this.parser, this.function);

  Parser resolve(Context context) => _saved[context] ??= function(context);

  @override
  Context parse(Context context, ParserEngine engine) =>
      ((Context ctx) => engine.apply(function(context), ctx))(engine.apply(parser, context));
}

extension ConditionalParserExtension on Parser {
  ConditionalParser conditional(Parser Function(Context) fn) => ConditionalParser(this, fn);
  ConditionalParser bind(Parser Function(Context) fn) => ConditionalParser(this, fn);
}

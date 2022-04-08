import "dart:collection";

import "package:parser_peg/internal_all.dart";

class ConditionalParser extends SpecialParser {
  final HashMap<Context, Parser> _saved = HashMap<Context, Parser>();

  final Parser Function(Context) function;
  final Parser parser;

  ConditionalParser(this.parser, this.function);

  Parser resolve(Context context) => _saved[context] ??= function(context);

  @override
  Context parse(Context context, MemoizationHandler handler) =>
      ((Context ctx) => function(context).parseCtx(ctx, handler))(parser.parseCtx(context, handler));
}

extension ConditionalParserExtension on Parser {
  ConditionalParser conditional(Parser Function(Context) fn) => ConditionalParser(this, fn);
  ConditionalParser bind(Parser Function(Context) fn) => ConditionalParser(this, fn);
}

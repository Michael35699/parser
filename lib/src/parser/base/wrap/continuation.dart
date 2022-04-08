import "package:parser_peg/internal_all.dart";

class ContinuationParser extends WrapParser {
  final ContinuationFunction handler;
  Parser get parser => children[0];

  ContinuationParser(Parser parser, this.handler) : super(<Parser>[parser]);
  ContinuationParser.empty(this.handler) : super(<Parser>[]);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    return this.handler((Context ctx) => parser.parseCtx(ctx, handler), context);
  }

  @override
  Parser get base => parser.base;

  @override
  ContinuationParser empty() => ContinuationParser.empty(handler);
}

extension ContinuationParserExtension on Parser {
  ContinuationParser cc(ContinuationFunction fn) => ContinuationParser(this, fn);
}

extension LazyContinuationParserExtension on Lazy<Parser> {
  ContinuationParser cc(ContinuationFunction fn) => ContinuationParser(this.$, fn);
}

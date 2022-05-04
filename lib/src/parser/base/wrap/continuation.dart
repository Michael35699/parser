import "package:parser/internal_all.dart";

class ContinuationParser extends WrapParser {
  final ContinuationFunction function;
  @override
  Parser get parser => children[0];

  ContinuationParser(Parser parser, this.function) : super(<Parser>[parser]);
  ContinuationParser.empty(this.function) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    return function((Context ctx) => handler.apply(parser, ctx), context);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    return trampoline.push(parser, context, continuation);
  }

  @override
  Parser get base => parser.base;

  @override
  ContinuationParser empty() => ContinuationParser.empty(function);

  @override
  bool hasEqualProperties(ContinuationParser target) => super.hasEqualProperties(target) && target.function == function;
}

extension ParserContinuationExtension on Parser {
  ContinuationParser cc(ContinuationFunction fn) => ContinuationParser(this, fn);
}

extension LazyParserContinuationParserExtension on Lazy<Parser> {
  ContinuationParser cc(ContinuationFunction fn) => ContinuationParser(this.$, fn);
}

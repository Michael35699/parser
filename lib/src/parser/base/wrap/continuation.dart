import "package:parser/internal_all.dart";

class ContinuationParser extends WrapParser {
  final ContinuationFunction handler;
  @override
  Parser get parser => children[0];

  ContinuationParser(Parser parser, this.handler) : super(<Parser>[parser]);
  ContinuationParser.empty(this.handler) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    return handler((Context ctx) => parser.pegApply(ctx, mutable), context);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    return trampoline.push(parser, context, continuation);
    log.todo("Implement ContinuationParser for GLL.");
  }

  @override
  Parser get base => parser.base;

  @override
  ContinuationParser empty() => ContinuationParser.empty(handler);

  @override
  bool hasEqualProperties(ContinuationParser target) => super.hasEqualProperties(target) && target.handler == handler;
}

extension ContinuationParserExtension on Parser {
  ContinuationParser cc(ContinuationFunction fn) => ContinuationParser(this, fn);
}

extension LazyContinuationParserExtension on Lazy<Parser> {
  ContinuationParser cc(ContinuationFunction fn) => ContinuationParser(this.$, fn);
}

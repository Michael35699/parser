import "package:parser_peg/internal_all.dart";

class ContextualParser<T> extends SpecialParserMixin {
  final Parser Function(Set<T>) callback;

  ContextualParser(this.callback);

  @override
  Context parse(Context context, MemoizationHandler handler) =>
      callback(context.state.dataSet.cast()).parseCtx(context, handler);
}

ContextualParser<T> context<T>(Parser Function(Set<T>) callback) => ContextualParser<T>(callback);

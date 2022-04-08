import "package:parser_peg/internal_all.dart";

class ContextualParser<T> extends SpecialParser {
  final Parser Function(Set<T>) callback;

  ContextualParser(this.callback);

  @override
  Context parse(Context context, MemoizationHandler handler) =>
      callback(context.state.dataSet.cast()).parseCtx(context, handler);
}

ContextualParser<T> ctx<T>(Parser Function(Set<T>) callback) => ContextualParser<T>(callback);

import "package:parser/internal_all.dart";

class ContextualParser<T> extends SpecialParser {
  final Parser Function(Set<T>) callback;

  ContextualParser(this.callback);

  @override
  Context parsePeg(Context context, PegHandler handler) =>
      handler.apply(callback(context.state.dataSet.cast()), context);

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      trampoline.push(callback(context.state.dataSet.cast()), context, continuation);
}

ContextualParser<T> ctx<T>(Parser Function(Set<T>) callback) => ContextualParser<T>(callback);

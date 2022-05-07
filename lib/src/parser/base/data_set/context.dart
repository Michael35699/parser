import "package:parser/internal_all.dart";

class ContextualParser<T> extends ChildlessParser {
  final Parser Function(List<T>) callback;

  ContextualParser(this.callback);

  @override
  Context parsePeg(Context context, PegHandler handler) =>
      handler.apply(callback(context.state.dataStack.cast()), context);

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      trampoline.push(callback(context.state.dataStack.cast()), context, continuation);
}

ContextualParser<T> ctx<T>(Parser Function(List<T>) callback) => ContextualParser<T>(callback);

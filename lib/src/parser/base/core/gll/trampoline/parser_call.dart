import "package:parser/internal_all.dart";

///
/// Wrapper class that contains the:
///   1. Parser to be called,
///   2. Context in the moment of push,
///   3. A reference to the trampoline,
///   4. A continuation function.
///
class GllParserCall {
  final GllParseFunction function;
  final Context context;
  final Trampoline trampoline;
  final GllContinuation continuation;

  const GllParserCall(this.function, this.context, this.trampoline, this.continuation);

  void call() => function(context, trampoline, continuation);
}

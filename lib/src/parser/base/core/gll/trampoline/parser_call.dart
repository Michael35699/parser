import "package:parser/internal_all.dart";

class GllParserCall {
  final GllParseFunction function;
  final Context context;
  final Trampoline trampoline;
  final GllContinuation continuation;

  const GllParserCall(this.function, this.context, this.trampoline, this.continuation);
}

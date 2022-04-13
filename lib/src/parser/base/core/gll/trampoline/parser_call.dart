import "package:parser/internal_all.dart";

int ticks = 0;

///
/// Wrapper class that contains the:
///   1. Parser to be called,
///   2. Context in the moment of push,
///   3. A reference to the trampoline,
///   3. A continuation function.
///
class ParserCall {
  final Parser parser;
  final Context context;
  final Trampoline trampoline;
  final Continuation continuation;

  const ParserCall(this.parser, this.context, this.trampoline, this.continuation);

  void call() {
    ticks++;
    // ignore: deprecated_member_use_from_same_package
    parser.parseGll(context, trampoline, continuation);
  }
}

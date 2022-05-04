import "package:parser/internal_all.dart";

class FailureParser extends SpecialParser {
  final String message;

  FailureParser(this.message);

  @override
  Context parsePeg(Context context, PegHandler handler) => context.failure(message).generated();

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      continuation(context.failure(message).generated());

  @override
  bool hasEqualProperties(FailureParser target) {
    return super.hasEqualProperties(target) && target.message == message;
  }
}

FailureParser failure(String message) => FailureParser(message);

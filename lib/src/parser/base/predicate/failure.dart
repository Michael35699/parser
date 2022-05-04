import "package:parser/internal_all.dart";

class FailureParser extends SpecialParser {
  final String message;

  FailureParser(this.message);

  @override
  Context parsePure(Context context) => context.failure(message).generated();

  @override
  bool hasEqualProperties(FailureParser target) {
    return super.hasEqualProperties(target) && target.message == message;
  }
}

FailureParser failure(String message) => FailureParser(message);

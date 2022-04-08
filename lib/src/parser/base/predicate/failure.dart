import "package:parser_peg/internal_all.dart";

class FailureParser extends SpecialParser {
  final String message;

  FailureParser(this.message);

  @override
  Context parse(Context context, MemoizationHandler handler) => context.failure(message);

  @override
  bool hasEqualProperties(FailureParser target) {
    return super.hasEqualProperties(target) && target.message == message;
  }
}

FailureParser failure(String message) => FailureParser(message);

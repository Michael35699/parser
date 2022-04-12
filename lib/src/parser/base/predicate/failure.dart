import "package:parser_peg/internal_all.dart";

class FailureParser extends SpecialParser {
  final String message;

  FailureParser(this.message);

  @override
  Context parse(Context context, ParserMutable mutable) => context.failure(message).generated();

  @override
  bool hasEqualProperties(FailureParser target) {
    return super.hasEqualProperties(target) && target.message == message;
  }
}

FailureParser failure(String message) => FailureParser(message);

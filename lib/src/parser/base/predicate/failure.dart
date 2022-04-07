import "package:parser_peg/internal_all.dart";

class FailureParser extends SpecialParserMixin {
  final String message;

  FailureParser(this.message);

  @override
  Context parse(Context context, MemoizationHandler handler) => context.failure(message);
}

FailureParser failure(String message) => FailureParser(message);

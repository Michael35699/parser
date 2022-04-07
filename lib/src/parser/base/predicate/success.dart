import "package:parser_peg/internal_all.dart";

class SuccessParser extends SpecialParserMixin {
  late final ParseResult mappedResult;
  late final ParseResult unmappedResult;

  SuccessParser(Object? mapped, [Object? unmapped = #NO]) {
    if (unmapped == #NO) {
      unmapped = mapped;
    }

    mappedResult = mapped;
    unmappedResult = unmapped;
  }

  @override
  Context parse(Context context, MemoizationHandler handler) => context.success(mappedResult, unmappedResult);
}

SuccessParser success(Object? mapped, [Object? unmapped = #NO]) => SuccessParser(mapped, unmapped);

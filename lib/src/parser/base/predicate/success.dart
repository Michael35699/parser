import "package:parser/internal_all.dart";

class SuccessParser extends SpecialParser {
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
  Context parsePure(Context context) => context.success(mappedResult, unmappedResult);

  @override
  bool hasEqualProperties(SuccessParser target) {
    return super.hasEqualProperties(target) &&
        target.mappedResult.hashCode == mappedResult.hashCode &&
        target.unmappedResult.hashCode == unmappedResult.hashCode;
  }
}

SuccessParser success(Object? mapped, [Object? unmapped = #NO]) => SuccessParser(mapped, unmapped);

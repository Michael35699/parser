import "package:parser_peg/internal_all.dart";

class UnicodeRangeParser extends LeafParser {

  final int low;
  final int high;

  UnicodeRangeParser(this.low, this.high);

  @override
  String get failureMessage => expected("unicode value within [$low, $high]");

  @override
  int? parseLeaf(String input, int index) {
    if (index >= input.length) {
      return null;
    }

    int charCode = input.codeUnitAt(index);
    if (low <= charCode && charCode <= high) {
      return index + 1;
    }
    return null;
  }

  @override
  String toString() => "[$low-$high]";

  @override
  bool hasEqualProperties(UnicodeRangeParser target) {
    return super.hasEqualProperties(target) && target.low == low && target.high == high;
  }
}

extension UnicodeRangeParserExtension on String {
  // UnicodeRangeParser operator >>(String otherChar) {
  //   if (<String>{otherChar, this}.any((String c) => c.length > 1)) {
  //     throw ArgumentError("Unicode ranges should only be used on single characters.");
  //   }

  //   return UnicodeRangeParser(codeUnitAt(0), otherChar.codeUnitAt(0));
  // }

  UnicodeRangeParser urng(String otherChar) {
    if (<String>{otherChar, this}.any((String c) => c.length > 1)) {
      throw ArgumentError("Unicode ranges should only be used on single characters.");
    }

    return UnicodeRangeParser(codeUnitAt(0), otherChar.codeUnitAt(0));
  }
}

UnicodeRangeParser unicodeRange(int low, int high) => UnicodeRangeParser(low, high);
// UnicodeRangeParser urng(int low, int high) => UnicodeRangeParser(low, high);

CallableFunction2<int, int, UnicodeRangeParser> urng =
    CallableFunction2((int low) => CallableFunction1((int high) => UnicodeRangeParser(low, high)));

import "package:parser/src/parser/base/core/peg/handler/linear/memo_entry.dart";

class LeftRecursion with LinearPegMemoValue {
  bool detected;

  LeftRecursion() : detected = false;
}

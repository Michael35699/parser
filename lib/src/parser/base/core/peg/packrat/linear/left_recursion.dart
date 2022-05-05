import "package:parser/src/parser/base/core/peg/packrat/linear.dart";

class LeftRecursion with LinearPegMemoValue {
  bool detected;

  LeftRecursion() : detected = false;
}

import "dart:collection";

import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/quadratic.dart";

typedef MemoizationMap = HashMap<Parser, MemoizationSubMap>;
typedef MemoizationSubMap = HashMap<int, MemoizationEntry>;
typedef MemoizationValue = QuadraticPegMemoValue;
typedef Heads = HashMap<int, Head>;

import "dart:collection";

import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/quadratic.dart";

typedef MemoizationMap = HashMap<Parser, PegMemoizationSubMap>;
typedef PegMemoizationSubMap = HashMap<int, MemoizationEntry>;
typedef MemoizationValue = QuadraticPegMemoValue;
typedef Heads = HashMap<int, Head>;

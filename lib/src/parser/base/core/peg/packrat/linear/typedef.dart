import "dart:collection";

import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/linear.dart";
import "package:parser/src/util/classes/default_map.dart";

typedef MemoizationMap = DefaultMap<Parser, MemoizationSubMap>;
typedef MemoizationSubMap = HashMap<int, MemoizationEntry>;
typedef MemoizationValue = LinearPegMemoValue;

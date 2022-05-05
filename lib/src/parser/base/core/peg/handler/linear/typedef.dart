import "dart:collection";

import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/linear/memo_entry.dart";
import "package:parser/src/util/classes/default_map.dart";

typedef PegMemoizationMap = DefaultMap<Parser, PegMemoizationSubMap>;
typedef PegMemoizationSubMap = HashMap<int, PegMemoizationEntry>;
typedef MemoizationValue = LinearPegMemoValue;

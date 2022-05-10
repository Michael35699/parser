import "dart:collection";

import "package:parser/internal_all.dart";
import "package:parser/src/util/classes/default_map.dart";

typedef MemoizationMap = DefaultMap<Parser, MemoizationSubMap>;
typedef MemoizationSubMap = HashMap<int, Context>;

import "dart:collection";

import "package:parser/internal_all.dart";

typedef MemoizationMap = HashMap<Parser, MemoizationSubMap>;
typedef MemoizationSubMap = HashMap<int, Context>;

import "dart:collection";

import "package:parser/internal_all.dart";

typedef PegMemoizationMap = HashMap<Parser, PegMemoizationSubMap>;
typedef PegMemoizationSubMap = HashMap<int, PegMemoizationEntry>;
typedef PegHeads = HashMap<int, Head>;

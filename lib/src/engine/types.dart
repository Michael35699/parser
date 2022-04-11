import "dart:collection";

import "package:parser_peg/internal_all.dart";

typedef MemoizationMap = HashMap<Parser, MemoizationSubMap>;
typedef MemoizationSubMap = HashMap<int, MemoEntry>;
typedef Heads = HashMap<int, Head>;

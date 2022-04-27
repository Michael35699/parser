import "dart:collection";

import "package:parser/internal_all.dart";

typedef GllContinuation = void Function(Context);
typedef GllParseFunction = void Function(Context, Trampoline, GllContinuation);
typedef GllMemoizationMap = HashMap<Parser, HashMap<int, HashMap<num, GllTableEntry>>>;

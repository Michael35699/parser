import "dart:collection";

import "package:parser/internal_all.dart";
import "package:parser/src/util/classes/default_map.dart";

typedef SeedMap = DefaultMap<Parser, SeedSubMap>;
typedef SeedSubMap = HashMap<int, Context>;

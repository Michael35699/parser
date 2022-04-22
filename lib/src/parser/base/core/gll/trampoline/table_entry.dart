import "dart:collection";

import "package:parser/internal_all.dart";

class GllTableEntry {
  final List<GllContinuation> continuations;
  final HashSet<Context> results;

  GllTableEntry()
      : continuations = <GllContinuation>[],
        results = HashSet<Context>();
}

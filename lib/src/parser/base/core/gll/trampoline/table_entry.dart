import "dart:collection";

import "package:parser/internal_all.dart";

class GllTableEntry {
  final List<GllContinuation> continuations;
  final HashSet<Context> results;

  GllTableEntry.empty()
      : continuations = <GllContinuation>[],
        results = HashSet<Context>();

  bool get isEmpty => continuations.isEmpty && results.isEmpty;
}

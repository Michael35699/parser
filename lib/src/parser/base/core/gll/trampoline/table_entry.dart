import "dart:collection";

import "package:parser/internal_all.dart";

class GllTableEntry {
  final Queue<GllContinuation> continuations;
  final HashSet<Context> results;

  GllTableEntry()
      : continuations = Queue<GllContinuation>(),
        results = HashSet<Context>();
}

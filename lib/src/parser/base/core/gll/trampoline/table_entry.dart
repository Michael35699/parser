import "dart:collection";

import "package:parser/internal_all.dart";

class GllTableEntry {
  final HashSet<GllContinuation> continuations;
  final HashSet<Context> results;

  GllTableEntry()
      : continuations = HashSet<GllContinuation>.identity(),
        results = HashSet<Context>.identity();

  bool get isEmpty => continuations.isEmpty && results.isEmpty;
}

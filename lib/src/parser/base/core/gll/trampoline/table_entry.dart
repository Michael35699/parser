import "dart:collection";

import "package:parser/internal_all.dart";

///
/// The class that holds both the `continuations` and `results`
/// of a parser on a specific `Context` object.
///
class TableEntry {
  final List<Continuation> continuations;

  /// HashSet because it sped up performance by 3x from lookups.
  final HashSet<Context> results;

  TableEntry.empty()
      : continuations = <Continuation>[],
        results = HashSet<Context>();

  bool get isEmpty => continuations.isEmpty && results.isEmpty;
}

import "dart:collection";

import "package:parser/internal_all.dart";

///
/// The magic part of the GLL algorithm.
/// This handles both the ambiguity, and the left recursion
/// of any CFG (Context-Free Grammar).
///
/// Pretty slow though.
///
class Trampoline {
  final Queue<GllParserCall> stack;
  final HashMap<Parser, HashMap<Context, GllTableEntry>> table;

  Trampoline()
      : stack = Queue<GllParserCall>(),
        table = HashMap<Parser, HashMap<Context, GllTableEntry>>();

  bool hasNext() => stack.isNotEmpty;

  void step() {
    if (hasNext()) {
      stack.removeLast().call();
    }
  }

  void push(Parser parser, Context context, GllContinuation continuation) {
    ///
    /// We grab the existing (or newly made) entry in the
    /// memoization table.
    ///
    GllTableEntry? tableEntry = table.putIfAbsent(parser, HashMap<Context, GllTableEntry>.new)[context];

    ///
    /// If the entry is newly made, call this branch.
    ///
    if (tableEntry == null) {
      tableEntry = table[parser]![context] = GllTableEntry.empty();
      tableEntry.continuations.add(continuation);

      stack.add(GllParserCall(parser.parseGll, context, this, (Context result) {
        if (tableEntry!.results.contains(result)) {
          return;
        }

        tableEntry.results.add(result);
        for (GllContinuation continuation in tableEntry.continuations.toList()) {
          continuation(result);
        }
      }));
    } else {
      tableEntry.continuations.add(continuation);
      tableEntry.results.toSet().forEach(continuation);
    }
  }
}

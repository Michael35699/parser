import "dart:collection";

import "package:parser/internal_all.dart";

int calls = 0;
HashMap<Parser, int> parsersTimeSpent = HashMap<Parser, int>();
HashMap<Parser, int> parsersCallCount = HashMap<Parser, int>();

///
/// The magic part of the GLL algorithm.
/// This handles both the ambiguity, and the left recursion
/// of any CFG (Context-Free Grammar).
///
/// Pretty slow though.
///
class Trampoline {
  final Queue<ParserCall> stack;
  final HashMap<Parser, HashMap<Context, TableEntry>> table;

  Trampoline()
      : stack = Queue<ParserCall>(),
        table = HashMap<Parser, HashMap<Context, TableEntry>>();

  bool hasNext() => stack.isNotEmpty;

  void step() {
    if (hasNext()) {
      stack.removeLast().call();
    }
  }

  void push(Parser parser, Context context, Continuation continuation) {
    ///
    /// We grab the existing (or newly made) entry in the
    /// memoization table.
    ///
    TableEntry? tableEntry = (table[parser] ??= HashMap<Context, TableEntry>())[context];

    ///
    /// If the entry is newly made, call this branch.
    ///
    if (tableEntry == null) {
      tableEntry = table[parser]![context] = TableEntry.empty();

      ///
      /// If you're wondering why I don't put this line outside
      /// of the if-statement, especially if it's the first line
      /// of both branches, it's because the function suddenly
      /// fails when it's not in one of these branches.
      ///
      /// ... I don't know why.
      ///
      tableEntry.continuations.add(continuation);

      stack.add(ParserCall(parser, context, this, (Context result) {
        ///
        /// Ignore this call if the result is already in the table.
        ///
        if (tableEntry!.results.contains(result)) {
          return;
        }

        tableEntry.results.add(result);
        for (Continuation continuation in tableEntry.continuations.toList()) {
          continuation(result);
        }
      }));
    } else {
      ///
      /// Add the continuation to the  existing continuation list,
      /// and for each result of the parser, run the continuation.
      ///
      tableEntry.continuations.add(continuation);
      tableEntry.results.toSet().forEach(continuation);
    }
  }
}

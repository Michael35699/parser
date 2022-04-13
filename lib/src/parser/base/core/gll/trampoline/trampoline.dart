// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:parser/internal_all.dart";

class Trampoline {
  final Queue<GllParserCall> stack;
  final HashMap<Parser, HashMap<Context, GllTableEntry>> table;

  Trampoline()
      : stack = Queue<GllParserCall>(),
        table = HashMap<Parser, HashMap<Context, GllTableEntry>>();

  void step() {
    stack.removeLast().call();
  }

  void push(Parser parser, Context context, GllContinuation continuation) {
    GllTableEntry? tableEntry = table.putIfAbsent(parser, HashMap<Context, GllTableEntry>.new)[context];

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

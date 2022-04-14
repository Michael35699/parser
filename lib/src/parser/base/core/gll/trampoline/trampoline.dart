// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:parser/internal_all.dart";

class Trampoline {
  final Queue<GllParserCall> stack;
  final GllMemoizationTable table;

  Trampoline()
      : stack = Queue<GllParserCall>(),
        table = GllMemoizationTable();

  void step() {
    stack.removeLast().call();
  }

  void push(Parser parser, Context context, GllContinuation continuation) {
    int index = context.state.index;
    GllTableEntry tableEntry = table.putIfAbsent(parser, GllSubTable.new)[index] ??= GllTableEntry();

    if (tableEntry.isEmpty) {
      tableEntry.continuations.add(continuation);
      stack.add(GllParserCall(parser.parseGll, context, this, (Context result) {
        if (tableEntry.results.add(result)) {
          for (GllContinuation continuation in tableEntry.continuations.toSet()) {
            continuation(result);
          }
        }
      }));
    } else {
      tableEntry.continuations.add(continuation);
      for (Context result in tableEntry.results.toSet()) {
        continuation(result);
      }
    }
  }
}

// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:parser/internal_all.dart";

class Trampoline {
  final Queue<GllParserCall> stack;
  final HashMap<Parser, HashMap<int, HashMap<num, GllTableEntry>>> table;

  Trampoline()
      : stack = Queue<GllParserCall>(),
        table = HashMap<Parser, HashMap<int, HashMap<num, GllTableEntry>>>();

  void step() {
    GllParserCall latest = stack.removeLast();
    latest.function(latest.context, this, latest.continuation);
  }

  void push(Parser parser, Context context, GllContinuation continuation) {
    GllTableEntry tableEntry = table //
        .putIfAbsent(parser, HashMap<int, HashMap<num, GllTableEntry>>.new)
        .putIfAbsent(context.state.index, HashMap<num, GllTableEntry>.new)
        .putIfAbsent(context.state.precedence, GllTableEntry.new);

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

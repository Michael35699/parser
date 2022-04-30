import "dart:collection";

import "package:parser/internal_all.dart";

Iterable<Parser> _traverseDepthFirst(Parser root) sync* {
  Set<Parser> traversed = Set<Parser>.identity();
  Queue<Parser> parsers = Queue<Parser>()..add(root);

  while (parsers.isNotEmpty) {
    Parser current = parsers.removeLast();
    if (traversed.add(current)) {
      yield current;

      parsers.addAll(current.children.reversed);
    }
  }
}

Iterable<Parser> _traverseBreadthFirst(Parser root) sync* {
  Set<Parser> traversed = Set<Parser>.identity()..add(root);
  Queue<Parser> parsers = Queue<Parser>()..add(root);

  while (parsers.isNotEmpty) {
    Parser current = parsers.removeFirst();

    yield current;

    for (Parser child in current.children) {
      if (traversed.add(child)) {
        parsers.add(child);
      }
    }
  }
}

extension ParserTraverseExtension on Parser {
  Iterable<Parser> get traverseBf => traverseBreadthFirst();
  Iterable<Parser> get traverseDf => traverseDepthFirst();

  Iterable<Parser> traverseBreadthFirst() => _traverseBreadthFirst(this);
  Iterable<Parser> traverseDepthFirst() => _traverseDepthFirst(this);
}

extension LazyParserTraverseExtension on Lazy<Parser> {
  Iterable<Parser> get traverseBf => traverseBreadthFirst();
  Iterable<Parser> get traverseDf => traverseDepthFirst();

  Iterable<Parser> traverseBreadthFirst() => _traverseBreadthFirst(this.$);
  Iterable<Parser> traverseDepthFirst() => _traverseDepthFirst(this.$);
}

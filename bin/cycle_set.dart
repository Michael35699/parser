part of "main.dart";

Map<Parser, List<Parser>> computeCycleSets(Iterable<Parser> parsers, Map<Parser, Set<Parser>> firstSets) {
  Map<Parser, List<Parser>> cycleSets = <Parser, List<Parser>>{};
  for (Parser parser in parsers) {
    computeCycleSet(parser: parser, firstSets: firstSets, cycleSets: cycleSets);
  }
  return cycleSets;
}

void computeCycleSet({
  required Parser parser,
  required Map<Parser, Set<Parser>> firstSets,
  required Map<Parser, List<Parser>> cycleSets,
  List<Parser>? stack,
}) {
  if (cycleSets.containsKey(parser)) {
    return;
  }
  if (isTerminal(parser)) {
    cycleSets[parser] = const <Parser>[];
    return;
  }
  stack ??= <Parser>[parser];

  List<Parser> children = computeCycleChildren(parser, firstSets);
  for (Parser child in children) {
    int index = stack.indexOf(child);

    if (index >= 0) {
      List<Parser> cycle = stack.sublist(index);
      for (Parser parser in cycle) {
        cycleSets[parser] = cycle;
      }
      return;
    } else {
      stack.add(child);
      computeCycleSet(parser: child, firstSets: firstSets, cycleSets: cycleSets, stack: stack);
      stack.removeLast();
    }
  }
  if (!cycleSets.containsKey(parser)) {
    cycleSets[parser] = const <Parser>[];
    return;
  }
}

List<Parser> computeCycleChildren(Parser parser, Map<Parser, Set<Parser>> firstSets) {
  if (parser is SequentialParser) {
    List<Parser> children = <Parser>[];
    for (Parser child in parser.children) {
      children.add(child);
      if (!firstSets[child]!.any(isNullable)) {
        break;
      }
    }
    return children;
  }
  return parser.children.toList();
}

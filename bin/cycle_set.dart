part of "main.dart";

ParserSetMapping computeCycleSets(Iterable<Parser> parsers, ParserSetMapping firstSets) {
  ParserSetMapping cycleSets = ParserSetMapping();
  for (Parser parser in parsers) {
    computeCycleSet(parser, firstSets, cycleSets, <Parser>[parser]);
  }
  return cycleSets;
}

void computeCycleSet(Parser parser, ParserSetMapping firstSets, ParserSetMapping cycleSets, List<Parser> stack) {
  if (cycleSets.containsKey(parser)) {
    return;
  }
  if (isTerminal(parser)) {
    cycleSets[parser] = ParserSet();
    return;
  }

  List<Parser> children = computeCycleChildren(parser, firstSets);
  for (Parser child in children) {
    int index = stack.indexOf(child);

    if (index >= 0) {
      List<Parser> cycle = stack.sublist(index);
      for (Parser parser in cycle) {
        cycleSets[parser] = ParserSet.from(cycle);
      }
      return;
    } else {
      stack.add(child);
      computeCycleSet(child, firstSets, cycleSets, stack);
      stack.removeLast();
    }
  }
  if (!cycleSets.containsKey(parser)) {
    cycleSets[parser] = ParserSet();
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

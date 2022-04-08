part of "main.dart";

Map<Parser, Set<Parser>> computeFollowSets(
  Parser root,
  Iterable<Parser> parsers,
  Map<Parser, Set<Parser>> firstSets,
  Parser sentinel,
) {
  Map<Parser, Set<Parser>> followSets = <Parser, Set<Parser>>{
    for (final Parser parser in parsers)
      parser: <Parser>{
        if (parser == root) sentinel,
      }
  };
  bool changed = false;
  do {
    changed = false;
    for (Parser parser in parsers) {
      changed |= expandFollowSet(parser, followSets, firstSets);
    }
  } while (changed);
  return followSets;
}

bool expandFollowSet(Parser parser, Map<Parser, Set<Parser>> followSets, Map<Parser, Set<Parser>> firstSets) {
  if (parser is SequentialParser) {
    return expandFollowSetOfSequence(
      parser: parser,
      children: parser.children,
      followSets: followSets,
      firstSets: firstSets,
    );
  } else if (parser is CyclicParser) {
    return expandFollowSetOfSequence(
      parser: parser,
      children: <Parser>[
        parser.children.first,
        ...parser.children,
      ],
      followSets: followSets,
      firstSets: firstSets,
    );
  } else {
    bool changed = false;
    for (Parser child in parser.children) {
      for (Parser follow in followSets[parser]!) {
        changed |= followSets[child]!.add(follow);
      }
    }
    return changed;
  }
}

bool expandFollowSetOfSequence({
  required Parser parser,
  required List<Parser> children,
  required Map<Parser, Set<Parser>> followSets,
  required Map<Parser, Set<Parser>> firstSets,
}) {
  bool changed = false;
  for (int i = 0; i < children.length - 1; i++) {
    Set<Parser> firstSet = <Parser>{};
    int j = i + 1;
    for (; j < children.length; j++) {
      firstSet.addAll(firstSets[children[j]]!);
      if (!firstSets[children[j]]!.any(isNullable)) {
        break;
      }
    }
    if (j == children.length) {
      for (Parser follow in followSets[parser]!) {
        changed |= followSets[children[i]]!.add(follow);
      }
    }
    for (Parser first in firstSet.where((Parser first) => !isNullable(first))) {
      changed |= followSets[children[i]]!.add(first);
    }
  }

  for (Parser follow in followSets[parser]!) {
    changed |= followSets[children.last]!.add(follow);
  }
  return changed;
}

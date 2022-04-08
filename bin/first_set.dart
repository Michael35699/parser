part of "main.dart";

Map<Parser, Set<Parser>> computeFirstSets(Iterable<Parser> parsers, Parser sentinel) {
  Map<Parser, Set<Parser>> firstSets = <Parser, Set<Parser>>{
    for (Parser parser in parsers)
      parser: <Parser>{
        if (isTerminal(parser)) parser,
        if (isNullable(parser)) sentinel,
      }
  };

  bool changed = false;
  do {
    changed = false;

    for (Parser parser in parsers) {
      changed |= expandFirstSets(parser, firstSets, sentinel);
    }
  } while (changed);

  return firstSets;
}

bool expandFirstSets(Parser parser, Map<Parser, Set<Parser>> firstSets, Parser sentinel) {
  const bool false_ = false;
  bool changed = false;
  Set<Parser> firstSet = firstSets[parser]!;

  outer:
  do {
    if (parser is SequentialParser) {
      for (Parser child in parser.children) {
        bool nullable = false;
        for (Parser first in firstSets[child]!) {
          if (isNullable(first)) {
            nullable = true;
          } else {
            changed |= firstSet.add(first);
          }
        }
        if (!nullable) {
          break outer;
        }
      }
      changed |= firstSet.add(sentinel);
    } else if (parser is ChoiceParser) {
      for (Parser child in parser.children) {
        for (Parser first in firstSets[child]!) {
          changed |= firstSet.add(first);
        }
      }
    }
  } while (false_);

  return changed;
}

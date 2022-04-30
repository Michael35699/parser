import "package:parser/internal_all.dart";

ParserSetMapping _computeFirstSets(Iterable<Parser> parsers) {
  ParserSetMapping firstSets = <Parser, ParserSet>{
    for (Parser parser in parsers)
      parser: <Parser>{
        if (Parser.isTerminal(parser)) parser,
        if (Parser.isNullable(parser)) Parser.startSentinel,
      }
  };

  bool changed = false;
  do {
    changed = false;

    for (Parser parser in parsers) {
      changed |= _expandFirstSets(parser, firstSets);
    }
  } while (changed);

  return firstSets;
}

bool _expandFirstSets(Parser parser, ParserSetMapping firstSets) {
  bool changed = false;
  ParserSet firstSet = firstSets[parser]!;

  conditional:
  if (parser is SequentialParser) {
    for (Parser child in parser.children) {
      bool nullable = false;
      for (Parser first in firstSets[child]!) {
        if (Parser.isNullable(first)) {
          nullable |= true;
        } else {
          changed |= firstSet.add(first);
        }
      }
      if (!nullable) {
        break conditional;
      }
    }
    changed |= firstSet.add(Parser.startSentinel);
  } else {
    for (Parser first in parser.children.flatMap((Parser child) => firstSets[child]!)) {
      changed |= firstSet.add(first);
    }
  }

  return changed;
}

ParserSetMapping _computeFollowSets(Parser root, Iterable<Parser> parsers, ParserSetMapping firsts) {
  ParserSetMapping followSets = <Parser, ParserSet>{
    for (final Parser parser in parsers)
      parser: <Parser>{
        if (parser == root) Parser.endSentinel,
      }
  };
  bool changed = false;
  do {
    changed = false;
    for (Parser parser in parsers) {
      changed |= _expandFollowSet(parser, followSets, firsts);
    }
  } while (changed);
  return followSets;
}

bool _expandFollowSet(Parser parser, ParserSetMapping follows, ParserSetMapping firsts) {
  if (parser is SequentialParser) {
    return _expandFollowSetOfSequence(parser, parser.children, follows, firsts);
  } else if (parser is CyclicParser) {
    List<Parser> children = <Parser>[parser.parser, ...parser.children];

    return _expandFollowSetOfSequence(parser, children, follows, firsts);
  } else {
    bool changed = false;
    for (Parser child in parser.children) {
      for (Parser follow in follows[parser]!) {
        changed |= follows[child]!.add(follow);
      }
    }
    return changed;
  }
}

bool _expandFollowSetOfSequence(
  Parser parser,
  List<Parser> children,
  ParserSetMapping follows,
  ParserSetMapping firsts,
) {
  bool changed = false;
  for (int i = 0; i < children.length - 1; i++) {
    ParserSet firstSet = <Parser>{};
    int j = i + 1;
    for (; j < children.length; j++) {
      firstSet.addAll(firsts[children[j]]!);
      if (!firsts[children[j]]!.any(Parser.isNullable)) {
        break;
      }
    }
    if (j == children.length) {
      for (Parser follow in follows[parser]!) {
        changed |= follows[children[i]]!.add(follow);
      }
    }
    for (Parser first in firstSet.where(~Parser.isNullable)) {
      changed |= follows[children[i]]!.add(first);
    }
  }

  for (Parser follow in follows[parser]!) {
    changed |= follows[children.last]!.add(follow);
  }
  return changed;
}

ParserSetMapping _computeCycleSets(Iterable<Parser> parsers, ParserSetMapping firsts) {
  ParserSetMapping cycleSets = <Parser, ParserSet>{};
  for (Parser parser in parsers) {
    _computeCycleSet(parser, firsts, cycleSets, <Parser>[parser]);
  }
  return cycleSets;
}

void _computeCycleSet(Parser parser, ParserSetMapping firsts, ParserSetMapping cycles, List<Parser> stack) {
  if (cycles.containsKey(parser)) {
    return;
  }
  if (parser.isTerminal()) {
    cycles[parser] = const <Parser>{};
    return;
  }

  List<Parser> children = _computeCycleChildren(parser, firsts);
  for (Parser child in children) {
    int index = stack.indexOf(child);

    if (index >= 0) {
      List<Parser> cycle = stack.sublist(index);
      for (Parser parser in cycle) {
        cycles[parser] = cycle.toSet();
      }
      return;
    } else {
      stack.add(child);
      _computeCycleSet(child, firsts, cycles, stack);
      stack.removeLast();
    }
  }
  if (!cycles.containsKey(parser)) {
    cycles[parser] = const <Parser>{};
    return;
  }
}

List<Parser> _computeCycleChildren(Parser parser, ParserSetMapping firstSets) {
  if (parser is SequentialParser) {
    List<Parser> children = <Parser>[];
    for (Parser child in parser.children) {
      children.add(child);
      if (!firstSets[child]!.any(Parser.isNullable)) {
        break;
      }
    }
    return children;
  }
  return parser.children.toList();
}

List<ParserSetMapping> _computeParserSets(Parser root, [Iterable<Parser>? parsers]) {
  parsers ??= root.traverseBf;

  ParserSetMapping firstSets = _computeFirstSets(parsers);
  ParserSetMapping followSets = _computeFollowSets(root, parsers, firstSets);
  ParserSetMapping cycleSets = _computeCycleSets(parsers, firstSets);

  return <ParserSetMapping>[firstSets, followSets, cycleSets];
}

extension ParserComputeExtension on Parser {
  List<ParserSetMapping> computeParserSets() => _computeParserSets(this);
}

extension LazyParserComputeExtension on Lazy<Parser> {
  List<ParserSetMapping> computeParserSets() => _computeParserSets(this.$);
}

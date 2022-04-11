part of "main.dart";

class Analyzer {
  final Parser root;

  late final Iterable<Parser> allParsers = root.traverseBf;
  late final List<ParserSetMapping> parserSets = root.computeParserSets();
  late final ParserSetMapping firstSets = parserSets[Parser.firstSetIndex];
  late final ParserSetMapping followSets = parserSets[Parser.followSetIndex];
  late final ParserSetMapping cycleSets = parserSets[Parser.cycleSetIndex];

  Analyzer(this.root);

  void checkEmptyFirst(Parser parser) {
    if (!parser.isNullable() && firstSets[parser]!.isEmpty) {
      log.cerror("Parser of type '${parser.runtimeType}' has an empty first set.");
      log.cerror(parser.generateAsciiTree(marks: <Parser, String>{
        parser: "No starting terminal, therefore this parser cannot parse anything.",
      }));
    }
  }

  void checkUnoptimizedCommonPrefix(Parser parser) {
    if (this is ChoiceParser) {
      List<ParserSet> children = parser.children.map((Parser p) => p.firstSet).toList();

      for (int i = 0; i < children.length; i++) {
        for (int j = i + 1; j < children.length; j++) {
          late ParserSet intersection = children[i] & children[j];
          if (intersection.isNotEmpty && intersection.any(~Parser.isMemoizable)) {
            log.warn("Parser choice $i has common a non-memoized prefix with parser choice $j. ");
          }
        }
      }
    }
  }

  void checkEqualChoices(Parser parser) {
    if (this is ChoiceParser) {
      for (int i = 0; i < parser.children.length; i++) {
        for (int j = i + 1; j < parser.children.length; j++) {
          if (parser.children[i].equals(parser.children[j])) {
            log.warn("Parser choice $i is equal with $j.");
          }
        }
      }
    }
  }

  void checkUnreachableChoice(Parser parser) {
    if (this is ChoiceParser) {
      for (int i = 0; i < parser.children.length - 1; i++) {
        if (Parser.isNullable(parser.children[i])) {
          log.print("Choices after the $i-th choice is not reachable.");
          log.print(parser.generateAsciiTree(
            marks: <Parser, String>{
              parser: "This parser has unreachable choices",
              parser.children[i]: "Anything after this parser is always ignored.",
            },
          ));
        }
      }
    }
  }

  void checkNullableCyclic(Parser parser) {
    if (parser is CyclicParser && Parser.isNullable(parser.parser)) {
      log.cerror(//
          "The cyclic parser '${parser.runtimeType}' has a nullable child. "
          "This means that the parser can pretty much hang the program "
          "as it can indefinitely run.");

      log.cerror(parser.generateAsciiTree(
        marks: <Parser, String>{
          parser: "This parser will hang the program.",
          parser.parser: "This parser is nullable.",
        },
      ));
    }
  }

  void deepCheck() {
    allParsers.forEach(check);
  }

  void check(Parser parser) {
    checkUnoptimizedCommonPrefix(parser);
    checkEmptyFirst(parser);
    checkEqualChoices(parser);
    checkUnreachableChoice(parser);
    checkNullableCyclic(parser);
  }
}

ChoiceParser transformChoice(Parser parser) {
  if (parser is SequentialParser) {
    return transformChoice(ChoiceParser(<Parser>[parser]));
  }

  Parser clone = parser.clone();
  List<Parser> children = <Parser>[...clone.children];
  List<List<Parser>> childrenMatrix = <List<Parser>>[];
  List<List<bool>> indices = <List<bool>>[];

  for (SequenceParser child in children.cast()) {
    childrenMatrix.add(child.children.toList());
    indices.add(child.children.map((Parser p) => p is OptionalParser).toList());
  }

  List<List<Parser>> resolvedChildren = <List<Parser>>[];
  for (int i = 0; i < children.length; i++) {
    List<Parser> parsers = childrenMatrix[i];
    List<bool> index = indices[i];

    for (List<Parser> permutation in generatePermutations(parsers, index, 0)) {
      resolvedChildren.add(permutation);
    }
  }

  ChoiceParser resolved = resolvedChildren
      .map((List<Parser> p) => p.length == 1
          ? p[0]
          : SequenceParser(<Parser>[
              for (Parser parser in p)
                if (parser is SequenceParser) ...parser.children else parser
            ]))
      .choiceParser()
    ..memoize = clone.memoize;
  resolved.transformReplace(clone, resolved);

  return resolved;
}

Iterable<List<Parser>> generatePermutations(List<Parser> parsers, List<bool> index, int i) sync* {
  if (i >= parsers.length) {
    yield <Parser>[];
  } else {
    for (List<Parser> sublist in generatePermutations(parsers, index, i + 1)) {
      if (index[i]) {
        OptionalParser optional = parsers[i] as OptionalParser;

        yield <Parser>[optional.parser, ...sublist];
        yield <Parser>[...sublist];
      } else {
        yield <Parser>[parsers[i], ...sublist];
      }
    }
  }
}

T unwrapToType<T extends Parser>(Parser parser) {
  Parser current = parser;
  while (current is! T && current.unwrapped != current) {
    current = current.unwrapped;
  }
  if (current is! T) {
    log.error("Parser of type '${parser.runtimeType}' does not have a $T child in its tree!");
  }

  return current;
}

Parser changePrecedence(Parser root, num newPrecedence) {
  Parser cloned = Parser.clone(root);
  WithPrecedenceParser deepUnwrapped = unwrapToType(cloned);

  cloned.transformReplace(deepUnwrapped, deepUnwrapped.parser.withPrecedence(newPrecedence));

  return cloned;
}

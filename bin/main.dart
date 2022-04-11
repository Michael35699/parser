import "package:parser_peg/internal_all.dart";

extension ParserExtension on Parser {
  void checkEmptyFirst() {
    if (!isNullable() && firstSet.isEmpty) {
      log.warn("Parser of type '$runtimeType' has an empty first set.");
      log.documentor(generateAsciiTree(marks: <Parser, String>{
        this: "No starting terminal, therefore this parser cannot parse anything.",
      }));
    }
  }

  void checkUnoptimizedCommonPrefix() {
    if (this is ChoiceParser) {
      List<ParserSet> children = this.children.map((Parser p) => p.firstSet).toList();

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

  void checkEqualChoices() {
    if (this is ChoiceParser) {
      for (int i = 0; i < children.length; i++) {
        for (int j = i + 1; j < children.length; j++) {
          if (children[i].equals(children[j])) {
            log.warn("Parser choice $i is equal with $j.");
          }
        }
      }
    }
  }

  void checkUnreachableChoice() {
    if (this is ChoiceParser) {
      for (int i = 0; i < children.length - 1; i++) {
        if (Parser.isNullable(children[i])) {
          log.warn("Choices after the $i-th choice is not reachable.");
          log.warn(generateAsciiTree(
            marks: <Parser, String>{
              children[i]: "Anything after this parser is always ignored.",
            },
          ));
        }
      }
    }
  }

  Parser check() {
    clone().build()
      ..checkUnoptimizedCommonPrefix()
      ..checkEmptyFirst()
      ..checkEqualChoices()
      ..checkUnreachableChoice();

    return this;
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

Parser addition() =>
    addition & "+".t & number | //
    number;

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

// A := B "a" | "a"
// B := A "b" | "b"
Parser A() => B & "a" | "a";
Parser B() => A & "b" | "b";

void main() {
  time(() {
    print << A.run("aba").toAsciiString();
  });
}

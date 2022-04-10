import "package:parser_peg/internal_all.dart";
import "package:parser_peg/src/util/classes/default_map.dart";

extension ParserExtension on Parser {
  void checkEmptyFirst() {
    if (!isNullable() && firstSet.isEmpty) {
      log.warn("Parser of type '$runtimeType' has an empty first set.");
      log.documentor(generateAsciiTree(marks: <Parser, String>{
        this: "No starting terminal, therefore the parser cannot parse anything.",
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

Parser left() => left & "a" | "a";

void main() {
  DefaultMap<String, DefaultMap<String, int>> map =
      DefaultMap<String, DefaultMap<String, int>>(() => DefaultMap<String, int>(() => -1));

  // Parser parser = Parser.clone(left.thunk()) //
  //     .transformType((StringParser parser) => "b".$);

  // print(parser.generateAsciiTree());
}

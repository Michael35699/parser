import "package:parser_peg/internal_all.dart";

part "cycle_set.dart";
part "first_set.dart";
part "follow_set.dart";

bool isTerminal(Parser parser) => parser.children.toList().isEmpty;
bool isNullable(Parser parser) {
  Parser built = parser.build();

  if (built is OptionalParser ||
      built is EpsilonParser ||
      built is ChoiceParser &&
          built.children.any((Parser p) => p.base is SuccessParser || p.base is EpsilonParser || p.base == "".p()) ||
      built == "".p()) {
    return true;
  }
  return false;
}

final EpsilonParser epsilon = EpsilonParser();

void main() {
  Parser built = infixMath.build();
  Iterable<Parser> reached = built.traverseBreadthFirst();
  // Map<Parser, Set<Parser>> firstSets = computeFirstSets(reached, epsilon);
  // Map<Parser, Set<Parser>> followSets = computeFollowSets(built, reached, firstSets, dollar);
  // Map<Parser, List<Parser>> cycleSets = computeCycleSets(reached, firstSets);

  // print(firstSets);

  // print(cycleSets);
}

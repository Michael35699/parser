import "dart:io";

import "package:parser_peg/internal_all.dart";

String get input => File("assets/text.grammar").readAsStringSync();

Parser refactorChoice(ChoiceParser parser) {
  Map<num, ChoiceParser> groups = <num, ChoiceParser>{};
  List<WithPrecedenceParser> children = parser.children.cast();
  children
    ..sort((WithPrecedenceParser a, WithPrecedenceParser b) => b.precedence.compareTo(a.precedence))
    ..forEach((WithPrecedenceParser p) => groups[p.precedence] = ChoiceParser(<Parser>[])..memoize = true);

  num previous = children.first.precedence;
  for (int i = 0; i < children.length; i++) {
    Parser p = children[i];

    if (p is WithPrecedenceParser) {
      num current = p.precedence;

      groups[current]!.children.add(p.base);
      if (current < previous) {
        groups[previous]!.children.add(groups[current]!);
      }
      previous = current;
    }
  }

  ChoiceParser finalParser = groups.values.first.transformWhere(
    (Parser p) => p is FromPrecedenceParser && p.base == parser,
    (FromPrecedenceParser p) => groups[p.precedence] ?? log.error("Undefined parser with precedence ${p.precedence}"),
  ) as ChoiceParser;

  return finalParser;
}

Parser infix() => _addition.$;

Parser _addition() => _addition & "+".t & _multiplication | _multiplication;
Parser _multiplication() => _multiplication & "*".t & _negative | _negative;
Parser _negative() => "-".tr & _negative ^ $2((_, num r) => -r) | _atomic;
Parser _atomic() => "[0-9]+".r ^ $type(int.parse);

extension on File {
  void operator <<(String other) => writeAsString(other);
}

void main() {
  File("assets/out_main.txt") << infix.generateAsciiTree();
  File("assets/out_clone.txt") << infix.clone().generateAsciiTree();
  // print << infixMath.run("1 * 2 + 3 * 4");
}

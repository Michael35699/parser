import "dart:io";

import "package:parser_peg/internal_all.dart";

String get input => File("assets/text.grammar").readAsStringSync();

// Parser refactorChoice(ChoiceParser parser) {
//   Map<num, ChoiceParser> groups = <num, ChoiceParser>{};
//   List<WithPrecedenceParser> children = parser.children.cast();
//   children
//     ..sort((WithPrecedenceParser a, WithPrecedenceParser b) => b.precedence.compareTo(a.precedence))
//     ..forEach((WithPrecedenceParser p) => groups[p.precedence] = ChoiceParser(<Parser>[])..memoize = true);

//   num previous = children.first.precedence;
//   for (int i = 0; i < children.length; i++) {
//     Parser p = children[i];

//     if (p is WithPrecedenceParser) {
//       num current = p.precedence;

//       groups[current]!.children.add(p.base);
//       if (current < previous) {
//         groups[previous]!.children.add(groups[current]!);
//       }
//       previous = current;
//     }
//   }

//   ChoiceParser finalParser = groups.values.first
//     ..replaceRecursive(
//       (Parser p) => p is FromPrecedenceParser && p.base == parser,
//       (FromPrecedenceParser p) => groups[p.precedence] ?? log.error("Undefined parser with precedence ${p.precedence}"),
//     );

//   return finalParser;
// }

ChoiceParser p_2() => p_2 & "a" | "a";

void main() {
  Parser p = p_2.$;
  Parser p3 = p
      .transformWhere((Parser p) => p is ThunkParser, (ThunkParser p) => p.computed..memoize = true)
      .transformWhere((Parser p) => p is StringParser, (StringParser c) => "b".p());
  print << p3.generateAsciiTree();

  print << Parser.run(p3, "bbb");
}

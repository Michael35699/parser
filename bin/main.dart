import "package:parser_peg/internal_all.dart";

part "utils.dart";

Parser addition() =>
    addition & "+".t & number | //
    number;

Parser lr() => lr & "l" | "l";
Parser rr() => "l" & rr | "l";

void main() {
  Parser parser = OptimizedJsonGrammar().start.simplified.build();
  Analyzer analyzer = Analyzer(parser);
  analyzer.deepCheck();

  for (MapEntry<Parser, Set<Parser>> entry in analyzer.firstSets.entries) {
    print(entry);
  }
}

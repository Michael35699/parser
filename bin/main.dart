import "package:parser_peg/internal_all.dart";

part "utils.dart";

Parser addition() =>
    addition & "+".t & number | //
    number;

Parser lr() => lr & "l";
Parser rr() => "l" & rr | "l";

void main() {
  Parser built = OptimizedJsonGrammar().start.build();
  Analyzer analyzer = Analyzer(built);
  analyzer.deepCheck();
  print(analyzer.firstSets);
  print << built.run(""" {"one": "one", "two": ["three", 4, -1.5123e45]} """);
}

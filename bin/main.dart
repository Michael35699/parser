import "dart:io";

import "package:parser_peg/internal_all.dart";

String get input => File("assets/text.grammar").readAsStringSync();

void main() {
  const String input = "one <h2 style='sexy:true'> two </h2>";
  Parser parser = XmlEvaluator().start.build();

  time(() {
    print << parser.unmapped.run(input);
    print << input.stripXml;
  });
}

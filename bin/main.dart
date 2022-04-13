import "package:parser_peg/example/parser/json/json.dart" as json;
import "package:parser_peg/internal_all.dart";

part "utils.dart";

void main() {
  Parser built = json.parser.build();

  print << built.run("""{"one": 1, "two": [2, 3], "four": [5, 6, 7]}""");
}

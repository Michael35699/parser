import "package:parser/example/parser/json/json.dart" as json;
import "package:parser/internal_all.dart";

part "utils.dart";

void main() {
  Parser built = json.jsonParser.build().flat();
  Analyzer(built).deepCheck();
  print << built.run("""{"one": 1, "two": [2, 3], "four": [5, 6, 7]}""");
}

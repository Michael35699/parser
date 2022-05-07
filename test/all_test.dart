import "package:test/test.dart";

import "context.dart" as context_test;
import "example.dart" as example_test;
import "parser.dart" as parser_test;
import "state.dart" as state_test;

void main() {
  group("context_test", context_test.main);
  group("state_test", state_test.main);
  group("parser_test", parser_test.main);
  group("example_test", example_test.main);
}

import "package:parser/parser.dart" as parser;
import "package:test/test.dart";

parser.Parser basic() => "s".plus();

void main() {
  test("Potentially slow test", () {
    expect(basic.run("ssssss"), <String>["s", "s", "s", "s", "s"]);
  });
}

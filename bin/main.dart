import "package:parser_peg/internal_all.dart";

part "utils.dart";

Parser addition() =>
    addition & "+".t & number | //
    number;

Parser lr() => lr & "l" | "l";
Parser rr() => "l" & rr | "l";

void main() {
  rr.run("l" * 2700);
}

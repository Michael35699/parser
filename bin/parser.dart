import "package:parser/parser.dart" as local;

int counter = 0;

typedef Parser = local.Parser;

local.Parser code() =>
    "{" & code.star() & "}" | //
    ~"}" >> local.source();

void main() {
  const String input =
      "{ constantly running dart code here: {block} {these can be used in actual code blocks. Amazing right?} }";

  code.peg.pure(input);
  // print(time(count: 50, () => code.peg.left(input)));
  // print(time(count: 50, () => code.packrat.basic(input)));
  // print(time(count: 50, () => code.packrat.linear(input)));
  // print(time(count: 50, () => code.packrat.quadratic(input)));
}

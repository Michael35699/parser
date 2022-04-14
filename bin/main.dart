import "dart:math";

import "package:parser/internal_all.dart";

part "utils.dart";

Parser math() => addition.$;
Parser addition() =>
    addition & "+".t & multiplication ^ $3((num l, _, num r) => l + r) | //
    addition & "-".t & multiplication ^ $3((num l, _, num r) => l - r) |
    multiplication;
Parser multiplication() =>
    multiplication & "*".t & negative ^ $3((num l, _, num r) => l * r) | //
    multiplication & "/".t & negative ^ $3((num l, _, num r) => l / r) |
    negative;
Parser negative() =>
    "-".t & negative ^ $2((_, num v) => -v) | //
    power;
Parser power() =>
    atom & "^".t & power ^ $3((num l, _, num r) => pow(l, r)) | //
    atom;
Parser atom() =>
    digit.plus() ^ $join() >>> int.parse | //
    "(".t & addition & ")".t ^ $at(1);

const String indentCode = "#INDENT";
const String dedentCode = "#DEDENT";
const String newlineCode = "#NEWLINE#";

String preProcessString(String input) {
  List<int> indentStack = <int>[0];
  List<String> lines = input.split("\n");
  StringBuffer buffer = StringBuffer()..write(lines.first);

  for (String line in lines.skip(1)) {
    if (line.trim().isEmpty) {
      buffer.write(newlineCode);
      continue;
    }

    int indentation = line.split("").takeWhile((String char) => char == " " || char == "\t").length;
    String cut = line.substring(indentation);
    if (indentation > indentStack.last) {
      indentStack.add(indentation);
      buffer.write(indentCode);
    } else if (indentation < indentStack.last) {
      while (indentStack.length > 1 && indentation < indentStack[indentStack.length - 1]) {
        indentStack.removeLast();
        buffer.write(dedentCode);
      }
      buffer.write(newlineCode);
    } else {
      buffer.write(newlineCode);
    }
    buffer.write(cut);
  }
  while (indentStack.length > 1) {
    indentStack.removeLast();
    buffer.write(dedentCode);
  }
  print(buffer);

  return buffer.toString();
}

Parser indent() => indentCode.p().drop();
Parser dedent() => dedentCode.p().drop();
Parser newline() => newlineCode.cycle().drop();

Parser parser() => "block:" & indent & body % newline & dedent & (newline >> "end").optional();
Parser body() => parser | (newline.not() >> dedent.not() >> source).cycle().$join();

void main() {
  const String input = "1 + 2 * 3";
  Parser mapped = math.build();
  Parser unmapped = math.unmapped.build();

  print << mapped.generateAsciiTree();
}

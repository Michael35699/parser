// import "package:parser/src/util/shared/time.dart";
import "dart:io";

import "package:parser/parser.dart" as parser;
import "package:parser/src/util/shared/time.dart";

int counter = 0;

typedef Parser = parser.Parser;

Parser gamma3() =>
    gamma3 & gamma3 & gamma3 | //
    gamma3 & gamma3 |
    "s";

void main() {
  StringBuffer buffer = StringBuffer();
  print(time(() => (gamma3.end.gll("ssssssssss").toList()..forEach(buffer.writeln)).last));
  File("assets/out.txt")
    ..createSync(recursive: true)
    ..writeAsStringSync(buffer.toString());
  print(gamma3.thunk().generateAsciiTree());
}

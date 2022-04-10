import "dart:collection";

import "package:parser_peg/internal_all.dart";

class StringParser extends LeafParser {
  static HashMap<String, StringParser> map = HashMap<String, StringParser>();

  final String pattern;

  factory StringParser(String pattern) => map[pattern] ??= StringParser.generate(pattern);
  StringParser.generate(this.pattern);

  @override
  String get failureMessage => expected.value("'$pattern'");

  @override
  int? parseLeaf(String input, int index) => pattern.matchAsPrefix(input, index)?.end;

  @override
  String toString() => "'$pattern'".replaceAll("\n", r"\n").replaceAll("\r", r"\r").replaceAll("\t", r"\t");
}

extension StringParserExtension on String {
  StringParser p() => StringParser(this);
  StringParser parser() => StringParser(this);
}

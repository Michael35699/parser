import "dart:collection";

import "package:parser_peg/internal_all.dart";

class StringParser extends LeafParserMixin {
  static HashMap<String, StringParser> map = HashMap<String, StringParser>();

  @override
  bool get memoize => true;

  final String pattern;

  factory StringParser(String pattern) => map[pattern] ??= StringParser.generate(pattern);
  StringParser.generate(this.pattern);

  @override
  String get failureMessage => expected.value("'$pattern'");

  @override
  int? parseLeaf(String input, int index) => pattern.matchAsPrefix(input, index)?.end;

  @override
  String toString() => "string['$pattern']";
}

extension StringParserExtension on String {
  StringParser p() => StringParser(this);
  StringParser parser() => StringParser(this);
}

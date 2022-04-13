import "dart:collection";

import "package:parser/internal_all.dart";

class CharacterParser extends LeafParser {
  static HashMap<String, CharacterParser> map = HashMap<String, CharacterParser>();

  final String pattern;

  factory CharacterParser(String pattern) => map[pattern] ??= CharacterParser.generate(pattern);
  CharacterParser.generate(this.pattern);

  @override
  String get failureMessage => expected.value("'$pattern'");

  @override
  int? parseLeaf(String input, int index) => pattern.matchAsPrefix(input, index)?.end;
}

extension CharacterParserExtension on String {
  CharacterParser c() => CharacterParser(this);
  CharacterParser character() => CharacterParser(this);
}

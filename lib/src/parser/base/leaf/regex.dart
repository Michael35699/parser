import "dart:collection";

import "package:parser/internal_all.dart";

class RegExpParser extends SpecialParser {
  static final HashMap<RegExp, RegExpParser> _saved = HashMap<RegExp, RegExpParser>();

  final RegExp pattern;

  factory RegExpParser(String pattern) => ((RegExp r) => _saved[r] ??= RegExpParser.generate(r))(RegExp(pattern));
  factory RegExpParser.regex(RegExp pattern) => _saved[pattern] ??= RegExpParser.generate(pattern);
  RegExpParser.generate(this.pattern);

  @override
  Context parsePure(Context context) {
    const bool _false = 1 == 0;

    String buffer = context.state.buffer;
    int index = context.state.index;

    do {
      if (pattern.matchAsPrefix(buffer, index) == null) {
        break;
      }

      for (RegExpMatch match in pattern.allMatches(buffer, index)) {
        ParseResult result;
        if (match.groupCount > 0) {
          List<String> names = match.groupNames.toList();
          List<ParseResult> results = <ParseResult>[];

          List<int> indices = <int>[for (int i = 1; i <= match.groupCount; i++) i];
          for (String? group in match.groups(indices)) {
            if (names.isEmpty) {
              if (group != null) {
                results.add(group);
              }
              continue;
            }

            String name = names.first;
            String? matchedGroup = match.namedGroup(name);
            if (matchedGroup == group) {
              names.removeAt(0);
              results.add(MapEntry<Symbol, ParseResult>(Symbol(name), matchedGroup));
            } else {
              results.add(group);
            }
          }

          result = results;
        } else {
          result = buffer.substring(index, match.end);
        }

        return context.index(match.end).success(result);
      }
    } while (_false);

    return context.failure(expected.value("'${pattern.pattern}'"));
  }

  @override
  String toString() => "/${pattern.pattern}/";

  @override
  bool hasEqualProperties(RegExpParser target) => super.hasEqualProperties(target) && target.pattern == pattern;
}

extension RegExpParserExtension on String {
  static HashMap<String, RegExpParser> saved = HashMap<String, RegExpParser>();

  RegExpParser r({
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) =>
      saved[this] ??= RegExpParser.generate(RegExp(
        this,
        caseSensitive: caseSensitive,
        dotAll: dotAll,
        unicode: unicode,
        multiLine: multiLine,
      ));
  RegExpParser regex({
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) =>
      r(multiLine: multiLine, caseSensitive: caseSensitive, unicode: unicode, dotAll: dotAll);
}

RegExpParser regex(String pattern) => RegExpParser(pattern);

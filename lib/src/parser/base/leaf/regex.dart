import "dart:collection";

import "package:parser_peg/internal_all.dart";

class RegExpParser extends ChildlessParser {
  static HashMap<RegExp, RegExpParser> _saved = HashMap<RegExp, RegExpParser>();

  final RegExp pattern;

  factory RegExpParser(String pattern) => ((RegExp r) => _saved[r] ??= RegExpParser.generate(r))(RegExp(pattern));
  factory RegExpParser.regex(RegExp pattern) => _saved[pattern] ??= RegExpParser.generate(pattern);
  RegExpParser.generate(this.pattern);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    const bool _false = 1 == 0;

    String input = context.state.input;
    int index = context.state.index;

    do {
      if (pattern.matchAsPrefix(input, index) == null) {
        break;
      }

      for (RegExpMatch match in pattern.allMatches(input, index)) {
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
          result = input.substring(index, match.end);
        }

        return context.absolute(match.end).success(result);
      }
    } while (_false);

    return context.failure(expected.value("'${pattern.pattern}'"));
  }
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
}

RegExpParser regex(String pattern) => RegExpParser(pattern);

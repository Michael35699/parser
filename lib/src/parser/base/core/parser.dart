// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

abstract class Parser {
  static final Never never = throw Error();

  late final bool leftRecursive = Parser.isLeftRecursive(this);
  late final bool rightRecursive = Parser.isRightRecursive(this);
  late final bool definitelyLeftRecursive = Parser.isDefinitelyLeftRecursive(this);
  late final bool definitelyRightRecursive = Parser.isDefinitelyRightRecursive(this);
  late final List<ParserSetMapping> parserSets = computeParserSets();
  late final ParserSetMapping firstSets = parserSets[Parser.firstSetIndex];
  late final ParserSetMapping followSets = parserSets[Parser.followSetIndex];
  late final ParserSetMapping cycleSets = parserSets[Parser.cycleSetIndex];
  late final ParserSet firstSet = firstSets[this] ?? const <Parser>{};
  late final ParserSet followSet = followSets[this] ?? const <Parser>{};
  late final ParserSet cycleSet = cycleSets[this] ?? const <Parser>{};

  bool memoize = false;
  bool built = false;

  @Deprecated("Use the `clone` method")
  Parser cloneSelf(Expando<Parser> cloned);
  @Deprecated("Use the `transform` method")
  Parser transformChildren(TransformHandler handler, Expando<Parser> transformed);
  @Deprecated("Use the `pegApply` method")
  Context parsePeg(Context context, PegHandler handler);
  @Deprecated("Push the parser into the `Trampoline` instead of calling it directly")
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation);

  @mustCallSuper
  bool hasEqualProperties(covariant Parser target) {
    return true;
  }

  Parser get base;
  Parser get unwrapped;
  List<Parser> get children;

  /// Utility class helpers

  static const int firstSetIndex = 0;
  static const int followSetIndex = 1;
  static const int cycleSetIndex = 2;

  static final Parser startSentinel = epsilon();
  static final Parser endSentinel = dollar();

  static String generateAsciiTree(Parser parser, {Map<Parser, String>? marks}) {
    Parser built = parser.build();
    int counter = 0;
    Map<Parser, int> rules = <Parser, int>{for (Parser p in Parser.rules(built)) p: ++counter};
    StringBuffer buffer = StringBuffer("\n");

    for (Parser p in rules.keys.where(marks?.keys.contains ?? Predicate.tautology())) {
      buffer
        ..writeln("(rule#${rules[p]})")
        ..writeln(_generateAsciiTree(rules, p, "", isLast: true, level: 0, marks: marks));
    }

    return buffer.toString().trimRight();
  }

  static ParserPredicate equals(Parser parser) {
    return (Parser target) {
      if (parser == target) {
        return true;
      }

      Iterable<Parser> leftString = parser.traverseBf.whereNotType<ThunkParser>();
      Iterable<Parser> rightString = target.traverseBf.whereNotType<ThunkParser>();
      Iterable<List<Parser>> zipped = leftString.zipSingle(rightString);

      for (List<Parser> pair in zipped) {
        Parser left = pair[0];
        Parser right = pair[1];

        if (left.runtimeType != right.runtimeType || !left.hasEqualProperties(right)) {
          return false;
        }
      }

      return true;
    };
  }

  static bool isTerminal(Parser parser) {
    return parser.children.isEmpty;
  }

  static bool isNullable(Parser parser) {
    bool parserIsEpsilon(Parser p) => p is EpsilonParser || p == "".p();
    bool parserIsNullable(Parser p) =>
        p is NullableAnnotationParser || //
        p is SuccessParser ||
        p is OptionalParser ||
        parserIsEpsilon(p);

    late bool isNullable = parserIsNullable(parser);
    late bool isNullableChoice = parser is ChoiceParser && parser.children.any(parserIsNullable);
    late bool isNullableSequential = parser is SequentialParser && parser.children.every(parserIsNullable);
    late bool isThunkNullable = parser is ThunkParser && parserIsNullable(parser.computed);

    return isThunkNullable || isNullable || isNullableChoice || isNullableSequential;
  }

  static bool isRecursive(Parser root) {
    Queue<Parser> parsers = Queue<Parser>()..addAll(root.children);
    Set<Parser> visited = <Parser>{};

    while (parsers.isNotEmpty) {
      Parser current = parsers.removeLast();

      if (visited.add(current)) {
        parsers.addAll(current.children);
      } else {
        return true;
      }
    }

    return false;
  }

  static bool isRecursiveOf(Parser root, List<Parser> Function(Parser root) determinant) {
    Iterable<Parser> toAdd = determinant(root);
    Queue<Parser> parsers = Queue<Parser>()..addAll(toAdd);
    Set<Parser> visited = <Parser>{...toAdd};

    while (parsers.isNotEmpty) {
      Parser current = parsers.removeFirst();
      if (current == root) {
        return true;
      }

      determinant(current).where(visited.add).forEach(parsers.add);
    }

    return false;
  }

  static bool isLeftRecursive(Parser root) {
    return isRecursiveOf(root, Parser.firstChildren);
  }

  static bool isRightRecursive(Parser root) {
    return isRecursiveOf(root, Parser.lastChildren);
  }

  static bool isDefinitelyLeftRecursive(Parser root) {
    return isRecursiveOf(root, Parser.definiteFirstChildren);
  }

  static bool isDefinitelyRightRecursive(Parser root) {
    return isRecursiveOf(root, Parser.definiteLastChildren);
  }

  static bool isMemoizable(Parser parser) {
    return parser is ThunkParser || parser.memoize;
  }

  static bool isMemoized(Parser parser) {
    return parser.memoize;
  }

  static bool isType<T extends Parser>(Parser parser) {
    return parser is T;
  }

  static Iterable<Parser> rules(Parser root) sync* {
    yield root;
    yield* root
        .transformType((ThunkParser p) => p..computed.memoize = true) //
        .traverseBreadthFirst()
        .where((Parser parser) =>
            parser != root &&
            parser.memoize &&
            !parser.isTerminal() &&
            (parser is WrapParser ? !parser.parser.isTerminal() : parser is! WrapParser));
  }

  static List<Parser> firstChildren(Parser root) {
    if (root is! SequentialParser) {
      return root.children;
    }

    int i = 0;
    List<Parser> nullables = root.children.takeWhile(Parser.isNullable).toList();
    return <Parser>[
      for (; i < nullables.length; i++) root.children[i],
      if (i < root.children.length) root.children[i],
      // If the parser at the index after the index of the last nullable item exists, add it to the list.
    ];
  }

  static List<Parser> lastChildren(Parser root) {
    if (root is! SequentialParser) {
      return root.children;
    }

    int i = 0;
    List<Parser> reversed = root.children.reversed.toList();
    List<Parser> nullables = reversed.takeWhile(Parser.isNullable).toList();
    List<Parser> resolved = <Parser>[
      for (; i < nullables.length; i++) reversed[i],
      if (i < reversed.length) reversed[i],
    ];

    return resolved;
  }

  static List<Parser> definiteFirstChildren(Parser root) {
    if (root is! SequentialParser) {
      return root.children;
    }

    return <Parser>[root.children.first];
  }

  static List<Parser> definiteLastChildren(Parser root) {
    if (root is! SequentialParser) {
      return root.children;
    }

    return <Parser>[root.children.last];
  }

  static Parser resolve(Object object) {
    if (object is Parser) {
      return object;
    }

    if (object is LazyParser) {
      return ThunkParser(object);
    }

    if (object is String) {
      if (object == "") {
        return EpsilonParser();
      }
      return StringParser(object);
    }

    if (object is RegExp) {
      return RegExpParser.regex(object);
    }

    throw UnsupportedError("Object of type '${object.runtimeType}' is not a resolvable parser.");
  }

  static String _generateAsciiTree(
    Map<Parser, int> rules,
    Parser parser,
    String indent, {
    required bool isLast,
    required int level,
    Map<Parser, String>? marks,
  }) {
    StringBuffer buffer = StringBuffer();

    block:
    {
      String marker = isLast ? "??????" : "??????";

      buffer
        ..write(indent)
        ..write(marker);

      if (level > 0 && rules.containsKey(parser)) {
        buffer
          ..write(" (rule#${rules[parser]})")
          ..writeln();

        break block;
      }

      buffer
        ..write(" $parser")
        ..write((marks?.containsKey(parser) ?? false) ? "  <--  '${marks![parser]}'" : "")
        ..writeln();

      List<Parser> children = parser.children.toList();
      if (children.isNotEmpty) {
        String newIndent = "$indent${isLast ? "   " : "???  "}";
        for (int i = 0; i < children.length; i++) {
          buffer.write(_generateAsciiTree(
            rules,
            children[i],
            newIndent,
            isLast: i == children.length - 1,
            level: level + 1,
            marks: marks,
          ));
        }
      }
    }

    return buffer.toString();
  }
}

extension ParserSharedExtension on Parser {
  String generateAsciiTree({Map<Parser, String>? marks}) => Parser.generateAsciiTree(this, marks: marks);

  bool isMemoized() => Parser.isMemoized(this);
  bool isNullable() => Parser.isNullable(this);
  bool isTerminal() => Parser.isTerminal(this);
  bool isRecursive() => Parser.isRecursive(this);
  bool isMemoizable() => Parser.isMemoizable(this);
  bool isLeftRecursive() => Parser.isLeftRecursive(this);
  bool isRightRecursive() => Parser.isRightRecursive(this);
  bool isDefinitelyLeftRecursive() => Parser.isDefinitelyLeftRecursive(this);
  bool isDefinitelyRightRecursive() => Parser.isDefinitelyRightRecursive(this);
  bool isType<T extends Parser>() => Parser.isType<T>(this);
  bool equals(Object target) => Parser.equals(this)(target.$);

  Iterable<Parser> rules() => Parser.rules(this);
  Iterable<Parser> get firsts => firstChildren();
  Iterable<Parser> firstChildren() => Parser.firstChildren(this);
}

extension LazyParserMethodsExtension on Lazy<Parser> {
  String generateAsciiTree({Map<Parser, String>? marks}) => Parser.generateAsciiTree(this.$, marks: marks);

  bool isMemoized() => Parser.isMemoized(this.$);
  bool isNullable() => Parser.isNullable(this.$);
  bool isTerminal() => Parser.isTerminal(this.$);
  bool isRecursive() => Parser.isRecursive(this.$);
  bool isMemoizable() => Parser.isMemoizable(this.$);
  bool isLeftRecursive() => Parser.isLeftRecursive(this.$);
  bool isRightRecursive() => Parser.isRightRecursive(this.$);
  bool isDefinitelyLeftRecursive() => Parser.isDefinitelyLeftRecursive(this.$);
  bool isDefinitelyRightRecursive() => Parser.isDefinitelyRightRecursive(this.$);
  bool isType<T extends Parser>() => Parser.isType<T>(this.$);
  bool equals(Object target) => Parser.equals(this.$)(target.$);

  Iterable<Parser> rules() => Parser.rules(this.$);
  Iterable<Parser> get firsts => firstChildren();
  Iterable<Parser> firstChildren() => Parser.firstChildren(this.$);

  ThunkParser thunk() => ThunkParser(this);

  bool get leftRecursive => this.$.leftRecursive;
  List<ParserSetMapping> get parserSets => this.$.parserSets;
  ParserSetMapping get firstSets => this.$.firstSets;
  ParserSetMapping get followSets => this.$.followSets;
  ParserSetMapping get cycleSets => this.$.cycleSets;
  ParserSet get firstSet => this.$.firstSet;
  ParserSet get followSet => this.$.followSet;
  ParserSet get cycleSet => this.$.cycleSet;
}

extension GeneralParserExtension<T extends Object> on T {
  Parser get $ => Parser.resolve(this);
}

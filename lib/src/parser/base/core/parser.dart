// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class Parser {
  bool memoize = false;
  bool built = false;

  bool? _leftRecursive;
  List<ParserSetMapping>? _parserSets;
  ParserSetMapping? _firstSets;
  ParserSetMapping? _followSets;
  ParserSetMapping? _cycleSets;
  ParserSet? _firstSet;
  ParserSet? _followSet;
  ParserSet? _cycleSet;

  @Deprecated("Use the 'parseCtx' method")
  Context parse(Context context, MemoizationHandler handler);
  @Deprecated("Use the 'clone' method")
  Parser cloneSelf(HashMap<Parser, Parser> cloned);
  @Deprecated("Use the 'transform' method")
  Parser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed);

  @mustCallSuper
  bool hasEqualProperties(covariant Parser target) {
    return true;
  }

  @nonVirtual
  Context parseCtx(Context context, MemoizationHandler handler) {
    if (context.isFailure) {
      return context;
    }

    if (memoize) {
      return handler.resolve(this, context);
    } else {
      return parse(context, handler);
    }
  }

  Parser get base;
  List<Parser> get children;

  /// Utility class helpers

  static const int firstSetIndex = 0;
  static const int followSetIndex = 1;
  static const int cycleSetIndex = 2;

  static final Parser startSentinel = epsilon();
  static final Parser endSentinel = dollar();

  static bool equals(Parser parser, Parser target) {
    if (parser == target) {
      return true;
    }

    Iterable<Parser> leftString = parser.traverseBreadthFirst().whereNotType<ThunkParser>();
    Iterable<Parser> rightString = target.traverseBreadthFirst().whereNotType<ThunkParser>();
    Iterable<List<Parser>> zipped = leftString.zip.rest(rightString);

    for (List<Parser> pair in zipped) {
      Parser left = pair[0];
      Parser right = pair[1];

      if (left.runtimeType != right.runtimeType || !left.hasEqualProperties(right)) {
        return false;
      }
    }

    return true;
  }

  static ST clone<ST extends Parser>(ST parser, [HashMap<Parser, Parser>? cloned]) {
    cloned ??= HashMap<Parser, Parser>.identity();
    ST clone = (cloned[parser] ??= parser.cloneSelf(cloned)
      ..memoize = parser.memoize
      ..built = parser.built) as ST;

    return clone;
  }

  static ST transformWhere<T extends Parser, ST extends Parser>(
    ST parser,
    ParserPredicate predicate,
    TransformHandler<T> handler,
  ) {
    return parser.transform((Parser parser) {
      if (predicate(parser) && parser is T) {
        return handler(parser);
      }
      return parser;
    });
  }

  static ST transformType<T extends Parser, ST extends Parser>(ST parser, TransformHandler<T> handler) {
    return parser.transform((Parser parser) {
      if (parser is T) {
        return handler(parser);
      }
      return parser;
    });
  }

  static ST transformOrSelf<ST extends Parser>(ST parser, NullableTransformHandler handler) {
    return parser.transform((Parser parser) => handler(parser) ?? parser);
  }

  static ST transform<ST extends Parser>(ST parser, TransformHandler handler, [HashMap<Parser, Parser>? transformed]) {
    transformed ??= HashMap<Parser, Parser>.identity();

    return (transformed[parser] ??= handler(parser.transformChildren(handler, transformed))) as ST;
  }

  static ST build<ST extends Parser>(ST parser) {
    if (parser.built) {
      // print("Parser is already built, so saving a few cycles.");
      return parser;
    }

    ST built = Parser.clone(parser) //
        .streamTransform()
        .whereType((CacheParser parser) => parser.parser)
        .whereType((ThunkParser parser) => parser.computed..memoize = true)
        .run() as ST
      ..built = true;

    List<ParserSetMapping> mapping = built.computeParserSets();
    built._parserSets = mapping;
    built._leftRecursive = built.isLeftRecursive();
    ParserSetMapping firstSets = mapping[0];
    ParserSetMapping followSets = mapping[1];
    ParserSetMapping cycleSets = mapping[2];

    for (Parser parser in built.traverseBf) {
      parser._firstSet = firstSets[parser];
      parser._followSet = followSets[parser];
      parser._cycleSet = cycleSets[parser];
    }

    return built;
  }

  static ST simplified<ST extends Parser>(ST parser) {
    return parser.transformType((WrapParser p) => p.base);
  }

  static T run<T extends ParseResult>(Parser parser, String input, {bool? map, bool? end}) {
    Context result = runCtx(parser, input, end: end);

    if (result is ContextFailure) {
      throw ParseException(result.message);
    } else if (result is ContextSuccess) {
      if (map ?? true) {
        return result.mappedResult as T;
      } else {
        return result.unmappedResult as T;
      }
    }
    throw ParseException("Detected ignore context. Check the grammar lmao.");
  }

  static Context runCtx(Parser parser, String input, {bool? map, bool? end}) {
    end ??= false;

    MemoizationHandler handler = MemoizationHandler();
    Parser built = end ? parser.build().end() : parser.build();
    String formatted = input.replaceAll("\r", "").unindent();
    Context context = Context.ignore(State(input: formatted, map: map ?? true));
    Context result = built.parseCtx(context, handler);

    if (result is ContextFailure) {
      return result.withFailureMessage();
    } else {
      return result;
    }
  }

  static String generateAsciiTree(Parser parser, {Map<Parser, String>? marks}) {
    int counter = 0;
    Map<Parser, int> rules = <Parser, int>{for (Parser p in Parser.rules(parser)) p: counter++};
    StringBuffer buffer = StringBuffer();

    for (Parser p in rules.keys) {
      buffer.writeln("(rule#${rules[p]})");
      buffer.writeln(_generateAsciiTree(rules, p, "", isLast: true, level: 0, marks: marks));
    }

    return buffer.toString().trimRight();
  }

  static Iterable<Parser> traverseDepthFirst(Parser root) sync* {
    Set<Parser> traversed = Set<Parser>.identity();
    List<Parser> parsers = <Parser>[root];

    while (parsers.isNotEmpty) {
      Parser current = parsers.removeLast();
      if (traversed.add(current)) {
        yield current;

        parsers.addAll(current.children);
      }
    }
  }

  static Iterable<Parser> traverseBreadthFirst(Parser root) sync* {
    Set<Parser> traversed = Set<Parser>.identity()..add(root);
    Queue<Parser> parsers = Queue<Parser>()..add(root);

    while (parsers.isNotEmpty) {
      Parser current = parsers.removeFirst();

      yield current;

      for (Parser child in current.children) {
        if (traversed.add(child)) {
          parsers.add(child);
        }
      }
    }
  }

  static List<ParserSetMapping> computeParserSets(Parser root, [Iterable<Parser>? parsers]) {
    parsers ??= root.traverseBf;

    ParserSetMapping firstSets = Parser._computeFirstSets(parsers);
    ParserSetMapping followSets = Parser._computeFollowSets(root, parsers, firstSets);
    ParserSetMapping cycleSets = Parser._computeCycleSets(parsers, firstSets);

    return <ParserSetMapping>[firstSets, followSets, cycleSets];
  }

  static void generateParserSets(Parser root) {
    Iterable<Parser> parsers = root.traverseBf;
    List<ParserSetMapping> parserSets = Parser.computeParserSets(root, parsers);

    for (Parser parser in parsers) {
      parser._parserSets = parserSets;
      parser._firstSet = (parser._firstSets = parserSets[Parser.firstSetIndex])[parser];
      parser._followSet = (parser._followSets = parserSets[Parser.followSetIndex])[parser];
      parser._cycleSet = (parser._cycleSets = parserSets[Parser.cycleSetIndex])[parser];
    }
  }

  static bool isTerminal(Parser parser) {
    return parser.children.isEmpty;
  }

  static bool isNullable(Parser parser) {
    bool parserIsEpsilon(Parser p) => p is EpsilonParser || p == "".p();
    bool parserIsNullable(Parser p) => p is SuccessParser || p is OptionalParser || parserIsEpsilon(p);

    late bool isNullable = parserIsNullable(parser);
    late bool isNullableChoice = parser is ChoiceParser && parser.children.any(parserIsNullable);

    return isNullable || isNullableChoice;
  }

  static bool isRecursive(Parser root) {
    List<Parser> parsers = <Parser>[...root.children];
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

  static bool isLeftRecursive(Parser root) {
    Iterable<Parser> toAdd = Parser.firstChildren(root);
    Queue<Parser> parsers = Queue<Parser>()..addAll(toAdd);
    Set<Parser> visited = <Parser>{...toAdd};

    while (parsers.isNotEmpty) {
      Parser current = parsers.removeFirst();
      if (current == root) {
        return true;
      }

      Parser.firstChildren(current).where(visited.add).forEach(parsers.add);
    }

    return false;
  }

  static bool isMemoizable(Parser parser) {
    return parser is ThunkParser || parser.memoize;
  }

  static bool isMemoized(Parser parser) {
    return parser.memoize;
  }

  static Iterable<Parser> rules(Parser root) sync* {
    yield* root
        .transformType((ThunkParser p) => p..computed.memoize = true) //
        .traverseBreadthFirst()
        .where(~Parser.isTerminal & Parser.isMemoized);
  }

  static List<Parser> firstChildren(Parser root) {
    return <Parser>[
      if (root is SequenceParser) root.children.first else ...root.children,
    ];
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

  static ParserTransformStream streamTransform(Parser root) {
    return ParserTransformStream(root);
  }

  static ParserSetMapping _computeFirstSets(Iterable<Parser> parsers) {
    ParserSetMapping firstSets = <Parser, ParserSet>{
      for (Parser parser in parsers)
        parser: <Parser>{
          if (isTerminal(parser)) parser,
          if (isNullable(parser)) startSentinel,
        }
    };

    bool changed = false;
    do {
      changed = false;

      for (Parser parser in parsers) {
        changed |= _expandFirstSets(parser, firstSets);
      }
    } while (changed);

    return firstSets;
  }

  static bool _expandFirstSets(Parser parser, ParserSetMapping firstSets) {
    const bool false_ = false;
    bool changed = false;
    ParserSet firstSet = firstSets[parser]!;

    outer:
    do {
      if (parser is SequentialParser) {
        for (Parser child in parser.children) {
          bool nullable = false;
          for (Parser first in firstSets[child]!) {
            if (isNullable(first)) {
              nullable = true;
            } else {
              changed |= firstSet.add(first);
            }
          }
          if (!nullable) {
            break outer;
          }
        }
        changed |= firstSet.add(startSentinel);
      } else if (parser is ChoiceParser) {
        for (Parser child in parser.children) {
          for (Parser first in firstSets[child]!) {
            changed |= firstSet.add(first);
          }
        }
      }
    } while (false_);

    return changed;
  }

  static ParserSetMapping _computeFollowSets(Parser root, Iterable<Parser> parsers, ParserSetMapping firsts) {
    ParserSetMapping followSets = <Parser, ParserSet>{
      for (final Parser parser in parsers)
        parser: <Parser>{
          if (parser == root) endSentinel,
        }
    };
    bool changed = false;
    do {
      changed = false;
      for (Parser parser in parsers) {
        changed |= _expandFollowSet(parser, followSets, firsts);
      }
    } while (changed);
    return followSets;
  }

  static bool _expandFollowSet(Parser parser, ParserSetMapping follows, ParserSetMapping firsts) {
    if (parser is SequentialParser) {
      return _expandFollowSetOfSequence(parser, parser.children, follows, firsts);
    } else if (parser is CyclicParser) {
      List<Parser> children = <Parser>[parser.children.first, ...parser.children];

      return _expandFollowSetOfSequence(parser, children, follows, firsts);
    } else {
      bool changed = false;
      for (Parser child in parser.children) {
        for (Parser follow in follows[parser]!) {
          changed |= follows[child]!.add(follow);
        }
      }
      return changed;
    }
  }

  static bool _expandFollowSetOfSequence(
    Parser parser,
    List<Parser> children,
    ParserSetMapping follows,
    ParserSetMapping firsts,
  ) {
    bool changed = false;
    for (int i = 0; i < children.length - 1; i++) {
      ParserSet firstSet = <Parser>{};
      int j = i + 1;
      for (; j < children.length; j++) {
        firstSet.addAll(firsts[children[j]]!);
        if (!firsts[children[j]]!.any(isNullable)) {
          break;
        }
      }
      if (j == children.length) {
        for (Parser follow in follows[parser]!) {
          changed |= follows[children[i]]!.add(follow);
        }
      }
      for (Parser first in firstSet.where((Parser first) => !isNullable(first))) {
        changed |= follows[children[i]]!.add(first);
      }
    }

    for (Parser follow in follows[parser]!) {
      changed |= follows[children.last]!.add(follow);
    }
    return changed;
  }

  static ParserSetMapping _computeCycleSets(Iterable<Parser> parsers, ParserSetMapping firsts) {
    ParserSetMapping cycleSets = <Parser, ParserSet>{};
    for (Parser parser in parsers) {
      _computeCycleSet(parser, firsts, cycleSets, <Parser>[parser]);
    }
    return cycleSets;
  }

  static void _computeCycleSet(Parser parser, ParserSetMapping firsts, ParserSetMapping cycles, List<Parser> stack) {
    if (cycles.containsKey(parser)) {
      return;
    }
    if (isTerminal(parser)) {
      cycles[parser] = const <Parser>{};
      return;
    }

    List<Parser> children = _computeCycleChildren(parser, firsts);
    for (Parser child in children) {
      int index = stack.indexOf(child);

      if (index >= 0) {
        List<Parser> cycle = stack.sublist(index);
        for (Parser parser in cycle) {
          cycles[parser] = cycle.toSet();
        }
        return;
      } else {
        stack.add(child);
        _computeCycleSet(child, firsts, cycles, stack);
        stack.removeLast();
      }
    }
    if (!cycles.containsKey(parser)) {
      cycles[parser] = const <Parser>{};
      return;
    }
  }

  static List<Parser> _computeCycleChildren(Parser parser, ParserSetMapping firstSets) {
    if (parser is SequentialParser) {
      List<Parser> children = <Parser>[];
      for (Parser child in parser.children) {
        children.add(child);
        if (!firstSets[child]!.any(isNullable)) {
          break;
        }
      }
      return children;
    }
    return parser.children.toList();
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

    // ignore: literal_only_boolean_expressions
    do {
      String marker = isLast ? "└─" : "├─";

      buffer
        ..write(indent)
        ..write(marker);

      if (level > 0 && rules.containsKey(parser)) {
        buffer
          ..write(" (rule#${rules[parser]})")
          ..writeln();

        break;
      }

      buffer
        ..write(" $parser")
        ..write((marks?.containsKey(parser) ?? false) ? "  <--  '${marks![parser]}'" : "")
        ..writeln();

      List<Parser> children = parser.children.toList();
      if (children.isNotEmpty) {
        String newIndent = "$indent${isLast ? "   " : "│  "}";
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
    } while (false);

    return buffer.toString();
  }
}

extension SharedParserExtension<ST extends Parser> on ST {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => Parser.run(this, input, map: map, end: end);
  Context runCtx(String input, {bool? map, bool? end}) => Parser.runCtx(this, input, map: map, end: end);
  String generateAsciiTree({Map<Parser, String>? marks}) => Parser.generateAsciiTree(this, marks: marks);

  ST build() => Parser.build(this);
  ST simplified() => Parser.simplified(this);
  ST clone([HashMap<Parser, Parser>? cloned]) => Parser.clone(this, cloned);

  ST transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      Parser.transformWhere(this, predicate, handler);
  ST transformType<T extends Parser>(TransformHandler<T> handler) => //
      Parser.transformType(this, handler);
  ST transformOrSelf<T extends Parser>(NullableTransformHandler handler) => //
      Parser.transformOrSelf(this, handler);
  ST transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      Parser.transform(this, handler, transformed);
  ParserTransformStream streamTransform() => Parser.streamTransform(this);

  bool isMemoized() => Parser.isMemoized(this);
  bool isNullable() => Parser.isNullable(this);
  bool isTerminal() => Parser.isTerminal(this);
  bool isRecursive() => Parser.isRecursive(this);
  bool isMemoizable() => Parser.isMemoizable(this);
  bool isLeftRecursive() => Parser.isLeftRecursive(this);
  bool equals(Object target) => Parser.equals(this, target.$);

  List<ParserSetMapping> computeParserSets() => Parser.computeParserSets(this);

  Iterable<Parser> rules() => Parser.rules(this);

  Iterable<Parser> get traverseBf => traverseBreadthFirst();
  Iterable<Parser> get traverseDf => traverseDepthFirst();

  Iterable<Parser> traverseBreadthFirst() => Parser.traverseBreadthFirst(this);
  Iterable<Parser> traverseDepthFirst() => Parser.traverseDepthFirst(this);

  Iterable<Parser> get firsts => firstChildren();

  Iterable<Parser> firstChildren() => Parser.firstChildren(this);

  bool get leftRecursive => _leftRecursive ?? Parser.isLeftRecursive(this);
  List<ParserSetMapping> get parserSets => _parserSets ??= Parser.computeParserSets(this);
  ParserSetMapping get firstSets => _firstSets ??= parserSets[Parser.firstSetIndex];
  ParserSetMapping get followSets => _followSets ??= parserSets[Parser.followSetIndex];
  ParserSetMapping get cycleSets => _cycleSets ??= parserSets[Parser.cycleSetIndex];
  ParserSet get firstSet => _firstSet ??= firstSets[this]!;
  ParserSet get followSet => _followSet ??= followSets[this]!;
  ParserSet get cycleSet => _cycleSet ??= cycleSets[this]!;
}

extension LazyParserMethodsExtension<ST extends Parser> on Lazy<ST> {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => Parser.run(this.$, input, map: map, end: end);
  Context runCtx(String input, {bool? map, bool? end}) => Parser.runCtx(this.$, input, map: map, end: end);
  String generateAsciiTree({Map<Parser, String>? marks}) => Parser.generateAsciiTree(this.$, marks: marks);

  Parser build() => Parser.build(this.$);
  Parser simplified() => Parser.simplified(this.$);
  Parser clone([HashMap<Parser, Parser>? cloned]) => Parser.clone(this.$);

  Parser transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      Parser.transformWhere(this.$, predicate, handler);
  Parser transformType<T extends Parser>(TransformHandler<T> handler) => //
      Parser.transformType(this.$, handler);
  Parser transformOrSelf<T extends Parser>(NullableTransformHandler handler) => //
      Parser.transformOrSelf(this.$, handler);
  Parser transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      Parser.transform(this.$, handler, transformed);
  ParserTransformStream streamTransform() => Parser.streamTransform(this.$);

  bool isMemoized() => Parser.isMemoized(this.$);
  bool isNullable() => Parser.isNullable(this.$);
  bool isTerminal() => Parser.isTerminal(this.$);
  bool isRecursive() => Parser.isRecursive(this.$);
  bool isMemoizable() => Parser.isMemoizable(this.$);
  bool isLeftRecursive() => Parser.isLeftRecursive(this.$);
  bool equals(Object target) => Parser.equals(this.$, target.$);

  List<ParserSetMapping> computeParserSets() => Parser.computeParserSets(this.$);

  Iterable<Parser> rules() => Parser.rules(this.$);

  Iterable<Parser> get traverseBF => traverseBreadthFirst();
  Iterable<Parser> get traverseDF => traverseDepthFirst();

  Iterable<Parser> traverseBreadthFirst() => Parser.traverseBreadthFirst(this.$);
  Iterable<Parser> traverseDepthFirst() => Parser.traverseDepthFirst(this.$);

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

extension RunParserMethodExtension<R> on T Function<T extends R>(String, {bool? map, bool? end}) {
  R unmapped(String input, {bool? map, bool? end}) => this(input, map: false, end: end);
}

// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class Parser {
  static final Never never = throw Error();
  static final Context seedFailure = Context.failure(State(input: ""), "seed");

  late final bool leftRecursive = Parser.isLeftRecursive(this);
  late final List<ParserSetMapping> parserSets = Parser.computeParserSets(this);
  late final ParserSetMapping firstSets = parserSets[Parser.firstSetIndex];
  late final ParserSetMapping followSets = parserSets[Parser.followSetIndex];
  late final ParserSetMapping cycleSets = parserSets[Parser.cycleSetIndex];
  late final ParserSet firstSet = firstSets[this] ?? const <Parser>{};
  late final ParserSet followSet = followSets[this] ?? const <Parser>{};
  late final ParserSet cycleSet = cycleSets[this] ?? const <Parser>{};

  bool memoize = false;
  bool built = false;

  @Deprecated("Use the 'parseCtx' method")
  Context parse(Context context, ParserMutable mutable);
  @Deprecated("Use the 'clone' method")
  Parser cloneSelf(HashMap<Parser, Parser> cloned);
  @Deprecated("Use the 'transform' method")
  Parser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed);

  MemoizationEntry? recall(int index, Context context, ParserMutable mutable) {
    MemoizationEntry? entry = mutable.memoMap.putIfAbsent(this, MemoizationSubMap.new)[index];
    Head? head = mutable.heads[index];

    // If the head is not being grown, return the memoized result.
    if (head == null || !head.evaluationSet.contains(this)) {
      return entry;
    }

    // If the current parser is not a part of the head and is not evaluated yet,
    // Add a failure to it.
    if (entry == null && !(head.involvedSet | <Parser>{head.parser}).contains(this)) {
      return Parser.seedFailure.index(index).entry();
    }

    // Remove the current parser from the head's evaluation set.
    head.evaluationSet.remove(this);
    entry!.value = parse(context, mutable);

    return entry;
  }

  Context leftRecursiveResult(int index, MemoizationEntry entry, ParserMutable mutable) {
    LeftRecursion leftRecursion = entry.value as LeftRecursion;
    Head head = leftRecursion.head!;
    Context seed = leftRecursion.seed;

    /// If the rule of the parser is not the one being parsed,
    /// return the seed.
    if (head.parser != this) {
      return seed;
    }

    /// Since it is the parser, assign it to the seed.
    Context seedContext = entry.value = seed;
    if (seedContext is ContextFailure) {
      return seedContext;
    }

    mutable.heads[index] = head;

    /// "Grow the seed."
    for (;;) {
      head.evaluationSet.addAll(head.involvedSet);
      Context result = parse(seedContext.index(index), mutable);
      if (result.state.index <= seedContext.state.index) {
        break;
      }
      entry.value = result;
    }
    mutable.heads.remove(index);

    return entry.value as Context;
  }

  Context runMemoized(Context context, ParserMutable mutable) {
    int index = context.state.index;

    MemoizationEntry? entry = recall(index, context, mutable);
    if (entry == null) {
      /// Create a new LR instance. Then, add it to the stack.
      LeftRecursion leftRecursion = LeftRecursion(seed: Parser.seedFailure, parser: this, head: null);
      mutable.parserCallStack.add(leftRecursion);

      /// Save a new entry on `position` with the LR instance.
      MemoizationSubMap subMap = mutable.memoMap.putIfAbsent(this, MemoizationSubMap.new);
      subMap[index] = entry = leftRecursion.entry();

      /// Evaluate the parser.
      Context ans = parse(context, mutable);

      /// Remove the created LR instance from the stack.
      mutable.parserCallStack.removeLast();

      /// If a descendant parser put a head in the lr then
      /// return the result of method `leftRecursiveResult`.
      if (leftRecursion.head != null) {
        leftRecursion.seed = ans;

        return leftRecursiveResult(index, entry, mutable);
      }

      /// If it was a normal parser result,
      /// return the resulting context.
      else {
        entry.value = ans;

        return ans;
      }
    } else {
      MemoizationEntryValue result = entry.value;

      if (result is LeftRecursion) {
        /// If a previous call on this parser on this position
        /// has placed an LR instance, then this is a left-recursive call.
        /// Create a new head instance, and assign it to the LR instance.
        Head head = result.head = Head(parser: this, evaluationSet: <Parser>{}, involvedSet: <Parser>{});

        /// While the LR of the current left-recursive parser is not yet found,
        /// Assign all the `lrStack` items to have the `lHead` as their own head.
        /// Also, add the `rule` of `lrStack.item` to the `lHead.involvedSet`
        for (LeftRecursion left in mutable.parserCallStack.reversed.takeWhile((LeftRecursion lr) => lr.head != head)) {
          head.involvedSet.add(left.parser);
          left.head = head;
        }

        return result.seed;
      } else if (result is Context) {
        return result;
      }
      Parser.never;
    }
  }

  Context apply(Context context, ParserMutable mutable) {
    if (context is ContextFailure) {
      return context;
    }

    return memoize //
        ? runMemoized(context, mutable)
        : parse(context, mutable);
  }

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

  static const bool _false = false;

  static final Parser startSentinel = epsilon();
  static final Parser endSentinel = dollar();

  static ParserPredicate equals(Parser parser) {
    return (Parser target) {
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
    };
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
    return Parser.transform(parser, (Parser parser) {
      if (predicate(parser) && parser is T) {
        return handler(parser);
      }
      return parser;
    });
  }

  static ST transformType<T extends Parser, ST extends Parser>(ST parser, TransformHandler<T> handler) {
    return Parser.transform(parser, (Parser parser) {
      if (parser is T) {
        return handler(parser);
      }
      return parser;
    });
  }

  static ST transformReplace<ST extends Parser>(ST parser, Parser target, Parser replace) {
    return Parser.transform(parser, (Parser p) => p == target ? replace : p);
  }

  static ST transform<ST extends Parser>(ST parser, TransformHandler handler, [HashMap<Parser, Parser>? transformed]) {
    transformed ??= HashMap<Parser, Parser>.identity();

    return (transformed[parser] ??= handler(parser.transformChildren(handler, transformed))) as ST;
  }

  static ST build<ST extends Parser>(ST parser) {
    if (parser.built) {
      return parser;
    }

    ST built = Parser.clone(parser) //
        .transformType((UnwrappedParser parser) => parser.parser)
        .transformType((ThunkParser parser) => parser.computed..memoize = true)
      ..built = true;

    return built;
  }

  static ST simplified<ST extends Parser>(ST parser) {
    return Parser.transformType(parser, (WrapParser p) => p.base);
  }

  static T run<T extends ParseResult>(Parser parser, String input, {bool? map, bool? end}) {
    Context result = runCtx(parser, input, map: map, end: end);

    if (result is ContextFailure) {
      throw ParseException(result.message);
    } else if (result is ContextSuccess) {
      if (map ?? true) {
        return result.mappedResult as T;
      } else {
        return result.unmappedResult as T;
      }
    }
    throw ParseException("Detected ignore context. Check the grammar.");
  }

  static Context runCtx(Parser parser, String input, {bool? map, bool? end}) {
    end ??= false;
    map ??= true;

    late Parser built = parser.build();
    String formatted = input.replaceAll("\r", "").unindent();
    ParserMutable mutable = ParserMutable();
    Parser completed = end ? built.end() : built;
    Context context = Context.ignore(State(input: formatted, map: map));
    Context result = completed.apply(context, mutable);

    if (result is ContextFailure) {
      return result.withFailureMessage();
    } else {
      return result;
    }
  }

  static String generateAsciiTree(Parser parser, {Map<Parser, String>? marks}) {
    int counter = 0;
    Map<Parser, int> rules = <Parser, int>{for (Parser p in Parser.rules(parser)) p: ++counter};
    StringBuffer buffer = StringBuffer("\n");

    for (Parser p in rules.keys.where(marks?.keys.contains ?? (Parser c) => true)) {
      buffer
        ..writeln("(rule#${rules[p]})")
        ..writeln(_generateAsciiTree(rules, p, "", isLast: true, level: 0, marks: marks));
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
    yield root;
    yield* root
        .transformType((ThunkParser p) => p..computed.memoize = true) //
        .traverseBreadthFirst()
        .where(~Parser.equals(root) & Parser.isMemoized & ~Parser.isTerminal);
  }

  static List<Parser> firstChildren(Parser root) {
    return <Parser>[
      if (root is SequentialParser) root.children.first else ...root.children,
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
    bool changed = false;
    ParserSet firstSet = firstSets[parser]!;

    conditional:
    if (parser is SequentialParser) {
      for (Parser child in parser.children) {
        bool nullable = false;
        for (Parser first in firstSets[child]!) {
          if (Parser.isNullable(first)) {
            nullable |= true;
          } else {
            changed |= firstSet.add(first);
          }
        }
        if (!nullable) {
          break conditional;
        }
      }
      changed |= firstSet.add(startSentinel);
    } else {
      for (Parser child in parser.children) {
        for (Parser first in firstSets[child]!) {
          changed |= firstSet.add(first);
        }
      }
    }

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
      List<Parser> children = <Parser>[parser.parser, ...parser.children];

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
    } while (_false);

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

  ST transformReplace(Parser target, Parser result) => //
      Parser.transformReplace(this, target, result);
  ST transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      Parser.transformWhere(this, predicate, handler);
  ST transformType<T extends Parser>(TransformHandler<T> handler) => //
      Parser.transformType(this, handler);
  ST transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      Parser.transform(this, handler, transformed);

  bool isMemoized() => Parser.isMemoized(this);
  bool isNullable() => Parser.isNullable(this);
  bool isTerminal() => Parser.isTerminal(this);
  bool isRecursive() => Parser.isRecursive(this);
  bool isMemoizable() => Parser.isMemoizable(this);
  bool isLeftRecursive() => Parser.isLeftRecursive(this);
  bool equals(Object target) => Parser.equals(this)(target.$);

  List<ParserSetMapping> computeParserSets() => Parser.computeParserSets(this);

  Iterable<Parser> rules() => Parser.rules(this);

  Iterable<Parser> get traverseBf => traverseBreadthFirst();
  Iterable<Parser> get traverseDf => traverseDepthFirst();

  Iterable<Parser> traverseBreadthFirst() => Parser.traverseBreadthFirst(this);
  Iterable<Parser> traverseDepthFirst() => Parser.traverseDepthFirst(this);

  Iterable<Parser> get firsts => firstChildren();

  Iterable<Parser> firstChildren() => Parser.firstChildren(this);
}

extension LazyParserMethodsExtension on Lazy<Parser> {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => Parser.run(this.$, input, map: map, end: end);
  Context runCtx(String input, {bool? map, bool? end}) => Parser.runCtx(this.$, input, map: map, end: end);
  String generateAsciiTree({Map<Parser, String>? marks}) => Parser.generateAsciiTree(this.$, marks: marks);

  Parser build() => Parser.build(this.$);
  Parser simplified() => Parser.simplified(this.$);
  Parser clone([HashMap<Parser, Parser>? cloned]) => Parser.clone(this.$);

  Parser transformReplace(Parser target, Parser result) => //
      Parser.transformReplace(this.$, target, result);
  Parser transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      Parser.transformWhere(this.$, predicate, handler);
  Parser transformType<T extends Parser>(TransformHandler<T> handler) => //
      Parser.transformType(this.$, handler);
  Parser transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      Parser.transform(this.$, handler, transformed);

  bool isMemoized() => Parser.isMemoized(this.$);
  bool isNullable() => Parser.isNullable(this.$);
  bool isTerminal() => Parser.isTerminal(this.$);
  bool isRecursive() => Parser.isRecursive(this.$);
  bool isMemoizable() => Parser.isMemoizable(this.$);
  bool isLeftRecursive() => Parser.isLeftRecursive(this.$);
  bool equals(Object target) => Parser.equals(this.$)(target.$);

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

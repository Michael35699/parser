// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

abstract class Parser {
  static final Never never = throw Error();
  static final Context seedFailure = Context.failure(State(input: ""), "seed");

  late final bool leftRecursive = Parser.isLeftRecursive(this);
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
  Parser cloneSelf(HashMap<Parser, Parser> cloned);
  @Deprecated("Use the `transform` method")
  Parser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed);
  @Deprecated("Use the `pegApply` method")
  Context parsePeg(Context context, PegParserMutable mutable);
  @Deprecated("Push the parser into the `Trampoline` instead of calling it directly")
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation);

  @internal
  PegMemoizationEntry? recall(int index, Context context, PegParserMutable mutable) {
    PegMemoizationEntry? entry = mutable.memoMap.putIfAbsent(this, PegMemoizationSubMap.new)[index];
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
    entry!.value = parsePeg(context, mutable);

    return entry;
  }

  @internal
  Context leftRecursiveResult(int index, PegMemoizationEntry entry, PegParserMutable mutable) {
    PegLeftRecursion leftRecursion = entry.value as PegLeftRecursion;
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
      Context result = parsePeg(seedContext.index(index), mutable);
      if (result.state.index <= seedContext.state.index) {
        break;
      }
      entry.value = result;
    }
    mutable.heads.remove(index);

    return entry.value as Context;
  }

  Context applyPeg(Context context, PegParserMutable mutable) {
    Context result = mutable.memoMap
        .putIfAbsent(this, PegMemoizationSubMap.new)
        .putIfAbsent(context.state.index, () => parsePeg(context, mutable).entry())
        .value as Context;

    return result;
  }

  @internal
  Context parseQuadraticMemoized(Context context, PegParserMutable mutable) {
    int index = context.state.index;

    PegMemoizationEntry? entry = recall(index, context, mutable);
    if (entry == null) {
      /// Create a new LR instance. Then, add it to the stack.
      PegLeftRecursion leftRecursion = PegLeftRecursion(seed: Parser.seedFailure, parser: this, head: null);
      mutable.parserCallStack.add(leftRecursion);

      /// Save a new entry on `position` with the LR instance.
      entry = mutable.memoMap //
          .putIfAbsent(this, PegMemoizationSubMap.new)
          .putIfAbsent(index, leftRecursion.entry);

      /// Evaluate the parser.
      Context ans = parsePeg(context, mutable);

      /// Remove the created LR instance from the stack.
      mutable.parserCallStack.removeLast();

      /// If a descendant parser put a head in the lr then return the result of method [leftRecursiveResult()].
      if (leftRecursion.head != null) {
        leftRecursion.seed = ans;

        return leftRecursiveResult(index, entry, mutable);
      }

      /// If it was a normal parser result, return the resulting context.
      else {
        entry.value = ans;

        return ans;
      }
    } else {
      MemoizationEntryValue result = entry.value;

      if (result is PegLeftRecursion) {
        /// If a previous call on this parser on this position
        /// has placed an LR instance, then this is a left-recursive call.
        /// Create a new head instance, and assign it to the LR instance.
        Head head = result.head = Head(parser: this, evaluationSet: <Parser>{}, involvedSet: <Parser>{});

        /// While the LR of the current left-recursive parser is not yet found,
        /// Assign all the [lrStack] items to have the [lHead] as their own head.
        /// Also, add the [rule] of [lrStack.item] to the [lHead.involvedSet]
        for (PegLeftRecursion left
            in mutable.parserCallStack.reversed.takeWhile((PegLeftRecursion lr) => lr.head != head)) {
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

  @internal
  Context parseLinearMemoized(Context context, PegParserMutable mutable) {
    int index = context.state.index;
    PegMemoizationSubMap subMap = mutable.memoMap.putIfAbsent(this, PegMemoizationSubMap.new);
    PegMemoizationEntry? entry = subMap[index];

    if (entry != null) {
      return entry.value as Context;
    }

    if (leftRecursive) {
      subMap[index] = context.failure("seed").entry();
      Context ctx = parsePeg(context, mutable);
      if (ctx is ContextFailure) {
        return ctx;
      }
      subMap[index] = ctx.entry();

      for (;;) {
        Context inner = parsePeg(context, mutable);
        if (inner is ContextFailure || inner.state.index <= ctx.state.index) {
          return ctx;
        }

        ctx = inner;
        subMap[index] = ctx.entry();
      }
    } else {
      Context result = parsePeg(context, mutable);
      subMap[index] = result.entry();

      return result;
    }
  }

  @internal
  Context parsePureMemoized(Context context, PegParserMutable mutable) {
    int index = context.state.index;
    PegMemoizationSubMap subMap = mutable.memoMap.putIfAbsent(this, PegMemoizationSubMap.new);
    Context result = subMap.putIfAbsent(context.state.index, () {
      subMap[index] = context.failure("Left recursion detected.").entry();

      return subMap[index] = parsePeg(context, mutable).entry();
    }).value as Context;

    return result;
  }

  @internal
  Context pegApply(Context context, PegParserMutable mutable) {
    if (context is ContextFailure) {
      return context;
    }

    if (memoize) {
      switch (context.state.mode) {
        case ParseMode.purePeg:
          return parsePureMemoized(context, mutable);
        case ParseMode.linearPeg:
          return parseLinearMemoized(context, mutable);
        case ParseMode.quadraticPeg:
          return parseQuadraticMemoized(context, mutable);
        case ParseMode.gll:
          throw UnsupportedError("`ParseMode.gll` is only for GLL parsing mode!");
      }
    } else {
      return parsePeg(context, mutable);
    }
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
      String marker = isLast ? "└─" : "├─";

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

extension RunParserMethodExtension<R> on T Function<T extends R>(String,
    {ParseMode? mode, T Function(ContextFailure)? except}) {
  T pure<T extends R>(String input, {ParseMode? mode, T Function(ContextFailure)? except}) =>
      this(input, mode: ParseMode.purePeg, except: except);
  T linear<T extends R>(String input, {ParseMode? mode, T Function(ContextFailure)? except}) =>
      this(input, mode: ParseMode.linearPeg, except: except);
  T quadratic<T extends R>(String input, {ParseMode? mode, T Function(ContextFailure)? except}) =>
      this(input, mode: ParseMode.quadraticPeg, except: except);
}

extension ContextRunParserMethodExtension<R> on Context Function(String, {ParseMode? mode}) {
  Context pure(String input, {ParseMode? mode}) => this(input, mode: ParseMode.purePeg);
  Context linear(String input, {ParseMode? mode}) => this(input, mode: ParseMode.linearPeg);
  Context quadratic(String input, {ParseMode? mode}) => this(input, mode: ParseMode.quadraticPeg);
}

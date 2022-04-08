// ignore_for_file: avoid_returning_this, deprecated_member_use_from_same_package, avoid_equals_and_hash_code_on_mutable_classes, hash_and_equals

import "dart:collection";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class Parser {
  bool memoize = false;
  bool built = false;

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
  Iterable<Parser> get children;

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

  static ST transform<ST extends Parser>(ST parser, TransformHandler handler, HashMap<Parser, Parser> transformed) {
    return (transformed[parser] ??= handler(parser.transformChildren(handler, transformed)..memoize = parser.memoize)
      ..built = false) as ST;
  }

  static ST build<ST extends Parser>(ST parser) {
    if (parser.built) {
      return parser;
    }

    ST built = parser //
        .transformType<CacheParser>((CacheParser p) => p.parser)
        .transformType<ThunkParser>((ThunkParser p) {
      Parser comp = p.computed;
      while (comp is ThunkParser) {
        comp = comp.computed;
      }
      return comp..memoize = true;
    })
      ..built = true;

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
    Parser built = (end ? parser.end() : parser.cache()).build();
    String formatted = input.replaceAll("\r", "").unindent();
    Context context = Context.ignore(State(input: formatted, map: map ?? true));
    Context result = built.parseCtx(context, handler);

    if (result is ContextFailure) {
      return result.withFailureMessage();
    } else {
      return result;
    }
  }

  static String _generateAsciiTree(
    Map<Parser, int> rules,
    Parser parser,
    String indent, {
    required bool isLast,
    required int level,
  }) {
    if (parser is ThunkParser) {
      return _generateAsciiTree(rules, parser.computed, indent, isLast: isLast, level: level);
    }

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
        ..writeln();

      List<Parser> children = parser.children.toList();
      if (children.isNotEmpty) {
        String newIndent = "$indent${isLast ? "   " : "│  "}";
        for (int i = 0; i < children.length; i++) {
          buffer.write(_generateAsciiTree(
            rules,
            children[i],
            newIndent,
            isLast: i + 1 == children.length,
            level: level + 1,
          ));
        }
      }
    } while (false);

    return buffer.toString();
  }

  static String asciiTree(Parser parser) {
    Parser copy = Parser.clone(parser);
    int counter = 0;
    Map<Parser, int> rules = <Parser, int>{for (Parser p in Parser.rules(copy)) p: counter++};
    StringBuffer buffer = StringBuffer();

    for (Parser p in rules.keys) {
      buffer.writeln("(rule#${rules[p]})");
      buffer.writeln(_generateAsciiTree(rules, p, "", isLast: true, level: 0));
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

  static Iterable<Parser> rules(Parser root) sync* {
    yield* Parser.build(root) //
        .transformType((WrapParser p) => p.base)
        .traverseDepthFirst()
        .where((Parser p) => p.isRecursive())
        .where((Parser p) => p.memoize);
  }

  static Parser resolve(Object object) {
    if (object is Parser) {
      return object;
    }

    if (object is LazyParser) {
      return ThunkParser(object);
    }

    if (object is String) {
      return StringParser(object);
    }

    if (object is RegExp) {
      return RegExpParser.regex(object);
    }

    throw UnsupportedError("Object of type '${object.runtimeType}' is not a resolvable parser.");
  }
}

extension SharedParserExtension<ST extends Parser> on ST {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => Parser.run(this, input, map: map, end: end);
  Context runCtx(String input, {bool? map, bool? end}) => Parser.runCtx(this, input, map: map, end: end);
  String generateAsciiTree() => Parser.asciiTree(this);

  ST build() => Parser.build(this);
  ST simplified() => Parser.simplified(this);
  ST clone([HashMap<Parser, Parser>? cloned]) => Parser.clone(this, cloned);

  ST transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      Parser.transformWhere(this, predicate, handler);
  ST transformType<T extends Parser>(TransformHandler<T> handler) => //
      Parser.transformType(this, handler);
  ST transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      Parser.transform(this, handler, transformed ?? HashMap<Parser, Parser>.identity());

  bool isRecursive() => Parser.isRecursive(this);
  bool equals(Parser target) => Parser.equals(this, target);
  Iterable<Parser> rules() => Parser.rules(this);

  Iterable<Parser> traverseBreadthFirst() => Parser.traverseBreadthFirst(this);
  Iterable<Parser> traverseDepthFirst() => Parser.traverseDepthFirst(this);
}

extension LazyParserMethodsExtension on Lazy<Parser> {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => Parser.run(this.$, input, map: map, end: end);
  Context runCtx(String input, {bool? map, bool? end}) => Parser.runCtx(this.$, input, map: map, end: end);
  String generateAsciiTree() => Parser.asciiTree(this.$);

  Parser build() => Parser.build(this.$);
  Parser simplified() => Parser.simplified(this.$);
  Parser clone([HashMap<Parser, Parser>? cloned]) => Parser.clone(this.$);

  Parser transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      Parser.transformWhere(this.$, predicate, handler);
  Parser transformType<T extends Parser>(TransformHandler<T> handler) => //
      Parser.transformType(this.$, handler);
  Parser transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      Parser.transform(this.$, handler, transformed ?? HashMap<Parser, Parser>.identity());

  bool isRecursive() => Parser.isRecursive(this.$);
  bool equals(Parser target) => Parser.equals(this.$, target);
  Iterable<Parser> rules() => Parser.rules(this.$);

  Iterable<Parser> traverseBreadthFirst() => Parser.traverseBreadthFirst(this.$);
  Iterable<Parser> traverseDepthFirst() => Parser.traverseDepthFirst(this.$);

  ThunkParser thunk() => ThunkParser(this);
}

extension GeneralParserExtension<T extends Object> on T {
  Parser get $ => Parser.resolve(this);
}

extension RunParserMethodExtension<R> on T Function<T extends R>(String, {bool? map, bool? end}) {
  R unmapped(String input, {bool? map, bool? end}) => this(input, map: false, end: end);
}

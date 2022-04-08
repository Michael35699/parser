// ignore_for_file: deprecated_member_use_from_same_package, avoid_returning_this

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class Parser {
  bool memoize = false;

  @Deprecated("Use the 'parseCtx' method")
  Context parse(Context context, MemoizationHandler handler);
  @Deprecated("Use the 'clone' method")
  Parser cloneSelf(Map<Parser, Parser> cloned);
  @Deprecated("Use the 'transform' method")
  Parser transformChildren(TransformHandler handler, Map<Parser, Parser> transformed);

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
  Iterable<Parser> get traverse sync* {
    Set<Parser> traversed = Set<Parser>.identity();
    List<Parser> parsers = <Parser>[this];

    while (parsers.isNotEmpty) {
      Parser current = parsers.removeLast();
      if (traversed.add(current)) {
        yield current;

        parsers.addAll(current.children);
      }
    }
  }

  static Parser clone(Parser parser, Map<Parser, Parser> cloned) {
    return cloned[parser] ??= parser.cloneSelf(cloned)..memoize = parser.memoize;
  }

  static Parser transformWhere<T extends Parser>(Parser parser, ParserPredicate pred, TransformHandler<T> handler) {
    return parser.transform((Parser parser) {
      if (pred(parser) && parser is T) {
        return handler(parser);
      }
      return parser;
    });
  }

  static Parser transformType<T extends Parser>(Parser parser, TransformHandler<T> handler) {
    return parser.transform((Parser parser) {
      if (parser is T) {
        return handler(parser);
      }
      return parser;
    });
  }

  static Parser transform(Parser parser, TransformHandler handler, Map<Parser, Parser> transformed) {
    return transformed[parser] ??= handler(parser.transformChildren(handler, transformed)..memoize = parser.memoize);
  }

  static Parser build(Parser parser) {
    Parser built = parser //
        .transformType<CacheParser>((CacheParser p) => p.parser)
        .transformType<ThunkParser>((ThunkParser p) {
      Parser comp = p.computed;
      while (comp is ThunkParser) {
        comp = comp.computed;
      }
      return comp..memoize = true;
    });

    return built;
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
    Parser copy = parser.thunk().transformType<MappedParser>((MappedParser p) => p.parser);
    List<Parser> references = copy.traverse.whereType<ThunkParser>().map((ThunkParser p) => p.computed).toList();
    Map<Parser, int> rules = <Parser, int>{for (int i = 0; i < references.length; i++) references[i]: i};
    StringBuffer buffer = StringBuffer();

    for (Parser p in rules.keys) {
      buffer.writeln("(rule#${rules[p]})");
      buffer.writeln(_generateAsciiTree(rules, p, "", isLast: true, level: 0));
    }

    return buffer.toString().trimRight();
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

extension SharedParserExtension on Parser {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => Parser.run(this, input, map: map, end: end);

  Context runCtx(String input, {bool? map, bool? end}) => Parser.runCtx(this, input, map: map, end: end);

  Parser build() => Parser.build(this);

  String generateAsciiTree() => Parser.asciiTree(this);

  Parser clone([Map<Parser, Parser>? cloned]) => Parser.clone(this, cloned ?? <Parser, Parser>{});

  Parser transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      Parser.transformWhere(this, predicate, handler);

  Parser transformType<T extends Parser>(TransformHandler<T> handler) => Parser.transformType(this, handler);

  Parser transform(TransformHandler handler, [Map<Parser, Parser>? transformed]) =>
      Parser.transform(this, handler, transformed ?? <Parser, Parser>{});
}

extension LazyParserMethodsExtension on LazyParser {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => this.$.run(input, map: map, end: end);

  Context runCtx(String input, {bool? map, bool? end}) => this.$.runCtx(input, map: map, end: end);

  Parser build() => this.$.build();

  String generateAsciiTree() => this.$.generateAsciiTree();

  Parser clone([Map<Parser, Parser>? cloned]) => this.$.clone(cloned);

  Parser transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      this.$.transformWhere(predicate, handler);

  Parser transformType<T extends Parser>(TransformHandler<T> handler) => this.$.transformType(handler);

  Parser transform(TransformHandler handler, [Map<Parser, Parser>? transformed]) =>
      this.$.transform(handler, transformed);

  ThunkParser thunk() => ThunkParser(this);
}

extension GeneralParserExtension<T extends Object> on T {
  Parser get $ => Parser.resolve(this);
}

extension RunParserMethodExtension<R> on T Function<T extends R>(String, {bool? map, bool? end}) {
  R unmapped(String input, {bool? map, bool? end}) => this(input, map: false, end: end);
}

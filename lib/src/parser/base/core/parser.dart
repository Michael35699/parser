// ignore_for_file: deprecated_member_use_from_same_package, avoid_returning_this

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class Parser {
  bool memoize = false;
  bool computing = false;
  bool hasComputed = false;

  @Deprecated("Use the 'parseCtx' method")
  Context parse(Context context, MemoizationHandler handler);
  @Deprecated("Use the [clone] method")
  Parser cloneSelf();

  @nonVirtual
  Parser clone() => cloneSelf()
    ..memoize = memoize
    ..hasComputed = hasComputed;

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

  @mustCallSuper
  void replace<T extends Parser>(ParserPredicate target, TransformHandler<T> result) {}
  Parser replaceRecursive<T extends Parser>(ParserPredicate target, TransformHandler<T> result) {
    CacheParser parser = this.cache();
    Set<Parser> previous = <Parser>{...parser.traverse};
    Set<Parser> traversed = <Parser>{...previous};
    List<Parser> stack = <Parser>[...previous];

    while (stack.isNotEmpty) {
      Parser parent = stack.removeLast();

      for (Parser child in parent.children) {
        if (previous.contains(child)) {
          // Replace the parser if it's been seen.
          parent.replace(target, result);
        } else if (traversed.add(child)) {
          // If it's not been seen yet, add it to the stack.
          stack.add(child);
        }
      }
    }

    return parser.parser;
  }

  Parser deepClone() {
    CacheParser parser = this.cache();

    Set<Parser> previousParsers = <Parser>{...parser.traverse};
    Map<Parser, Parser> mapping = <Parser, Parser>{for (Parser p in previousParsers) p: p.clone()};
    List<Parser> stack = <Parser>[...previousParsers];
    Set<Parser> seen = <Parser>{...previousParsers};
    while (stack.isNotEmpty) {
      Parser parent = stack.removeLast();
      for (Parser p in parent.children) {
        if (previousParsers.contains(p)) {
          parent.replace((Parser c) => c == p, (Parser c) => mapping[c]!);
        } else if (seen.add(p)) {
          stack.add(p);
        }
      }
    }

    return parser.parser;
  }

  Parser applyTransformation<T extends Parser>(ParserPredicate target, TransformHandler<T> result) {
    Parser self = this;
    if (target(self) && self is T) {
      return result(self);
    }
    return this;
  }

  static Parser build(Parser parser) {
    CacheParser self = parser.cache();
    Parser resolved = self.parser
            .replaceRecursive((Parser p) => p is SynthesizedParser, (SynthesizedParser p) => p.synthesized)
            .replaceRecursive((Parser p) => p is CacheParser, (CacheParser p) => p.parser)
            .replaceRecursive((Parser p) => p is ThunkParser, (ThunkParser p) => p.computed..memoize = true)
        //
        ;

    return resolved;
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
    StringBuffer buffer = StringBuffer();

    // ignore: literal_only_boolean_expressions
    do {
      String marker = isLast ? "└─" : "├─";

      buffer
        ..write(indent)
        ..write(marker);

      if (level > 0 && rules.containsKey(parser)) {
        buffer
          ..write("(rule#${rules[parser]})")
          ..writeln();

        break;
      }

      buffer
        ..write("$parser")
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
    Parser copy = parser.thunk().deepClone();
    List<Parser> references = copy.traverse.whereType<ThunkParser>().map((ThunkParser p) => p.computed).toList();
    Map<Parser, int> rules = <Parser, int>{for (int i = 0; i < references.length; i++) references[i]: i};
    copy
      ..replaceRecursive((Parser p) => p is MappedParser, (MappedParser p) => p.parser)
      ..build();

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
}

extension LazyParserMethodsExtension on LazyParser {
  T run<T extends ParseResult>(String input, {bool? map, bool? end}) => this.$.run(input, map: map, end: end);
  Context runCtx(String input, {bool? map, bool? end}) => this.$.runCtx(input, map: map, end: end);
  Parser build() => this.$.build();
  String generateAsciiTree() => this.$.generateAsciiTree();

  ThunkParser thunk() => ThunkParser(this);
}

extension GeneralParserExtension<T extends Object> on T {
  Parser get $ => Parser.resolve(this);
}

extension RunParserMethodExtension<R> on T Function<T extends R>(String, {bool? map, bool? end}) {
  R unmapped(String input, {bool? map, bool? end}) => this(input, map: false, end: end);
}

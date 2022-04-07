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

  @nonVirtual
  Context runCtx(String input, {bool? map, bool? end}) {
    end ??= false;

    MemoizationHandler handler = MemoizationHandler();
    Parser parser = (end ? this.end() : this.cache()).build();
    String formatted = input.replaceAll("\r", "").unindent();
    Context context = Context.ignore(State(input: formatted, map: map ?? true));
    Context result = parser.parseCtx(context, handler);

    if (result is ContextFailure) {
      return result.withFailureMessage();
    } else {
      return result;
    }
  }

  T run<T extends ParseResult>(String input, {bool? map, bool? end}) {
    Context result = runCtx(input, end: end);

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

  Parser applyTransformation<T extends Parser>(ParserPredicate target, TransformHandler<T> result) {
    Parser self = this;
    if (target(self) && self is T) {
      return result(self);
    }
    return this;
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

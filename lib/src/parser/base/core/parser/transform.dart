// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:parser/internal_all.dart";

Parser _clone(Parser parser, [HashMap<Parser, Parser>? cloned]) {
  cloned ??= HashMap<Parser, Parser>.identity();
  Parser clone = cloned[parser] ??= parser.cloneSelf(cloned)
    ..prioritizeLeft = parser.prioritizeLeft
    ..memoize = parser.memoize
    ..built = parser.built;

  return clone;
}

Parser _build(Parser parser) {
  if (parser.built) {
    return parser;
  }

  Parser built = _clone(parser) //
      .transformType((UnwrappedParser parser) => parser.parser)
      .transformType((ThunkParser parser) => parser.computed..memoize = true)
    ..built = true;

  return built;
}

Parser _simplified(Parser parser) {
  return _clone(parser).transformType((WrapParser p) => p.base);
}

Parser _unmapped(Parser parser) {
  return _clone(parser).transformType((MappedParser p) => p.parser);
}

Parser _undropped(Parser parser) {
  return _clone(parser).transformType((DropParser p) => p.parser);
}

Parser _transformWhere<T extends Parser>(Parser parser, ParserPredicate predicate, TransformHandler<T> handler) {
  return _transform(parser, (Parser parser) {
    if (predicate(parser) && parser is T) {
      return handler(parser);
    }
    return parser;
  });
}

Parser _transformType<T extends Parser>(Parser parser, TransformHandler<T> handler) {
  return _transform(parser, (Parser parser) {
    if (parser is T) {
      return handler(parser);
    }
    return parser;
  });
}

Parser _transformReplace(Parser parser, Parser target, Parser replace) {
  return _transform(parser, (Parser p) => p == target ? replace : p);
}

Parser _transform(Parser parser, TransformHandler handler, [HashMap<Parser, Parser>? transformed]) {
  transformed ??= HashMap<Parser, Parser>.identity();
  Parser p = transformed[parser] ??= handler(parser.transformChildren(handler, transformed));

  return p;
}

extension ParserTransformExtension on Parser {
  Parser transformReplace(Parser target, Parser result) => //
      _transformReplace(this, target, result);
  Parser transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      _transformWhere(this, predicate, handler);
  Parser transformType<T extends Parser>(TransformHandler<T> handler) => //
      _transformType(this, handler);
  Parser transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      _transform(this, handler, transformed);

  Parser build() => _build(this);
  Parser unmapped() => _unmapped(this);
  Parser undropped() => _undropped(this);
  Parser simplified() => _simplified(this);
  Parser clone([HashMap<Parser, Parser>? cloned]) => _clone(this, cloned);
}

extension LazyParserTransformExtension on Lazy<Parser> {
  Parser transformReplace(Parser target, Parser result) => //
      _transformReplace(this.$, target, result);
  Parser transformWhere<T extends Parser>(ParserPredicate predicate, TransformHandler<T> handler) =>
      _transformWhere(this.$, predicate, handler);
  Parser transformType<T extends Parser>(TransformHandler<T> handler) => //
      _transformType(this.$, handler);
  Parser transform<T extends Parser>(TransformHandler handler, [HashMap<Parser, Parser>? transformed]) =>
      _transform(this.$, handler, transformed);

  Parser build() => _build(this.$);
  Parser unmapped() => _unmapped(this.$);
  Parser undropped() => _undropped(this.$);
  Parser simplified() => _simplified(this.$);
  Parser clone([HashMap<Parser, Parser>? cloned]) => _clone(this.$);
}

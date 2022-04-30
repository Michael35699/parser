import "package:parser/internal_all.dart";

MapFunction _$list<T>() => (ParseResult r, Context c) => (r as List<ParseResult>?)?.cast<T>();
MapFunction _$set<T>() => (ParseResult r, Context c) => (r as Set<ParseResult>?)?.cast<T>();
MapFunction _$map<K, V>() => (ParseResult r, Context c) => (r as Map<ParseResult, ParseResult>?)?.cast<K, V>();

MapFunction $list<T>() => _$list<T>();
MapFunction $set<T>() => _$set<T>();
MapFunction $map<K, V>() => _$map<K, V>();

extension StringIterableCastMappersExtension on String {
  MappedParser $list<T>() => map(_$list<T>());
  MappedParser $set<T>() => map(_$set<T>());
  MappedParser $map<K, V>() => map(_$map<K, V>());
}

extension LazyParserIterableCastMappersExtension on LazyParser {
  MappedParser $list<T>() => map(_$list<T>());
  MappedParser $set<T>() => map(_$set<T>());
  MappedParser $map<K, V>() => map(_$map<K, V>());
}

extension ParserIterableCastMappersExtension on Parser {
  MappedParser $list<T>() => map(_$list<T>());
  MappedParser $set<T>() => map(_$set<T>());
  MappedParser $map<K, V>() => map(_$map<K, V>());
}

extension BuiltIterableCastMappersExtension on MappedParser Function(MapFunction mapper, {bool replace}) {
  MappedParser $list<T>() => this(_$list<T>());
  MappedParser $set<T>() => this(_$set<T>());
  MappedParser $map<K, V>() => this(_$map<K, V>());
}

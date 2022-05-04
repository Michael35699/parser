import "package:parser/internal_all.dart";

MapFunction _$list<T>() => $maybe(List<T>.from);
MapFunction _$set<T>() => $maybe(Set<T>.from);
MapFunction _$map<K, V>() => $maybe(Map<K, V>.from);

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

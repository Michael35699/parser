import "dart:collection";

class DefaultMap<K, V> implements Map<K, V> {
  final HashMap<K, V> innerMap;
  final V Function() defaultGenerator;

  DefaultMap(this.defaultGenerator) : innerMap = HashMap<K, V>();
  DefaultMap.from(this.innerMap, this.defaultGenerator);

  @override
  V operator [](covariant K key) => innerMap[key] ??= defaultGenerator();
  @override
  void operator []=(K key, V value) => innerMap[key] = value;

  @override
  Iterable<K> get keys => innerMap.keys;
  @override
  Iterable<V> get values => innerMap.values;

  @override
  int get length => innerMap.length;

  @override
  void addAll(Map<K, V> other) => innerMap.addAll(other);

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) => innerMap.addEntries(newEntries);

  @override
  Map<RK, RV> cast<RK, RV>() => throw UnsupportedError(".cast is not supported!");

  @override
  void clear() => innerMap.clear();

  @override
  bool containsKey(Object? key) => innerMap.containsKey(key);

  @override
  bool containsValue(Object? value) => innerMap.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => innerMap.entries;

  @override
  void forEach(void Function(K key, V value) action) => innerMap.forEach(action);

  @override
  bool get isEmpty => innerMap.isEmpty;

  @override
  bool get isNotEmpty => innerMap.isNotEmpty;

  @override
  DefaultMap<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) =>
      throw UnsupportedError(".map is not supported!");

  @override
  V putIfAbsent(K key, V Function() ifAbsent) => innerMap.putIfAbsent(key, ifAbsent);

  @override
  V? remove(covariant K key) => innerMap.remove(key);

  @override
  void removeWhere(bool Function(K key, V value) test) => innerMap.removeWhere(test);

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) =>
      innerMap.update(key, update, ifAbsent: ifAbsent);

  @override
  void updateAll(V Function(K key, V value) update) => innerMap.updateAll(update);
}

import "dart:collection";

class DefaultMap<K, V> {
  final HashMap<K, V> innerMap;
  final V Function() defaultGenerator;

  DefaultMap(this.defaultGenerator) : innerMap = HashMap<K, V>();
  DefaultMap.from(this.innerMap, this.defaultGenerator);

  V operator [](K key) => innerMap[key] ?? defaultGenerator();
  void operator []=(K key, V value) => innerMap[key] = value;

  Iterable<K> get keys => innerMap.keys;
  Iterable<V> get values => innerMap.values;

  int get length => innerMap.length;
}

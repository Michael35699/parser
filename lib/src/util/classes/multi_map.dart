import "dart:collection";
import "dart:math" as math;

///
/// Custom map class made to be abused in place of
/// nested HashMaps. Can support non-typed keys by
/// placing Object in the `K` type generic.
///
class MultiMap<K, V> {
  static final int _safeGuard = math.Random.secure().nextInt(1 << 32);

  HashMap<dynamic, dynamic> innerMap = HashMap<dynamic, dynamic>();
  final int? requiredKeyCount;

  MultiMap([this.requiredKeyCount]);

  V? get(List<K> keys) => _get(keys);
  V? operator [](List<K> keys) => _get(keys);

  V set(List<K> keys, V value) => _set(keys, value);
  void operator []=(List<K> keys, V value) => _set(keys, value);

  V? _get(List<K> keys) {
    _checkKeyLength(keys);

    HashMap<dynamic, dynamic>? map = innerMap;
    for (int i = 0; i < keys.length; i++) {
      map = map?[keys[i]] as HashMap<dynamic, dynamic>?;

      if (map == null) {
        return null;
      }
    }

    V? value = map?[_safeGuard] as V?;
    if (value == null) {
      return null;
    }

    return value;
  }

  V _set(List<K> keys, V value) {
    _checkKeyLength(keys);

    HashMap<dynamic, dynamic> map = innerMap;
    for (int i = 0; i < keys.length; i++) {
      map = map.putIfAbsent(keys[i], () => HashMap<dynamic, dynamic>()) as HashMap<dynamic, dynamic>;
    }

    return map[_safeGuard] = value;
  }

  void _checkKeyLength(List<K> keys) {
    if (requiredKeyCount == null) {
      return;
    }

    if (keys.length != requiredKeyCount) {
      String message = "The required key count is $requiredKeyCount. The given keys are ${keys.length} long.";
      throw ArgumentError.value(keys, "", message);
    }
  }

  @override
  String toString() => innerMap.toString();
}

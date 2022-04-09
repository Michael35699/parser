extension SetExtensions<V> on Set<V> {
  Set<V> operator &(Set<V> other) => intersection(other);
  Set<V> operator |(Set<V> other) => union(other);
}

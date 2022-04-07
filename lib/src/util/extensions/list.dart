extension OperatorOverloadedListExtension<T> on List<T> {
  List<T> operator <<(T object) => <T>[...this, object];

  List<T> without(List<T> objects) => <T>[...this].where((T obj) => !objects.contains(obj)).toList();
}

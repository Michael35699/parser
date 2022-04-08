extension IterableExtensions<T> on Iterable<T> {
  Iterable<List<T>> zip(Iterable<Iterable<T>> iterables) sync* {
    if (iterables.isEmpty) {
      return;
    }

    List<Iterator<T>> iterators = <Iterable<T>>[this, ...iterables] //
        .map((Iterable<T> c) => c.iterator)
        .toList(growable: false);

    while (iterators.every((Iterator<T> i) => i.moveNext())) {
      yield iterators.map((Iterator<T> i) => i.current).toList(growable: false);
    }
  }

  Iterable<T> whereNotType<R>() => where((T item) => item is! R);
}

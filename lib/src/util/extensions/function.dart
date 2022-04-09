typedef GenericPredicate<T> = bool Function(T);

extension PredicateTearoffExtension<T> on GenericPredicate<T> {
  GenericPredicate<T> not() => (T item) => !this(item);
  GenericPredicate<T> or(GenericPredicate<T> other) => (T item) => this(item) || other(item);
  GenericPredicate<T> and(GenericPredicate<T> other) => (T item) => this(item) && other(item);
  GenericPredicate<T> xor(GenericPredicate<T> other) => (T item) => this(item) ^ other(item);

  GenericPredicate<T> operator ~() => not();
  GenericPredicate<T> operator |(GenericPredicate<T> other) => or(other);
  GenericPredicate<T> operator &(GenericPredicate<T> other) => and(other);
  GenericPredicate<T> operator ^(GenericPredicate<T> other) => xor(other);
}

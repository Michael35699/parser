import "package:parser_peg/util.dart";

class Predicate {
  static GenericPredicate<T> not<T>(bool Function(T) fn) => (T item) => !fn(item);
  static GenericPredicate<T> or<T>(GenericPredicate<T> left, GenericPredicate<T> right) =>
      (T item) => left(item) || right(item);
  static GenericPredicate<T> and<T>(GenericPredicate<T> left, GenericPredicate<T> right) =>
      (T item) => left(item) && right(item);
  static GenericPredicate<T> xor<T>(GenericPredicate<T> left, GenericPredicate<T> right) =>
      (T item) => left(item) ^ right(item);
}

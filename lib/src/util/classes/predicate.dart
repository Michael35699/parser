import "package:parser/util.dart";

class Predicate {
  static GenericPredicate<T> tautology<T>() => (T item) => true;
  static GenericPredicate<T> contradiction<T>() => (T item) => false;

  static GenericPredicate<T> not<T>(bool Function(T) fn) => (T item) => !fn(item);
  static GenericPredicate<T> or<T>(GenericPredicate<T> left, GenericPredicate<T> right) =>
      (T item) => left(item) || right(item);
  static GenericPredicate<T> and<T>(GenericPredicate<T> left, GenericPredicate<T> right) =>
      (T item) => left(item) && right(item);
  static GenericPredicate<T> xor<T>(GenericPredicate<T> left, GenericPredicate<T> right) =>
      (T item) => left(item) ^ right(item);
}

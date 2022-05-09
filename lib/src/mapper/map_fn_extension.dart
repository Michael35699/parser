import "package:parser/internal_all.dart";

extension MapFunctionExtension<R> on FunctorFunction<R> {
  FunctorFunction<Object?> operator >>>(Function fn) =>
      (dynamic r, Context c) => Function.apply(fn, <dynamic>[this(r, c)]);
}

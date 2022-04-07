import "package:parser_peg/internal_all.dart";

extension MapFunctionExtension on MapFunction {
  MapFunction operator <<(Function fn) => (dynamic r, Context c) => Function.apply(fn, <dynamic>[this(r, c)]);
}

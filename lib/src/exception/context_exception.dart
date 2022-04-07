import "package:parser_peg/internal_all.dart";

class ContextException implements Exception {
  final ContextFailure context;

  ContextException(this.context);
}

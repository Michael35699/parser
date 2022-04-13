import "package:parser/internal_all.dart";

class ContextException implements Exception {
  final ContextFailure context;

  ContextException(this.context);
}

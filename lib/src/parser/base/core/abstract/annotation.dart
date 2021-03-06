import "package:parser/internal_all.dart";

class AnnotationParser extends WrapParser with UnwrappedParser {
  AnnotationParser(Parser child) : super(<Parser>[child]);
  AnnotationParser.empty() : super(<Parser>[]);

  @override
  Parser get parser => children[0];

  @override
  AnnotationParser empty() => AnnotationParser.empty();

  @override
  Context parsePeg(Context context, PegHandler handler) => throw UnsupportedError("Annotation parsers can not parse!");

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      throw UnsupportedError("Annotation parsers can not parse!");
}

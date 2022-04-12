import "package:parser_peg/internal_all.dart";

class AnnotationParser extends WrapParser with UnwrappedParser {
  AnnotationParser(Parser child) : super(<Parser>[child]);
  AnnotationParser.empty() : super(<Parser>[]);

  @override
  Parser get parser => children[0];

  @override
  Parser get base => parser.base;

  @override
  Parser get unwrapped => parser;

  @override
  AnnotationParser empty() => AnnotationParser.empty();

  @override
  Context parse(Context context, ParserMutable mutable) => throw UnsupportedError("Annotation parsers can not parse!");
}

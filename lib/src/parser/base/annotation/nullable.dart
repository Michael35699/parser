import "package:parser/internal_all.dart";

class NullableAnnotationParser extends AnnotationParser {
  static final Map<Parser, NullableAnnotationParser> _savedParsers = <Parser, NullableAnnotationParser>{};
  factory NullableAnnotationParser(Parser parser) => _savedParsers[parser] ??= NullableAnnotationParser._(parser);
  NullableAnnotationParser._(Parser parser) : super(parser);
}

extension ParserNullableAnnotationExtension on Parser {
  NullableAnnotationParser nullable() => NullableAnnotationParser(this);
}

extension LazyParserNullableAnnotationExtension on Lazy<Parser> {
  NullableAnnotationParser nullable() => NullableAnnotationParser(this.$);
}

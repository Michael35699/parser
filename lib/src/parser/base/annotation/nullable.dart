import "package:parser_peg/internal_all.dart";

class NullableAnnotationParser extends AnnotationParser {
  static Map<Parser, NullableAnnotationParser> _savedParsers = <Parser, NullableAnnotationParser>{};
  factory NullableAnnotationParser(Parser parser) => _savedParsers[parser] ??= NullableAnnotationParser._(parser);
  NullableAnnotationParser._(Parser parser) : super(parser);
}

extension NullableAnnotationExtension on Parser {
  NullableAnnotationParser nullable() => NullableAnnotationParser(this);
}

extension LazyNullableAnnotationExtension on Lazy<Parser> {
  NullableAnnotationParser nullable() => NullableAnnotationParser(this.$);
}

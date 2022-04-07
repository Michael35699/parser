import "package:parser_peg/internal_all.dart";

extension ParserBuildExtension on Parser {
  Parser build() {
    CacheParser self = this.cache();
    Parser resolved = self.parser
            .replaceRecursive((Parser p) => p is SynthesizedParser, (SynthesizedParser p) => p.synthesized)
            .replaceRecursive((Parser p) => p is CacheParser, (CacheParser p) => p.parser)
            .replaceRecursive((Parser p) => p is ThunkParser, (ThunkParser p) => p.computed..memoize = true)
        //
        ;

    return resolved;
  }
}

import "package:parser/internal_all.dart";

///
/// How do I explain this... It's a useful shortcut
/// in creating grammar class-based definitions.
/// It can be used as a shortcut for both:
/// ```
/// $(() => parser);  == ThunkParser(() => parser)
/// 0.$ ^ parser;    == WithPrecedenceParser(0, parser)
/// ```
///

class GrammarMagic {
  const GrammarMagic._();

  GrammarMagicHelper1 operator [](num prec) => GrammarMagicHelper1(prec);
}

class GrammarMagicHelper1 {
  final num precedence;
  const GrammarMagicHelper1(this.precedence);

  WithPrecedenceParser operator ^(Object parser) => WithPrecedenceParser(precedence, parser.$);
  WithPrecedenceParser operator &(Object parser) => WithPrecedenceParser(precedence, parser.$);
}

const GrammarMagic $ = GrammarMagic._();

extension GrammarMagicExtension on Symbol {
  Parser call(Object parser) => ((Parser parser) => parser.map(
        $res((ParseResult result) => MapEntry<Symbol, ParseResult>(this, result)),
      ))(parser.$);
}

extension GrammarMagicNumExtension<T extends num> on T {
  GrammarMagicHelper1 get $ => GrammarMagicHelper1(this);
}

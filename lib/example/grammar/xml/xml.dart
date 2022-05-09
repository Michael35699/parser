import "package:parser/parser.dart" as parser;

typedef Parser = parser.Parser;
typedef Grammar = parser.Grammar;

class XmlGrammar with Grammar {
  @override
  Parser start() => document.end();
  Parser unit() => tag | textNode;
  Parser document() => unit.to(parser.eoi);
  Parser content() => unit.to(tagClose);

  Parser tag() => blockTag | singleTag;
  Parser blockTag() => tagOpen & content.failure(const <Object>[]) & tagClose;

  Parser tagOpen() => -"<".tr >> parser.identifier & tagAttributes << -">".tl;
  Parser singleTag() => -"<".tr >> parser.identifier & tagAttributes << -"/>".tl;
  Parser tagClose() => -"</".tr >> parser.identifier << -">".tl;

  Parser tagAttributes() => parser.whitespace >> tagAttribute.sep(-parser.whitespace).failure(const <Object>[]);
  Parser tagAttribute() =>
      parser.identifier.trim & -"=".t & parser.string.map.$at(1).or(parser.identifier) | //
      parser.identifier.trim & parser.success("true");

  Parser textNode() => textNodeChar.plus().flat();
  Parser textNodeChar() => (singleTag.not() & blockTag.not() & tagClose.not()) >> parser.source;
}

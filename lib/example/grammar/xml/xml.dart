import "package:parser/internal_all.dart";

class XmlGrammar with Grammar {
  @override
  Parser start() => document.end();
  Parser document() => tag.or(textNode).to(eoi);
  Parser content() => tag.or(textNode).to(tagClose);
  Parser tag() => blockTag | singleTag;
  Parser blockTag() => tagOpen & content.failure(const <Object>[]) & tagClose;

  Parser tagOpen() => -"<".tr >> identifier & tagAttributes << -">".tl;
  Parser singleTag() => -"<".tr >> identifier & tagAttributes << -"/>".tl;
  Parser tagClose() => -"</".tr >> identifier << -">".tl;

  Parser tagAttributes() => whitespace >> tagAttribute.sep(-whitespace).failure(const <Object>[]);
  Parser tagAttribute() =>
      identifier.trim & -"=".t & string.map.$at(1).or(identifier) | //
      identifier.trim & success("true");

  Parser textNode() => textNodeChar.plus().flat();
  Parser textNodeChar() => (singleTag.not() & blockTag.not() & tagClose.not()) >> source;
}

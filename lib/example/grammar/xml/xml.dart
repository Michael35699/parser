import "package:parser/internal_all.dart";

class XmlGrammar with Grammar {
  @override
  Parser start() => content.$;

  Parser content() => tag.or(textNode) >>> tagClose;
  Parser tag() => blockTag / singleTag;
  Parser blockTag() => tagOpen & content.optional & tagClose;
  Parser tagOpen() => -"<".tr >> identifier & tagAttributes << -">".tl;
  Parser singleTag() => -"<".tr >> identifier & tagAttributes << -"/>".tl;
  Parser tagClose() => -"</".tr >> identifier << -">".tl;

  Parser tagAttributes() => whitespace >> tagAttribute.sep(-whitespace) | success(const <Object>[]);
  Parser tagAttribute() =>
      identifier.trim & -"=".t & string.$at(1).or(identifier) | //
      identifier.trim & success("=") & success("true");

  Parser textNode() => textNodeChar.plus.$join();
  Parser textNodeChar() => ~tag >> tagClose.not() >> source;
}

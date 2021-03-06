import "package:parser/example/grammar/xml/evaluator/node.dart";
import "package:parser/example/grammar/xml/evaluator/typedef.dart";
import "package:parser/example/grammar/xml/xml.dart";
import "package:parser/parser.dart" as parser;

typedef Parser = parser.Parser;

class XmlEvaluator extends XmlGrammar {
  @override
  Parser start() => super.start.map.$type((List<XmlNode> nodes) => XmlNode.fragment(children: nodes));

  @override
  Parser document() => super.document.map.$list<XmlNode>();

  @override
  Parser content() => super.content.map.$list<XmlNode>();

  @override
  Parser tagOpen() => super.tagOpen.map.$2((String name, List<XmlAttribute> attributes) =>
      XmlTagStart(name: name, attributes: XmlAttributes.fromEntries(attributes)));

  @override
  Parser singleTag() => super.singleTag.map.$2((String name, List<XmlAttribute> attributes) =>
      XmlNode.tag(name: name, attributes: XmlAttributes.fromEntries(attributes)));

  @override
  Parser blockTag() => super.blockTag.bind.$3((XmlTagStart start, List<XmlNode> children, String end) => //
      start.name != end
          ? parser.failure("Mismatched tag '${start.name}' -> '$end'")
          : parser.success(XmlNode.tag(name: start.name, attributes: start.attributes, children: children)));

  @override
  Parser tagAttributes() => super.tagAttributes.map.$list<XmlAttribute>();

  @override
  Parser tagAttribute() => super.tagAttribute.map.$2(XmlAttribute.new);

  @override
  Parser textNode() => super.textNode.map.$type(XmlNode.text);
}

class XmlTagStart {
  final String name;
  final XmlAttributes attributes;

  const XmlTagStart({required this.name, required this.attributes});
}

extension XmlHelperExtension on String {
  String get stripXml => XmlEvaluator().start.pegCtx(this).maybeWhen<String>(
        success: (_, dynamic r, __) => (r as XmlFragmentNode).textContent,
        orElse: () => this,
      );
}

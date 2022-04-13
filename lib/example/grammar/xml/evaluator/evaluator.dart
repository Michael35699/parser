import "package:parser/example/grammar/xml/evaluator/node.dart";
import "package:parser/example/grammar/xml/evaluator/typedef.dart";
import "package:parser/example/grammar/xml/xml.dart";
import "package:parser/parser.dart";

class XmlEvaluator extends XmlGrammar {
  @override
  Parser start() => super.start.$type((List<XmlNode> nodes) => XmlNode.fragment(children: nodes));

  @override
  Parser content() => super.content.$type(List<XmlNode>.from);

  @override
  Parser tagOpen() => super.tagOpen.$2((String name, List<XmlAttribute> attributes) =>
      XmlTagStart(name: name, attributes: XmlAttributes.fromEntries(attributes)));

  @override
  Parser singleTag() => super.singleTag.$2((String name, List<XmlAttribute> attributes) =>
      XmlNode.tag(name: name, attributes: XmlAttributes.fromEntries(attributes)));

  @override
  Parser blockTag() => super.blockTag.$3((XmlTagStart start, List<XmlNode> children, String end) => //
      start.name != end
          ? throw Exception("Mismatched tag '${start.name}' -> '$end'")
          : XmlNode.tag(name: start.name, attributes: start.attributes, children: children));

  @override
  Parser tagAttributes() => super.tagAttributes.$type(List<XmlAttribute>.from);

  @override
  Parser tagAttribute() => super.tagAttribute.$2(XmlAttribute.new);

  @override
  Parser textNode() => super.textNode.$type(XmlNode.text);
}

class XmlTagStart {
  final String name;
  final XmlAttributes attributes;

  const XmlTagStart({required this.name, required this.attributes});
}

extension XmlHelperExtension on String {
  String get stripXml => XmlEvaluator().start.runCtx(this).maybeWhen<String>(
        success: (_, dynamic r, __) => (r as XmlFragmentNode).textContent,
        orElse: () => this,
      );
}

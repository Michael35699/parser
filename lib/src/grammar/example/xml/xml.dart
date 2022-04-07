import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

part "xml.freezed.dart";

class XmlGrammar with Grammar {
  @override
  Parser start() => content.$;

  Parser content() => tag.or(textNode) >>> tagClose;
  Parser tag() => blockTag / singleTag;
  Parser blockTag() => tagOpen & content.optional & tagClose;
  Parser tagOpen() => -"<".tr >> identifier & tagAttributes << -">".tl;
  Parser singleTag() => -"<".tr >> identifier & tagAttributes << -"/>".tl;
  Parser tagClose() => -"</".tr >> identifier << -">".tl;

  Parser tagAttributes() => whitespace >> tagAttribute.sep(~whitespace) | success(<Object>[]);
  Parser tagAttribute() =>
      identifier.trim & "=".t & string.$at(1).or(identifier) | //
      identifier.trim & success("=") & success("true");

  Parser textNode() => textNodeChar.plus.$join();
  Parser textNodeChar() => ~tag >> tagClose.not() >> source;
}

typedef XmlAttribute = MapEntry<String, String>;
typedef XmlAttributes = Map<String, String>;

class XmlEvaluator extends XmlGrammar {
  @override
  Parser start() => super.start.$type((List<XmlNode> nodes) => XmlNode.fragment(children: nodes));

  @override
  Parser content() => super.content.$type(List<XmlNode>.from);

  @override
  Parser tagOpen() => super.tagOpen.$2((String name, List<XmlAttribute> attributes) => //
      XmlTagStart(name: name, attributes: XmlAttributes.fromEntries(attributes)));

  @override
  Parser singleTag() => super.singleTag.$2((String name, List<XmlAttribute> attributes) =>
      XmlNode.tag(name: name, attributes: XmlAttributes.fromEntries(attributes)));

  @override
  Parser blockTag() => super.blockTag.$3((XmlTagStart start, List<XmlNode> children, String end) => //
      start.name != end
          ? log.error("Mismatched tag '${start.name}' -> '$end'")
          : XmlNode.tag(name: start.name, attributes: start.attributes, children: children));

  @override
  Parser tagAttributes() => super.tagAttributes.$type(List<XmlAttribute>.from);

  @override
  Parser tagAttribute() => super.tagAttribute.$3((String k, _, String v) => XmlAttribute(k, v));

  @override
  Parser textNode() => super.textNode.$type(XmlNode.text);
}

class XmlTagStart {
  final String name;
  final XmlAttributes attributes;

  const XmlTagStart({required this.name, required this.attributes});
}

@freezed
class XmlNode with _$XmlNode {
  const XmlNode._();
  const factory XmlNode.text(String value) = XmlTextNode;
  const factory XmlNode.fragment({required List<XmlNode> children}) = XmlFragmentNode;
  const factory XmlNode.tag({
    required String name,
    required XmlAttributes attributes,
    List<XmlNode>? children,
  }) = XmlTagNode;

  List<String>? get classList => mapOrNull<List<String>?>(
        tag: (XmlTagNode tag) => tag.attributes["class"]?.split(" ") ?? <String>[],
      );
  String? get id => mapOrNull<String?>(tag: (XmlTagNode tag) => tag.attributes["id"]);
  String? operator [](String key) => mapOrNull<String?>(tag: (XmlTagNode node) => node.attributes[key]);

  static String serialize(XmlAttributes attributes) {
    List<String> buffer = <String>[];
    for (MapEntry<String, String> entry in attributes.entries) {
      String key = entry.key;
      String value = entry.value;
      if (value == "true") {
        buffer.add(key);
      } else {
        buffer.add('$key="$value"');
      }
    }
    return buffer.join(" ");
  }

  String get innerXml => when(
        tag: (String tagName, XmlAttributes attributes, List<XmlNode>? children) {
          if (children == null) {
            return "";
          }
          return children.map<String>((XmlNode n) => n.outerXml).join();
        },
        fragment: (List<XmlNode> children) => children.map<String>((XmlNode n) => n.outerXml).join(" "),
        text: (String value) => value,
      );
  String get outerXml => when(
        tag: (String tagName, XmlAttributes attributes, List<XmlNode>? children) {
          if (children == null) {
            return "<$tagName ${serialize(attributes)} />";
          }
          StringBuffer buffer = StringBuffer("<$tagName ${serialize(attributes)}>");
          buffer.writeAll(children.map<String>((XmlNode n) => n.outerXml));
          buffer.write("</$tagName>");

          return buffer.toString();
        },
        fragment: (List<XmlNode> children) => children.map<String>((XmlNode n) => n.outerXml).join(" "),
        text: (String value) => value,
      );
  String get textContent => when(
        tag: (String tagName, XmlAttributes attributes, List<XmlNode>? children) =>
            children?.map<String>((XmlNode n) => n.textContent).join().unindent() ?? "",
        fragment: (List<XmlNode> children) => children.map<String>((XmlNode n) => n.textContent).join(" "),
        text: (String value) => value,
      );
}

extension XmlHelperExtension on String {
  String get stripXml => XmlEvaluator().start.runCtx(this).maybeWhen<String>(
        success: (_, dynamic r, __) => (r as XmlFragmentNode).textContent,
        orElse: () => this,
      );
}

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/example/grammar/xml/evaluator/typedef.dart";

part "node.freezed.dart";

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

  List<String>? get classList =>
      mapOrNull<List<String>?>(tag: (XmlTagNode tag) => tag.attributes["class"]?.split(" ") ?? <String>[]);
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
        tag: (String tagName, XmlAttributes attributes, List<XmlNode>? children) =>
            children?.map<String>((XmlNode n) => n.outerXml).join() ?? "",
        fragment: (List<XmlNode> children) => children.map<String>((XmlNode n) => n.outerXml).join(" "),
        text: (String value) => value,
      );
  String get outerXml => when(
        tag: (String tagName, XmlAttributes attributes, List<XmlNode>? children) {
          String serializedAttributes = serialize(attributes);
          if (children == null) {
            return "<$tagName $serializedAttributes />";
          }

          return (StringBuffer("<$tagName $serializedAttributes>")
                ..writeAll(children.map<String>((XmlNode n) => n.outerXml))
                ..write("</$tagName>"))
              .toString();
        },
        fragment: (List<XmlNode> children) => children.map<String>((XmlNode n) => n.outerXml).join(" "),
        text: (String value) => value,
      );
  String get textContent => when(
        tag: (String tagName, XmlAttributes attributes, List<XmlNode>? children) =>
            children?.map<String>((XmlNode n) => n.textContent).join() ?? "",
        fragment: (List<XmlNode> children) => children.map<String>((XmlNode n) => n.textContent).join(" "),
        text: (String value) => value,
      );
}

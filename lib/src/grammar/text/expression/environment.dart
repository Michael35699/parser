import "package:parser_peg/src/grammar/text/expression/node.dart";

class Environment {
  final Map<String, Node> definitions;
  Environment? parent;

  Environment() : definitions = <String, Node>{};
  Environment descendant() => Environment()..parent = this;
  Node? search(String key) => definitions[key] ?? parent?.search(key);
  void operator []=(String key, Node value) => definitions[key] = value;
}

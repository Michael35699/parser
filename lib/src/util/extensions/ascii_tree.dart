extension AsciiTreeDynamic<T> on T {
  static String asciiTree(dynamic value) => _asciiTree(value, "", isLast: true).toString().trimRight();

  static StringBuffer _asciiTree(dynamic value, String indent, {required bool isLast}) {
    StringBuffer buffer = StringBuffer();

    String marker = isLast ? "└─" : "├─";

    buffer
      ..write(indent)
      ..write(marker);

    if (value is List) {
      buffer
        ..write("[ ]")
        ..writeln();

      String newIndent = "$indent${isLast ? "   " : "│  "}";

      for (int i = 0; i < value.length; i++) {
        buffer.write(_asciiTree(value[i], newIndent, isLast: i + 1 == value.length));
      }
    } else {
      buffer
        ..write("'$value'")
        ..writeln();
    }

    return buffer;
  }

  String toAsciiString() => asciiTree(this);
}

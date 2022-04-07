extension AsciiTreeDynamic<T> on T {
  static String asciiTree(dynamic value, {Function? callback}) =>
      _asciiTree(value, "", isLast: true, callback: callback).toString().trimRight();

  static StringBuffer _asciiTree(dynamic value, String indent, {required bool isLast, Function? callback}) {
    StringBuffer buffer = StringBuffer();

    String marker = isLast ? "└─" : "├─";

    buffer
      ..write(indent)
      ..write(marker);

    if (value is! List) {
      buffer
        ..write("'$value'")
        ..writeln();
    } else {
      dynamic toWrite = callback != null ? Function.apply(callback, <dynamic>[value]) : "[...]";
      buffer
        ..write("'$toWrite'")
        ..writeln();

      String newIndent = "$indent${isLast ? "   " : "│  "}";

      for (int i = 0; i < value.length; i++) {
        if (callback != null && toWrite == value[i]) {
          continue;
        }
        buffer.write(_asciiTree(value[i], newIndent, isLast: i + 1 == value.length, callback: callback));
      }
    }

    return buffer;
  }

  String toAsciiString({Function? callback}) => asciiTree(this, callback: callback);
}

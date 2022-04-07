import "dart:math" as math;

///
/// Takes the common indent between all the lines,
/// and then removes the indent.
///
extension UnindentStringExtension on String {
  // Purposely hard to read.
  String unindent() => trim().isEmpty
      ? ""
      : ((Iterable<String> lines) => ( //
              (int indentSize) =>
                  lines.map((String line) => line.trim().isEmpty ? line : line.substring(indentSize)).join("\n"))(//
          lines
              .where((String line) => line.isNotEmpty)
              .map((String line) => line.split("").takeWhile((String c) => c.trim().isEmpty).length)
              .reduce((int min, int current) => math.min(min, current))))(trimRight()
          .replaceAll("\r", "")
          .split("\n")
          .map((String l) => l.trimRight())
          .skipWhile((String l) => l.trim().isEmpty));
}

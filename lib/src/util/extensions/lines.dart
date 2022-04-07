// ignore_for_file: always_specify_types

import "package:parser_peg/internal_all.dart";

extension LinesExtension on String {
  static MultiMap<Object, int> savedLine = MultiMap<Object, int>();
  static MultiMap<Object, int> savedColumn = MultiMap<Object, int>();

  List<String> get lines => split("\n");

  int lineOn(int index) => savedLine[[this, index]] ??= substring(0, index + 1).lines.length;

  int columnOn(int index) => savedColumn[[this, index]] ??= substring(0, index + 1).lines[lineOn(index) - 1].length;
}

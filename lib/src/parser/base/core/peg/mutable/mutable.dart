// ignore_for_file: deprecated_member_use_from_same_package

import "package:parser/internal_all.dart";

class ParserMutable {
  final List<LeftRecursion> parserCallStack = <LeftRecursion>[];
  final PegMemoizationMap memoMap = PegMemoizationMap();
  final Heads heads = Heads();
}

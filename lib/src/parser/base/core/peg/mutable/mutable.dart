// ignore_for_file: deprecated_member_use_from_same_package

import "package:parser/internal_all.dart";

class PegParserMutable {
  final List<PegLeftRecursion> parserCallStack = <PegLeftRecursion>[];
  final PegMemoizationMap memoMap = PegMemoizationMap();
  final PegHeads heads = PegHeads();
}

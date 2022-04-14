import "package:parser/internal_all.dart";

class PegParserMutable {
  final List<PegLeftRecursion> parserCallStack = <PegLeftRecursion>[];
  final PegMemoizationMap memoMap = PegMemoizationMap();
  final PegHeads heads = PegHeads();
}

// ignore_for_file: deprecated_member_use_from_same_package

import "package:parser_peg/internal_all.dart";

class ParserMutable {
  final List<LeftRecursion> parserCallStack = <LeftRecursion>[];
  final MemoizationMap memoMap = MemoizationMap();
  final Heads heads = Heads();
}

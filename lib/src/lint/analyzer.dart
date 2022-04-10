import "package:parser_peg/internal_all.dart";

class Analyzer {
  final Parser root;
  final Set<Parser> parsers;
  final ParserSetMapping firstSets;
  final ParserSetMapping followSets;
  final ParserSetMapping cycleSets;

  Analyzer(this.root)
      : parsers = root.traverseBf.toSet(),
        firstSets = root.firstSets,
        followSets = root.followSets,
        cycleSets = root.cycleSets;
}

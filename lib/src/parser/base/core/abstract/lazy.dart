import "dart:collection";

import "package:parser_peg/internal_all.dart";

abstract class LazyLoadParser extends Parser {
  abstract final LazyParser lazyParser;
  bool get memoizeBody;
  late Parser computed = lazyParser();

  LazyLoadParser();
  LazyLoadParser.eager(this.computed);

  @override
  List<Parser> get children => <Parser>[computed];

  @override
  Parser get base => computed;

  @override
  Parser cloneSelf(HashMap<Parser, Parser> cloned) {
    return eager(computed.clone(cloned));
  }

  @override
  Parser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed) {
    return this..computed = computed.transform(handler, transformed);
  }

  LazyLoadParser eager(Parser parser);
}

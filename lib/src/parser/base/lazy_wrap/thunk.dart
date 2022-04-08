import "dart:collection";

import "package:parser_peg/internal_all.dart";

class ThunkParser extends LazyLoadParser {
  static HashMap<LazyParser, ThunkParser> map = HashMap<LazyParser, ThunkParser>();

  @override
  final LazyParser lazyParser;

  @override
  final bool memoizeBody = true;

  factory ThunkParser(LazyParser lazyParser) => map[lazyParser] ??= ThunkParser._(lazyParser);
  ThunkParser.eager(Parser parser)
      : lazyParser = (() => parser),
        super.eager(parser);

  ThunkParser._(this.lazyParser);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    print("If you're seeing this, something went wrong.");

    return computed.parseCtx(context, handler);
  }

  @override
  Parser cloneSelf(HashMap<Parser, Parser> cloned) {
    return ThunkParser.eager(computed.clone(cloned));
  }

  @override
  Parser transformChildren(TransformHandler handler, HashMap<Parser, Parser> transformed) {
    return ThunkParser.eager(computed.transform(handler, transformed));
  }
}

ThunkParser thunk(LazyParser fn) => ThunkParser(fn);

extension ThunkExtension on Parser {
  ThunkParser thunk() => this is ThunkParser ? this as ThunkParser : ThunkParser(() => this);
}

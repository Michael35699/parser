import "dart:collection";

import "package:parser_peg/internal_all.dart";

class ThunkParser extends LazyLoadParser {
  static HashMap<LazyParser, ThunkParser> map = HashMap<LazyParser, ThunkParser>();

  @override
  final LazyParser lazyParser;

  @override
  final bool memoizeBody = true;

  factory ThunkParser(LazyParser lazyParser) => map[lazyParser] ??= ThunkParser._(lazyParser);
  ThunkParser._(this.lazyParser);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    print("If you're seeing this, something went wrong.");

    return computed.parseCtx(context, handler);
  }

  @override
  Parser cloneSelf(Map<Parser, Parser> cloned) {
    Parser evaluated = computed.clone(cloned);

    return ThunkParser(() => evaluated);
  }

  @override
  Parser transformChildren(TransformHandler handler, Map<Parser, Parser> transformed) {
    Parser evaluated = computed.transform(handler, transformed);

    return ThunkParser(() => evaluated);
  }
}

ThunkParser thunk(LazyParser fn) => ThunkParser(fn);

extension ThunkExtension on Parser {
  ThunkParser thunk() => this is ThunkParser ? this as ThunkParser : ThunkParser(() => this);
}

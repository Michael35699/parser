import "dart:collection";

import "package:parser/internal_all.dart";

class ThunkParser extends LazyLoadParser {
  static final HashMap<LazyParser, ThunkParser> _thunkMap = HashMap<LazyParser, ThunkParser>();

  @override
  final LazyParser lazyParser;

  @override
  final bool memoizeBody = true;

  factory ThunkParser(LazyParser lazyParser) => _thunkMap[lazyParser] ??= ThunkParser._(lazyParser);
  ThunkParser._(this.lazyParser);
  ThunkParser.eager(Parser parser)
      : lazyParser = (() => throw UnsupportedError("Hello")),
        super.eager(parser);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    print("If you're seeing this, something went wrong.");

    return handler.apply(computed, context);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    print("If you're seeing this, something went wrong.");

    trampoline.push(computed, context, continuation);
  }

  @override
  ThunkParser eager(Parser parser) => ThunkParser.eager(parser);
}

ThunkParser thunk(LazyParser fn) => ThunkParser(fn);

extension ParserThunkExtension on Parser {
  ThunkParser thunk() => this is ThunkParser ? this as ThunkParser : ThunkParser(() => this);
}

import "package:parser/internal_all.dart";

class CacheParser extends WrapParser with UnwrappedParser {
  @override
  Parser get parser => children[0];
  CacheParser(Parser parser) : super(<Parser>[parser]);
  CacheParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) => handler.apply(parser, context);

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      trampoline.push(parser, context, continuation);

  @override
  CacheParser empty() => CacheParser.empty();
}

CacheParser cache(Parser fn) => CacheParser(fn);

extension ParserCacheExtension on Parser {
  CacheParser cache() => this is CacheParser ? this as CacheParser : CacheParser(this);
}

extension LazyParserCacheExtension on Lazy<Parser> {
  CacheParser cache() => this.$.cache();
}

extension StringCacheExtension on String {
  CacheParser cache() => this.$.cache();
}

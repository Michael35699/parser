import "package:parser_peg/internal_all.dart";

class CacheParser extends WrapParser {
  Parser get parser => children[0];
  CacheParser(Parser parser) : super(<Parser>[parser]);

  @override
  Context parse(Context context, MemoizationHandler handler) =>
      throw UnsupportedError("Cache does not support parsing.");

  @override
  CacheParser cloneSelf() => CacheParser(parser);

  @override
  Parser get base => parser.base;
}

CacheParser cache(Parser fn) => CacheParser(fn);

extension CacheExtension on Parser {
  CacheParser cache() => this is CacheParser ? this as CacheParser : CacheParser(this);
}

extension LazyCacheExtension on Lazy<Parser> {
  CacheParser cache() => this.$.cache();
}

extension StringCacheExtension on String {
  CacheParser cache() => this.$.cache();
}

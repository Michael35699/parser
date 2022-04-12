import "package:parser_peg/internal_all.dart";

class CacheParser extends WrapParser with UnwrappedParser {
  @override
  Parser get parser => children[0];
  CacheParser(Parser parser) : super(<Parser>[parser]);
  CacheParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, ParserMutable mutable) => parser.apply(context, mutable);

  @override
  Parser get base => parser.base;

  @override
  CacheParser empty() => CacheParser.empty();
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

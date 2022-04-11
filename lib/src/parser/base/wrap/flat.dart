import "package:parser_peg/internal_all.dart";

class FlatParser extends WrapParser {
  @override
  Parser get parser => children[0];

  FlatParser(Parser parser) : super(<Parser>[parser]);
  FlatParser.empty() : super(<Parser>[]);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    Context result = parser.parseCtx(context, handler);

    if (result is ContextSuccess) {
      return result.success(result.state.input.substring(context.state.index, result.state.index));
    }
    return result;
  }

  @override
  FlatParser empty() => FlatParser.empty();

  @override
  Parser get base => parser.base;
}

FlatParser _flatParser(Parser parser) => FlatParser(parser);
FlatParser flat(Object parser) => _flatParser(parser.$);

extension FlatExtension on Parser {
  Parser flat() => _flatParser(this);
}

extension LazyFlatExtension on LazyParser {
  Parser flat() => this.$.flat();
}

extension StringFlatExtension on String {
  Parser flat() => this.$.flat();
}

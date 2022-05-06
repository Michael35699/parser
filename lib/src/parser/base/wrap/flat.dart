import "package:parser/internal_all.dart";

class FlatParser extends WrapParser {
  @override
  Parser get parser => children[0];

  FlatParser(Parser parser) : super(<Parser>[parser]);
  FlatParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context result = handler.apply(parser, context);

    if (result is ContextSuccess) {
      return result.success(result.state.input.substring(context.state.index, result.state.index));
    }
    return result;
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context result) {
      if (result is ContextSuccess) {
        continuation(result.success(result.state.input.substring(context.state.index, result.state.index)));
      } else {
        continuation(result);
      }
    });
  }

  @override
  FlatParser empty() => FlatParser.empty();
}

FlatParser _flatParser(Parser parser) => FlatParser(parser);
FlatParser flat(Object parser) => _flatParser(parser.$);

extension ParserFlatExtension on Parser {
  Parser flat() => _flatParser(this);
}

extension LazyParserFlatExtension on LazyParser {
  Parser flat() => this.$.flat();
}

extension StringFlatExtension on String {
  Parser flat() => this.$.flat();
}

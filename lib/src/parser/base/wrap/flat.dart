import "package:parser/internal_all.dart";

class FlatParser extends WrapParser {
  @override
  Parser get parser => children[0];

  FlatParser(Parser parser) : super(<Parser>[parser]);
  FlatParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context result = parser.pegApply(context, mutable);

    if (result is ContextSuccess) {
      return result.success(result.state.input.substring(context.state.index, result.state.index));
    }
    return result;
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context context) {
      if (context is ContextSuccess) {
        continuation(context.success(context.state.input.substring(context.state.index, context.state.index)));
      } else {
        continuation(context);
      }
    });
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

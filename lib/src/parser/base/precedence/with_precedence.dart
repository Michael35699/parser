import "package:parser/internal_all.dart";

class WithPrecedenceParser extends WrapParser {
  final num precedence;
  @override
  Parser get parser => children[0];

  WithPrecedenceParser(this.precedence, Parser parser) : super(<Parser>[parser]);
  WithPrecedenceParser.empty(this.precedence) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    num searchPrecedence = context.state.precedence;
    if (searchPrecedence < precedence) {
      return context.failure("Search precedence '$searchPrecedence' is lower than '$precedence'");
    }

    return parser.pegApply(context, mutable);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, Continuation continuation) {
    num searchPrecedence = context.state.precedence;
    if (searchPrecedence < precedence) {
      return continuation(context.failure("Search precedence '$searchPrecedence' is lower than '$precedence'"));
    }

    return trampoline.push(parser, context, continuation);
  }

  @override
  Parser get base => parser.base;

  @override
  WithPrecedenceParser empty() => WithPrecedenceParser.empty(precedence);

  @override
  bool hasEqualProperties(WithPrecedenceParser target) =>
      super.hasEqualProperties(target) && target.precedence == precedence;
}

WithPrecedenceParser withPrecedence(num precedence, Parser parser) => WithPrecedenceParser(precedence, parser);

extension WithPrecedenceExtension on Parser {
  WithPrecedenceParser withPrecedence(num precedence) => WithPrecedenceParser(precedence, this);
}

extension LazyWithPrecedenceExtension on LazyParser {
  WithPrecedenceParser withPrecedence(num precedence) => this.$.withPrecedence(precedence);
}

extension StringWithPrecedenceExtension on String {
  WithPrecedenceParser withPrecedence(num precedence) => this.$.withPrecedence(precedence);
}

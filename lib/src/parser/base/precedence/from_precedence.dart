import "package:parser/internal_all.dart";

class FromPrecedenceParser extends WrapParser {
  final num precedence;
  @override
  Parser get parser => children[0];

  FromPrecedenceParser(this.precedence, Parser parser) : super(<Parser>[parser]);
  FromPrecedenceParser.empty(this.precedence) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    num previousPrecedence = context.state.precedence;
    Context ctx = parser.pegApply(context.copyWith.state(precedence: precedence), mutable);

    return ctx.copyWith.state(precedence: previousPrecedence);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    num previousPrecedence = context.state.precedence;

    trampoline.push(parser, context.copyWith.state(precedence: precedence), (Context context) {
      continuation(context.copyWith.state(precedence: previousPrecedence));
    });
  }

  @override
  Parser get base => parser.base;

  @override
  FromPrecedenceParser empty() => FromPrecedenceParser.empty(precedence);

  @override
  bool hasEqualProperties(FromPrecedenceParser target) =>
      super.hasEqualProperties(target) && target.precedence == precedence;
}

FromPrecedenceParser fromPrecedence(num precedence, Parser parser) => FromPrecedenceParser(precedence, parser);

extension PrecedenceParserExtension on Parser {
  FromPrecedenceParser prec(num precedence) => FromPrecedenceParser(precedence, this);
  FromPrecedenceParser from(num precedence) => FromPrecedenceParser(precedence, this);
  FromPrecedenceParser fromPrecedence(num precedence) => FromPrecedenceParser(precedence, this);
  FromPrecedenceParser operator [](num precedence) => fromPrecedence(precedence);
}

extension LazyPrecedenceParserExtension on LazyParser {
  FromPrecedenceParser prec(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser from(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser fromPrecedence(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser operator [](num precedence) => this.$[precedence];
}

extension StringPrecedenceParserExtension on String {
  FromPrecedenceParser prec(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser from(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser fromPrecedence(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser operator [](num precedence) => this.$[precedence];
}

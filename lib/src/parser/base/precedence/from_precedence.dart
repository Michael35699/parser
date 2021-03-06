import "package:parser/internal_all.dart";

class FromPrecedenceParser extends WrapParser {
  final num precedence;
  @override
  Parser get parser => children[0];

  FromPrecedenceParser(this.precedence, Parser parser) : super(<Parser>[parser]);
  FromPrecedenceParser.empty(this.precedence) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    num previousPrecedence = context.state.precedence;
    Context ctx = handler.apply(parser, context.copyWith.state(precedence: precedence));

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
  FromPrecedenceParser empty() => FromPrecedenceParser.empty(precedence);

  @override
  bool hasEqualProperties(FromPrecedenceParser target) =>
      super.hasEqualProperties(target) && target.precedence == precedence;
}

FromPrecedenceParser fromPrecedenceParser(num precedence, Parser parser) => FromPrecedenceParser(precedence, parser);
FromPrecedenceParser fromPrecedence(num precedence, Object parser) => fromPrecedenceParser(precedence, parser.$);

extension ParserPrecedenceExtension on Parser {
  FromPrecedenceParser prec(num precedence) => FromPrecedenceParser(precedence, this);
  FromPrecedenceParser from(num precedence) => FromPrecedenceParser(precedence, this);
  FromPrecedenceParser fromPrecedence(num precedence) => FromPrecedenceParser(precedence, this);
  FromPrecedenceParser operator [](num precedence) => fromPrecedence(precedence);
}

extension LazyParserPrecedenceExtension on LazyParser {
  FromPrecedenceParser prec(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser from(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser fromPrecedence(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser operator [](num precedence) => this.$[precedence];
}

extension StringPrecedenceExtension on String {
  FromPrecedenceParser prec(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser from(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser fromPrecedence(num precedence) => this.$.fromPrecedence(precedence);
  FromPrecedenceParser operator [](num precedence) => this.$[precedence];
}

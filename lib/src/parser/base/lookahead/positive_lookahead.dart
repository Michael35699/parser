import "package:parser_peg/internal_all.dart";

// @no-doc

class PositiveLookaheadParser extends WrapParser {
  Parser get parser => children[0];

  PositiveLookaheadParser(Parser parser) : super(<Parser>[parser]);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    if (parser.parseCtx(context, handler) is! ContextFailure) {
      return context.success(#positiveLookahead);
    } else {
      return context.failure("Positive lookahead failure.");
    }
  }

  @override
  PositiveLookaheadParser cloneSelf() => PositiveLookaheadParser(parser);

  @override
  Parser get base => parser.base;
}

PositiveLookaheadParser and(Parser parser) => PositiveLookaheadParser(parser);
PositiveLookaheadParser positiveLookahead(Parser parser) => PositiveLookaheadParser(parser);

extension PositiveLookaheadExtension on Parser {
  PositiveLookaheadParser positiveLookahead() => PositiveLookaheadParser(this);
  PositiveLookaheadParser and() => positiveLookahead();
}

extension PositiveLookaheadExtension2 on NegativeLookaheadParser {
  PositiveLookaheadParser operator ~() => parser.positiveLookahead();
}

extension LazyPositiveLookaheadExtension on LazyParser {
  PositiveLookaheadParser positiveLookahead() => this.$.positiveLookahead();
  PositiveLookaheadParser and() => this.$.and();
}

extension StringPositiveLookaheadExtension on String {
  PositiveLookaheadParser positiveLookahead() => this.$.positiveLookahead();
  PositiveLookaheadParser and() => this.$.and();
}

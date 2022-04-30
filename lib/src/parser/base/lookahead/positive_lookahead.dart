import "package:parser/internal_all.dart";

class PositiveLookaheadParser extends WrapParser {
  @override
  Parser get parser => children[0];

  PositiveLookaheadParser(Parser parser) : super(<Parser>[parser]);
  PositiveLookaheadParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    if (parser.pegApply(context, mutable) is! ContextFailure) {
      return context.success(#positiveLookahead);
    } else {
      return context.failure("Positive lookahead failure.");
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is! ContextFailure) {
        continuation(context.success(#positiveLookahead));
      } else {
        continuation(context.failure("Positive lookahead failure."));
      }
    });
  }

  @override
  Parser get base => parser.base;

  @override
  PositiveLookaheadParser empty() => PositiveLookaheadParser.empty();
}

PositiveLookaheadParser and(Parser parser) => PositiveLookaheadParser(parser);
PositiveLookaheadParser positiveLookahead(Parser parser) => PositiveLookaheadParser(parser);

extension ParserPositiveLookaheadExtension on Parser {
  PositiveLookaheadParser positiveLookahead() => PositiveLookaheadParser(this);
  PositiveLookaheadParser and() => positiveLookahead();
}

extension ParserPositiveLookaheadExtension2 on NegativeLookaheadParser {
  PositiveLookaheadParser operator ~() => parser.positiveLookahead();
}

extension LazyParserPositiveLookaheadExtension on LazyParser {
  PositiveLookaheadParser positiveLookahead() => this.$.positiveLookahead();
  PositiveLookaheadParser and() => this.$.and();
}

extension StringPositiveLookaheadExtension on String {
  PositiveLookaheadParser positiveLookahead() => this.$.positiveLookahead();
  PositiveLookaheadParser and() => this.$.and();
}

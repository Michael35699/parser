import "package:parser/internal_all.dart";

class NegativeLookaheadParser extends WrapParser {
  @override
  Parser get parser => children[0];

  NegativeLookaheadParser(Parser parser) : super(<Parser>[parser]);
  NegativeLookaheadParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    if (parser.pegApply(context, mutable) is! ContextFailure) {
      return context.failure("Negative lookahead failure.");
    } else {
      return context.success(#negativeLookahead);
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is! ContextFailure) {
        continuation(context.failure("Negative lookahead failure."));
      } else {
        continuation(context.success(#negativeLookahead));
      }
    });
  }

  @override
  Parser get base => parser.base;

  @override
  NegativeLookaheadParser empty() => NegativeLookaheadParser.empty();
}

NegativeLookaheadParser negativeLookahead(Parser parser) => NegativeLookaheadParser(parser);
NegativeLookaheadParser not(Parser parser) => NegativeLookaheadParser(parser);

extension NegativeLookaheadExtension on Parser {
  NegativeLookaheadParser negativeLookahead() => NegativeLookaheadParser(this);
  NegativeLookaheadParser not() => negativeLookahead();
  NegativeLookaheadParser operator ~() => negativeLookahead();
}

extension LazyNegativeLookaheadExtension on LazyParser {
  NegativeLookaheadParser negativeLookahead() => this.$.negativeLookahead();
  NegativeLookaheadParser not() => this.$.not();
  NegativeLookaheadParser operator ~() => ~this.$;
}

extension StringNegativeLookaheadExtension on String {
  NegativeLookaheadParser negativeLookahead() => this.$.negativeLookahead();
  NegativeLookaheadParser not() => this.$.not();
  NegativeLookaheadParser operator ~() => ~this.$;
}

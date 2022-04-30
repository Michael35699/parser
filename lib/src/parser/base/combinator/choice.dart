import "package:parser/internal_all.dart";

class ChoiceParser extends CombinatorParser {
  ChoiceParser(List<Parser> parsers) : super(parsers);

  ContextFailure determineFailure(ContextFailure ctx, ContextFailure? longestError) {
    if (longestError == null) {
      return ctx;
    }
    const String memoError = "seed";

    if (ctx.message == memoError) {
      return longestError;
    } else if (longestError.message == memoError) {
      return ctx;
    }

    if (ctx.artificial ^ longestError.artificial) {
      return ctx.artificial ? ctx : longestError;
    }

    return ctx.state.index > longestError.state.index ? ctx : longestError;
  }

  Context determineSuccess(Context ctx, Context? longest) {
    if (longest == null) {
      return ctx;
    }

    return ctx.state.index > longest.state.index ? ctx : longest;
  }

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    ContextFailure? longestError;
    Context? longestSuccess;
    for (Parser parser in children) {
      Context ctx = parser.pegApply(context, mutable);

      if (ctx is ContextFailure) {
        longestError = determineFailure(ctx, longestError);
      } else {
        longestSuccess = determineSuccess(ctx, longestSuccess);
      }
    }

    return longestSuccess ?? longestError!;
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    for (Parser parser in children) {
      trampoline.push(parser, context, continuation);
    }
  }

  @override
  ChoiceParser empty() => ChoiceParser(<Parser>[]);
}

extension ParserChoiceExtension on Parser {
  ChoiceParser or(Object other) => ((Parser self) => ((Parser other) => ChoiceParser(<Parser>[
        if (self is ChoiceParser) ...self.children else self,
        if (other is ChoiceParser) ...other.children else other,
      ]))(other.$))(this);
  ChoiceParser operator |(Object other) => or(other);
  ChoiceParser operator /(Object other) => or(other);
}

extension LazyParserChoiceExtension on LazyParser {
  ChoiceParser or(Object other) => this.$.or(other);
  ChoiceParser operator |(Object other) => this.$ | other;
  ChoiceParser operator /(Object other) => this.$ / other;
}

extension StringChoiceExtension on String {
  ChoiceParser or(Object other) => this.$.or(other);
  ChoiceParser operator |(Object other) => this.$ | other;
  ChoiceParser operator /(Object other) => this.$ / other;
}

extension IterableChoiceExtension on Iterable<Parser> {
  ChoiceParser choiceParser() => ChoiceParser(toList());
}

ChoiceParser choice(List<Parser> parsers) => ChoiceParser(parsers);
ChoiceParser either(Object start) => ChoiceParser(<Parser>[start.$]);

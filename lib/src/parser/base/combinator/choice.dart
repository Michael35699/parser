import "package:parser/internal_all.dart";

class ChoiceParser extends CombinatorParser {
  ChoiceParser(List<Parser> parsers) : super(parsers);

  ContextFailure determineContext(ContextFailure ctx, ContextFailure? longestError) {
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

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    ContextFailure? longestError;

    for (Parser parser in children) {
      Context ctx = parser.pegApply(context, mutable);

      if (ctx is ContextFailure) {
        longestError = determineContext(ctx, longestError);
      } else {
        return ctx;
      }
    }

    return longestError!;
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

extension ChoiceExtension on Parser {
  ChoiceParser or(Object other) => ((Parser self) => ((Parser other) => ChoiceParser(<Parser>[
        if (self is ChoiceParser) ...self.children else self,
        if (other is ChoiceParser) ...other.children else other,
      ]))(other.$))(this);
  ChoiceParser operator |(Object other) => or(other);
  ChoiceParser operator /(Object other) => or(other);
}

extension LazyChoiceExtension on LazyParser {
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

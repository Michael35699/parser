import "package:parser_peg/internal_all.dart";

class ChoiceParser extends CombinatorParser {
  ChoiceParser(List<Parser> parsers) : super(parsers);

  ContextFailure determineContext(ContextFailure ctx, ContextFailure? longestError) {
    if (longestError == null) {
      return ctx;
    }
    const String memoError = "Memoization seed. If this is seen, then "
        "it means that there is probably a mistake in the grammar.";

    if (ctx.message == memoError) {
      return longestError;
    } else if (longestError.message == memoError) {
      return ctx;
    }
    return ctx.state.index > longestError.state.index ? ctx : longestError;
  }

  @override
  Context parse(Context context, ParserEngine engine) {
    ContextFailure? longestError;

    for (Parser parser in children) {
      Context ctx = engine.apply(parser, context);

      if (ctx is ContextFailure) {
        longestError = determineContext(ctx, longestError);
      } else {
        return ctx;
      }
    }

    return longestError!;
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

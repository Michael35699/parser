import "package:parser_peg/internal_all.dart";

class ChoiceParser extends CombinatorParserMixin {
  ChoiceParser(List<Parser> parsers) : super(parsers);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    Context? longestError;

    for (int i = 0; i < children.length; i++) {
      Context ctx = children[i].parseCtx(context, handler);

      if (ctx.isFailure) {
        longestError = ctx.state.index > (longestError?.state.index ?? -1) ? ctx : longestError;
      } else {
        return ctx;
      }
    }

    return longestError!;
  }

  @override
  ChoiceParser cloneSelf() => ChoiceParser(<Parser>[...children]);
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

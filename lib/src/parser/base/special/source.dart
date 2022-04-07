import "package:parser_peg/internal_all.dart";

class SourceParser extends SpecialParserMixin {
  @override
  Context parse(Context context, MemoizationHandler handler) {
    if (context.state.index >= context.state.input.length) {
      return context.failure("Expected any character, received end of input");
    }

    return context.advance(1).success(context.state.input[context.state.index]);
  }
}

final SourceParser source = SourceParser();

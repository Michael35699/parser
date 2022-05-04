import "package:parser/internal_all.dart";

class SourceParser extends SpecialParser {
  static final SourceParser singleton = SourceParser._();

  factory SourceParser() => singleton;
  SourceParser._();

  @override
  Context parsePeg(Context context, PegHandler handler) {
    if (context.state.index >= context.state.input.length) {
      return context.failure("Expected any character, received end of input");
    }

    return context.advance(1).success(context.state.input[context.state.index]);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    if (context.state.index >= context.state.input.length) {
      continuation(context.failure("Expected any character, received end of input"));
    } else {
      continuation(context.advance(1).success(context.state.input[context.state.index]));
    }
  }
}

SourceParser source() => SourceParser();

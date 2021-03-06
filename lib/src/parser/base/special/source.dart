import "package:parser/internal_all.dart";

class SourceParser extends SpecialParser {
  static final SourceParser singleton = SourceParser._();

  factory SourceParser() => singleton;
  SourceParser._();

  @override
  Context parsePure(Context context) {
    if (context.state.index >= context.state.buffer.length) {
      return context.failure("Expected any character, received end of input");
    }

    return context.advance(1).success(context.state.buffer[context.state.index]);
  }
}

SourceParser any() => SourceParser();
SourceParser source() => SourceParser();

import "package:parser/internal_all.dart";

class EoiParser extends SpecialParser {
  static final EoiParser singleton = EoiParser._();

  factory EoiParser() => singleton;
  EoiParser._();

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    if (context.state.index >= context.state.input.length) {
      return context.success(#eoi);
    }

    return context.failure(expected("end of input"));
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    if (context.state.index >= context.state.input.length) {
      continuation(context.success(#eoi));
    } else {
      continuation(context.failure(expected("end of input")));
    }
  }

  @override
  String toString() => r"$";
}

EoiParser dollar() => EoiParser();
EoiParser eoi() => EoiParser();
EoiParser end() => EoiParser();

extension ParserEoiExtension on Parser {
  Parser end() => this << eoi();
}

extension LazyParserEoiExtension on Lazy<Parser> {
  Parser end() => this.$ << eoi();
}

extension StringEoiExtension on String {
  Parser end() => this.$ << eoi();
}

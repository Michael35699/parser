import "package:parser_peg/internal_all.dart";

class EoiParser extends SpecialParser {
  static final EoiParser singleton = EoiParser._();

  factory EoiParser() => singleton;
  EoiParser._();

  @override
  Context parse(Context context) {
    if (context.state.index >= context.state.input.length) {
      return context.success(#eoi);
    }

    return context.failure(expected("end of input"));
  }

  @override
  String toString() => r"$";
}

EoiParser dollar() => EoiParser();
EoiParser eoi() => EoiParser();
EoiParser end() => EoiParser();

extension EoiExtension on Parser {
  Parser end() => this << eoi;
}

extension LazyEoiExtension on Lazy<Parser> {
  Parser end() => this.$ << eoi;
}

extension StringEoiExtension on String {
  Parser end() => this.$ << eoi;
}

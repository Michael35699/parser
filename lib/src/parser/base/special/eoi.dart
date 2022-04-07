import "package:parser_peg/internal_all.dart";

class EoiParser extends SpecialParserMixin {
  @override
  Context parse(Context context, MemoizationHandler handler) {
    if (context.state.index >= context.state.input.length) {
      return context.success(#eoi);
    }

    return context.failure(expected("end of input"));
  }
}

final Parser eoi = EoiParser();
final Parser end = EoiParser();

extension EoiExtension on Parser {
  Parser end() => this << eoi;
}

extension LazyEoiExtension on Lazy<Parser> {
  Parser end() => this.$ << eoi;
}

extension StringEoiExtension on String {
  Parser end() => this.$ << eoi;
}

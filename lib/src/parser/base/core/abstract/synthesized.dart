import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class SynthesizedParser extends Parser {
  @override
  final List<Parser> children;
  abstract final Parser synthesized;

  SynthesizedParser(this.children);

  @nonVirtual
  @override
  Context parse(Context context, MemoizationHandler handler) => synthesized.parseCtx(context, handler);

  @override
  Parser get base => synthesized;
}

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

abstract class SynthesizedParser extends Parser {
  @override
  final List<Parser> children;
  abstract Parser synthesized;

  SynthesizedParser(this.children);

  @nonVirtual
  @override
  Context parse(Context context, MemoizationHandler handler) => synthesized.parseCtx(context, handler);

  @override
  void replace<T extends Parser>(ParserPredicate target, TransformHandler<T> result) {
    super.replace(target, result);

    synthesized = synthesized.applyTransformation(target, result);
    for (int i = 0; i < children.length; i++) {
      children[i] = children[i].applyTransformation(target, result);
    }
  }

  @override
  Parser get base => synthesized;
}

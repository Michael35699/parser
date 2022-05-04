import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";

abstract class SpecialParser extends ChildlessParser {
  @nonVirtual
  @override
  Context parsePeg(Context context, PegHandler handler) => parsePure(context);

  @nonVirtual
  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) =>
      continuation(parsePure(context));

  Context parsePure(Context context);
}

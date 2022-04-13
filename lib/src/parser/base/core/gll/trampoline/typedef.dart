import "package:parser/internal_all.dart";

typedef GllContinuation = void Function(Context);
typedef GllParseFunction = void Function(Context, Trampoline, GllContinuation);

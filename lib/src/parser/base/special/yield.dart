import "package:parser_peg/internal_all.dart";

typedef ProcessYield = T Function<T extends Object?>(Object);
typedef ProcessFunction = dynamic Function(ProcessYield);

class ProcessParser extends SpecialParserMixin {
  @override
  bool get memoize => false;

  final ProcessFunction callback;

  ProcessParser(this.callback);

  @override
  Context parse(Context context, MemoizationHandler handler) {
    Context ctx = context;
    List<ParseResult> unmapped = <ParseResult>[];
    T completer<T extends Object?>(Object parser) {
      ctx = Parser.resolve(parser).parseCtx(ctx, handler);

      return ctx.map<T>(
        success: (ContextSuccess context) {
          unmapped.add(context.unmappedResult);

          return context.mappedResult as T;
        },
        failure: (ContextFailure context) {
          throw ContextException(context);
        },
        ignore: (ContextIgnore context) {
          if (null is T) {
            return null as T;
          }

          throw UnsupportedError("Ignore parser used in run");
        },
      );
    }

    try {
      ParseResult mapped = callback(completer);

      return ctx.success(mapped, unmapped);
    } on ContextException catch (e) {
      return e.context;
    }
  }
}

ProcessParser process(ProcessFunction fn) => ProcessParser(fn);

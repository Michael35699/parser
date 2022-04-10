import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";

@optionalTypeArgs
class ParserTransformStream<T extends Parser, P extends Parser> {
  final List<Function> handlers;
  final T target;

  const ParserTransformStream(this.target, [this.handlers = const <Function>[]]);

  ParserTransformStream<T, R> map<R extends Parser>(GenericTransformHandler<R, P> handler) =>
      ParserTransformStream(target, <Function>[...handlers, handler]);

  ParserTransformStream<T, P> where(ParserPredicate<P> predicate) =>
      ParserTransformStream(target, <Function>[...handlers, predicate]);

  ParserTransformStream<T, R> cast<R extends Parser>() =>
      ParserTransformStream(target, <Function>[...handlers, (Parser p) => p as R]);

  ParserTransformStream<T, R> whereType<R extends Parser>([TransformHandler<R>? predicate]) =>
      ParserTransformStream(target, <Function>[
        ...handlers,
        if (predicate != null) (Parser p) => p is R ? predicate(p) : p else (Parser p) => p is R
      ]);

  T run() => target.transform((Parser p) {
        Parser parser = p;
        for (Function handler in handlers) {
          if (handler is ParserPredicate) {
            if (!handler(parser)) {
              break;
            }
          } else {
            parser = Function.apply(handler, <Parser>[parser]) as Parser;
          }
        }

        return parser;
      });
}

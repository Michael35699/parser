import "package:parser/internal_all.dart";

typedef Lazy<T> = T Function();
typedef FunctorFunction<R> = R Function(ParseResult, Context);
typedef ParserFunction<R, T extends Parser> = R Function(T);

typedef LazyParser = Lazy<Parser>;
typedef MapFunction = FunctorFunction<ParseResult>;
typedef FlatMapFunction = FunctorFunction<Context>;
typedef BindFunction = FunctorFunction<Parser>;
typedef FilterFunction = FunctorFunction<bool>;
typedef ParseFunction = Context Function(Context);
typedef ContinuationFunction = Context Function(ParseFunction, Context);
typedef ParserPredicate<T extends Parser> = ParserFunction<bool, T>;
typedef TransformHandler<T extends Parser> = ParserFunction<Parser, T>;
typedef NullableTransformHandler<T extends Parser> = ParserFunction<Parser?, T>;
typedef GenericTransformHandler<R extends Parser, T extends Parser> = ParserFunction<R, T>;

typedef ParseResult = Object?;

typedef ParserSet = Set<Parser>;
typedef ParserSetMapping = Map<Parser, ParserSet>;

typedef ExceptFunction<R> = R Function(ContextFailure);

typedef ParserCacheMap = Expando<Parser>;

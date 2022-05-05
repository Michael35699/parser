import "package:parser/internal_all.dart";

typedef Lazy<T> = T Function();
typedef LazyParser = Lazy<Parser>;
typedef MapFunction = ParseResult Function(ParseResult, Context);
typedef FlatMapFunction = Context Function(ParseResult, Context);
typedef BindFunction = Parser Function(ParseResult, Context);
typedef FilterFunction = bool Function(ParseResult, Context);

typedef ParseFunction = Context Function(Context);
typedef ContinuationFunction = Context Function(ParseFunction, Context);

typedef ParserFunction<R, T extends Parser> = R Function(T);
typedef ParserPredicate<T extends Parser> = ParserFunction<bool, T>;
typedef TransformHandler<T extends Parser> = ParserFunction<Parser, T>;
typedef NullableTransformHandler<T extends Parser> = ParserFunction<Parser?, T>;
typedef GenericTransformHandler<R extends Parser, T extends Parser> = ParserFunction<R, T>;

typedef ParseResult = Object?;

typedef ParserSet = Set<Parser>;
typedef ParserSetMapping = Map<Parser, ParserSet>;

typedef ExceptFunction<R> = R Function(ContextFailure);
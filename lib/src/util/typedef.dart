// ignore_for_file: camel_case_types

import "package:parser_peg/internal_all.dart";

typedef Lazy<T> = T Function();
typedef LazyParser = Lazy<Parser>;
typedef MapFunction = ParseResult Function(ParseResult, Context);

typedef ParseFunction = Context Function(Context);
typedef ContinuationFunction = Context Function(ParseFunction, Context);
typedef ParserPredicate = bool Function(Parser);
typedef TransformHandler<T extends Parser> = Parser Function(T);

typedef ParseResult = Object?;

typedef Rule = Parser;
typedef Fragment = Parser;
typedef Terminal = Parser;

typedef ParserSet = Set<Parser>;
typedef ParserSetMapping = Map<Parser, ParserSet>;

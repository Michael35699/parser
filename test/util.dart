// ignore_for_file: always_specify_types

import "package:parser/parser.dart" as parser;
import "package:test/test.dart";

Matcher contextSuccess({dynamic index = anything, dynamic result = anything}) => isA<parser.ContextSuccess>()
    .having((c) => c.state.index, "index", index)
    .having((c) => c.mappedResult, "result", result);
Matcher contextFailure({dynamic index = anything, dynamic message = anything}) => isA<parser.ContextFailure>()
    .having((c) => c.state.index, "index", index)
    .having((c) => c.message, "message", message);
Matcher contextEmpty({dynamic index = anything, dynamic message = anything}) => isA<parser.ContextEmpty>() //
    .having((c) => c.state.index, "index", index);

Matcher parserSuccess(String input, dynamic res, {dynamic index = anything}) => isA<parser.Parser>()
    .having((p) => p.pegCtx.pure(input), "peg_pure", contextSuccess(index: index, result: res))
    .having((p) => p.pegCtx.left(input), "peg_left", contextSuccess(index: index, result: res))
    .having((p) => p.packratCtx.basic(input), "packrat_basic", contextSuccess(index: index, result: res))
    .having((p) => p.packratCtx.linear(input), "packrat_linear", contextSuccess(index: index, result: res))
    .having((p) => p.packratCtx.quadratic(input), "packrat_quadratic", contextSuccess(index: index, result: res))
    .having((p) => p.gllCtx(input).first, "gll", contextSuccess(index: index, result: res));

Matcher parserFailure(String input, {dynamic index = anything, dynamic message = anything}) => isA<parser.Parser>()
    .having((p) => p.pegCtx.pure(input), "peg_pure", contextFailure(index: index, message: message))
    .having((p) => p.pegCtx.left(input), "peg_left", contextFailure(index: index, message: message))
    .having((p) => p.packratCtx.basic(input), "packrat_basic", contextFailure(index: index, message: message))
    .having((p) => p.packratCtx.linear(input), "packrat_linear", contextFailure(index: index, message: message))
    .having((p) => p.packratCtx.quadratic(input), "packrat_quadratic", contextFailure(index: index, message: message))
    .having((p) => p.gllCtx(input).first, "gll", contextFailure(index: index, message: message));

Matcher parserEmpty(String input, {dynamic index = anything}) => isA<parser.Parser>()
    .having((p) => p.pegCtx.pure(input), "peg_pure", contextEmpty(index: index))
    .having((p) => p.pegCtx.left(input), "peg_left", contextEmpty(index: index))
    .having((p) => p.packratCtx.basic(input), "packrat_basic", contextEmpty(index: index))
    .having((p) => p.packratCtx.linear(input), "packrat_linear", contextEmpty(index: index))
    .having((p) => p.packratCtx.quadratic(input), "packrat_quadratic", contextEmpty(index: index))
    .having((p) => p.gllCtx(input).first, "gll", contextEmpty(index: index));

const List<Object?> emptyList = <Object?>[];

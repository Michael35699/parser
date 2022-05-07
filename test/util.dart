// ignore_for_file: always_specify_types

import "package:parser/parser.dart" as parser;
import "package:test/test.dart";

Matcher contextSuccess({dynamic i = anything, dynamic result = anything}) => isA<parser.ContextSuccess>()
    .having((c) => c.state.index, "index", i)
    .having((c) => c.mappedResult, "result", result);
Matcher contextFailure({dynamic i = anything, dynamic message = anything}) => isA<parser.ContextFailure>() //
    .having((c) => c.state.index, "index", i)
    .having((c) => c.message, "message", message);
Matcher contextEmpty({dynamic i = anything, dynamic message = anything}) => isA<parser.ContextEmpty>() //
    .having((c) => c.state.index, "index", i);

Matcher parserSuccess(String input, dynamic res, {dynamic i = anything}) => isA<parser.Parser>()
        .having((p) => p.pegCtx.pure(input), "peg_pure", contextSuccess(i: i, result: res))
        .having((p) => p.pegCtx.left(input), "peg_left", contextSuccess(i: i, result: res))
        .having((p) => p.packratCtx.basic(input), "packrat_basic", contextSuccess(i: i, result: res))
        .having((p) => p.packratCtx.linear(input), "packrat_linear", contextSuccess(i: i, result: res))
        .having((p) => p.packratCtx.quadratic(input), "packrat_quadratic", contextSuccess(i: i, result: res))
    // .having((p) => p.gllCtx(input).first, "gll", contextSuccess(i: i, result: res))
    ;

Matcher parserFailure(String input, {dynamic i = anything, dynamic message = anything}) => isA<parser.Parser>()
        .having((p) => p.pegCtx.pure(input), "peg_pure", contextFailure(i: i, message: message))
        .having((p) => p.pegCtx.left(input), "peg_left", contextFailure(i: i, message: message))
        .having((p) => p.packratCtx.basic(input), "packrat_basic", contextFailure(i: i, message: message))
        .having((p) => p.packratCtx.linear(input), "packrat_linear", contextFailure(i: i, message: message))
        .having((p) => p.packratCtx.quadratic(input), "packrat_quadratic", contextFailure(i: i, message: message))
    // .having((p) => p.gllCtx(input).first, "gll", contextFailure(i: i, message: message))
    ;

Matcher parserEmpty(String input, {dynamic i = anything}) => isA<parser.Parser>()
        .having((p) => p.pegCtx.pure(input), "peg_pure", contextEmpty(i: i))
        .having((p) => p.pegCtx.left(input), "peg_left", contextEmpty(i: i))
        .having((p) => p.packratCtx.basic(input), "packrat_basic", contextEmpty(i: i))
        .having((p) => p.packratCtx.linear(input), "packrat_linear", contextEmpty(i: i))
        .having((p) => p.packratCtx.quadratic(input), "packrat_quadratic", contextEmpty(i: i))
    // .having((p) => p.gllCtx(input).first, "gll", contextEmpty(i: i))
    ;

const List<Object?> emptyList = <Object?>[];

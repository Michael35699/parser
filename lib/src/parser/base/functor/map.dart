// ignore_for_file: avoid_dynamic_calls, avoid_catching_errors

import "package:parser/internal_all.dart";

class MappedParser extends WrapParser {
  final MapFunction mapper;
  final bool replaceResult;

  @override
  Parser get parser => children[0];

  MappedParser(Parser parser, this.mapper, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[parser]);
  MappedParser.empty(this.mapper, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);

    if (ctx is ContextSuccess) {
      ParseResult mappedResult = mapper(ctx.mappedResult, ctx);
      ParseResult unmappedResult = replaceResult ? mapper(ctx.unmappedResult, ctx) : ctx.unmappedResult;

      return ctx.success(mappedResult, unmappedResult);
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextSuccess) {
        ParseResult mappedResult = mapper(ctx.mappedResult, ctx);
        ParseResult unmappedResult = replaceResult ? mapper(ctx.unmappedResult, ctx) : ctx.unmappedResult;

        continuation(ctx.success(mappedResult, unmappedResult));
      } else {
        continuation(ctx);
      }
    });
  }

  @override
  MappedParser empty() => MappedParser.empty(mapper, replace: replaceResult);

  @override
  bool hasEqualProperties(MappedParser target) =>
      super.hasEqualProperties(target) && target.mapper == mapper && target.replaceResult == replaceResult;
}

MappedParser mappedParser(Parser parser, MapFunction mapper, {bool replace = false}) =>
    MappedParser(parser, mapper, replace: replace);
MappedParser mapped(Object parser, MapFunction mapper, {bool replace = false}) =>
    mappedParser(parser.$, mapper, replace: replace);

extension ParserMappedExtension on Parser {
  MappedParser map(MapFunction mapper, {bool replace = false}) => mappedParser(this, mapper, replace: replace);

  MappedParser operator ^(MapFunction mapper) => map(mapper);
}

extension LazyParserMappedExtension on LazyParser {
  MappedParser map(MapFunction mapper, {bool replace = false}) => this.$.map(mapper, replace: replace);

  MappedParser operator ^(MapFunction mapper) => this.$ ^ mapper;
}

extension StringMappedExtension on String {
  MappedParser map(MapFunction mapper, {bool replace = false}) => this.$.map(mapper, replace: replace);

  MappedParser operator ^(MapFunction mapper) => this.$ ^ mapper;
}

extension ExtendedMapFunctionExtension on MappedParser Function(MapFunction mapper, {bool replace}) {
  MappedParser replace(MapFunction mapper) => this(mapper, replace: true);
}

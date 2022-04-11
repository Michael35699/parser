// ignore_for_file: avoid_dynamic_calls, avoid_catching_errors

import "package:parser_peg/internal_all.dart";

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
  Context parse(Context context, ParserEngine engine) {
    Context ctx = parser.apply(context, engine);

    if (ctx is ContextSuccess) {
      ParseResult mappedResult = replaceResult || ctx.state.map ? mapper(ctx.mappedResult, ctx) : ctx.mappedResult;
      ParseResult unmappedResult = replaceResult ? mapper(ctx.unmappedResult, ctx) : ctx.unmappedResult;

      return ctx.success(mappedResult, unmappedResult);
    } else {
      return ctx;
    }
  }

  @override
  Parser get base => parser.base;

  @override
  MappedParser empty() => MappedParser.empty(mapper, replace: replaceResult);

  @override
  bool hasEqualProperties(MappedParser target) =>
      super.hasEqualProperties(target) && target.mapper == mapper && target.replaceResult == replaceResult;
}

MappedParser mapped(Parser parser, MapFunction mapper, {bool replace = false}) =>
    MappedParser(parser, mapper, replace: replace);

extension MappedExtension on Parser {
  MappedParser map(MapFunction mapper, {bool replace = false}) => mapped(this, mapper, replace: replace);

  MappedParser operator ^(MapFunction mapper) => map(mapper);
}

extension LazyMappedExtension on LazyParser {
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

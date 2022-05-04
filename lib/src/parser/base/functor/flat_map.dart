// ignore_for_file: avoid_dynamic_calls, avoid_catching_errors

import "package:parser/internal_all.dart";

class FlatMappedParser extends WrapParser {
  final FlatMapFunction flatMapper;
  final bool replaceResult;

  @override
  Parser get parser => children[0];

  FlatMappedParser(Parser parser, this.flatMapper, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[parser]);
  FlatMappedParser.empty(this.flatMapper, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context ctx = parser.pegApply(context, mutable);

    if (ctx is ContextSuccess) {
      return flatMapper(ctx.mappedResult, ctx);
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextSuccess) {
        continuation(flatMapper(ctx.mappedResult, ctx));
      } else {
        continuation(ctx);
      }
    });
  }

  @override
  Parser get base => parser.base;

  @override
  FlatMappedParser empty() => FlatMappedParser.empty(flatMapper, replace: replaceResult);

  @override
  bool hasEqualProperties(FlatMappedParser target) =>
      super.hasEqualProperties(target) && target.flatMapper == flatMapper && target.replaceResult == replaceResult;
}

FlatMappedParser flatMapped(Parser parser, FlatMapFunction flatMapper, {bool replace = false}) =>
    FlatMappedParser(parser, flatMapper, replace: replace);

extension ParserFlatMappedExtension on Parser {
  FlatMappedParser flatMap(FlatMapFunction flatMapper, {bool replace = false}) =>
      flatMapped(this, flatMapper, replace: replace);
}

extension LazyParserFlatMappedExtension on LazyParser {
  FlatMappedParser flatMap(FlatMapFunction flatMapper, {bool replace = false}) =>
      this.$.flatMap(flatMapper, replace: replace);
}

extension StringFlatMappedExtension on String {
  FlatMappedParser flatMap(FlatMapFunction flatMapper, {bool replace = false}) =>
      this.$.flatMap(flatMapper, replace: replace);
}

extension ExtendedFlatMapFunctionExtension on FlatMappedParser Function(FlatMapFunction flatMapper, {bool replace}) {
  FlatMappedParser replace(FlatMapFunction flatMapper) => this(flatMapper, replace: true);
}

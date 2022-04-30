// ignore_for_file: avoid_dynamic_calls, avoid_catching_errors

import "package:parser/internal_all.dart";

class BoundParser extends WrapParser {
  final BindFunction binder;
  final bool replaceResult;

  @override
  Parser get parser => children[0];

  BoundParser(Parser parser, this.binder, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[parser]);
  BoundParser.empty(this.binder, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context ctx = parser.pegApply(context, mutable);

    if (ctx is ContextSuccess) {
      return binder(ctx.mappedResult, ctx).pegApply(ctx, mutable);
    } else {
      return ctx;
    }
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextSuccess) {
        trampoline.push(binder(ctx.mappedResult, ctx), ctx, continuation);
      } else {
        continuation(ctx);
      }
    });
  }

  @override
  Parser get base => parser.base;

  @override
  BoundParser empty() => BoundParser.empty(binder, replace: replaceResult);

  @override
  bool hasEqualProperties(BoundParser target) =>
      super.hasEqualProperties(target) && target.binder == binder && target.replaceResult == replaceResult;
}

BoundParser bound(Parser parser, BindFunction binder, {bool replace = false}) =>
    BoundParser(parser, binder, replace: replace);

extension ParserBoundExtension on Parser {
  BoundParser bind(BindFunction binder, {bool replace = false}) => bound(this, binder, replace: replace);
}

extension LazyParserBoundExtension on LazyParser {
  BoundParser bind(BindFunction binder, {bool replace = false}) => this.$.bind(binder, replace: replace);
}

extension StringBoundExtension on String {
  BoundParser bind(BindFunction binder, {bool replace = false}) => this.$.bind(binder, replace: replace);
}

extension ExtendedBindFunctionExtension on BoundParser Function(BindFunction binder, {bool replace}) {
  BoundParser replace(BindFunction binder) => this(binder, replace: true);
}

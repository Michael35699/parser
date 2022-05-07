// ignore_for_file: avoid_dynamic_calls, avoid_catching_errors

import "package:parser/internal_all.dart";

class WhereParser extends WrapParser {
  final FilterFunction where;

  @override
  Parser get parser => children[0];

  WhereParser(Parser parser, this.where) : super(<Parser>[parser]);
  WhereParser.empty(this.where) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);

    if (ctx is ContextSuccess) {
      if (!where(ctx.mappedResult, ctx)) {
        return ctx.failure("Where check failure.");
      }
    }
    return ctx;
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextSuccess) {
        if (!where(ctx.mappedResult, ctx)) {
          return continuation(ctx.failure("Where check failure."));
        }
      }
      return continuation(ctx);
    });
  }

  @override
  WhereParser empty() => WhereParser.empty(where);

  @override
  bool hasEqualProperties(WhereParser target) => super.hasEqualProperties(target) && target.where == where;
}

WhereParser whereParser(Parser parser, FilterFunction where) => WhereParser(parser, where);
WhereParser where(Object parser, FilterFunction where) => whereParser(parser.$, where);

extension ParserWhereExtension on Parser {
  WhereParser where(FilterFunction where) => whereParser(this, where);
}

extension LazyParserWhereExtension on LazyParser {
  WhereParser where(FilterFunction where) => this.$.where(where);
}

extension StringWhereExtension on String {
  WhereParser where(FilterFunction where) => this.$.where(where);
}

extension ExtendedFilterFunctionExtension on WhereParser Function(FilterFunction where, {bool replace}) {
  WhereParser replace(FilterFunction where) => this(where, replace: true);
}

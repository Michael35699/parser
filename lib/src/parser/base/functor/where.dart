// ignore_for_file: avoid_dynamic_calls, avoid_catching_errors

import "package:parser/internal_all.dart";

class FilteredParser extends WrapParser {
  final FilterFunction filter;

  @override
  Parser get parser => children[0];

  FilteredParser(Parser parser, this.filter) : super(<Parser>[parser]);
  FilteredParser.empty(this.filter) : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);

    if (ctx is ContextSuccess) {
      if (!filter(ctx.mappedResult, ctx)) {
        return ctx.failure("Where check failure.");
      }
    }
    return ctx;
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextSuccess) {
        if (!filter(ctx.mappedResult, ctx)) {
          return continuation(ctx.failure("Where check failure."));
        }
      }
      return continuation(ctx);
    });
  }

  @override
  FilteredParser empty() => FilteredParser.empty(filter);

  @override
  bool hasEqualProperties(FilteredParser target) => super.hasEqualProperties(target) && target.filter == filter;
}

FilteredParser whereParser(Parser parser, FilterFunction where) => FilteredParser(parser, where);
FilteredParser where(Object parser, FilterFunction where) => whereParser(parser.$, where);

extension ParserWhereExtension on Parser {
  FilteredParser where(FilterFunction where) => whereParser(this, where);
}

extension LazyParserWhereExtension on LazyParser {
  FilteredParser where(FilterFunction where) => this.$.where(where);
}

extension StringWhereExtension on String {
  FilteredParser where(FilterFunction where) => this.$.where(where);
}

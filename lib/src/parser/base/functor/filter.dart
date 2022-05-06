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
        return ctx.failure("Filter failure.");
      }
    }
    return ctx;
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextSuccess) {
        if (!filter(ctx.mappedResult, ctx)) {
          return continuation(ctx.failure("Filter failure"));
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

FilteredParser filtered(Parser parser, FilterFunction filter) => FilteredParser(parser, filter);

extension ParserFilteredExtension on Parser {
  FilteredParser filter(FilterFunction filter) => filtered(this, filter);
}

extension LazyParserFilteredExtension on LazyParser {
  FilteredParser filter(FilterFunction filter) => this.$.filter(filter);
}

extension StringFilteredExtension on String {
  FilteredParser filter(FilterFunction filter) => this.$.filter(filter);
}

extension ExtendedFilterFunctionExtension on FilteredParser Function(FilterFunction filter, {bool replace}) {
  FilteredParser replace(FilterFunction filter) => this(filter, replace: true);
}

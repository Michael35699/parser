// ignore_for_file: avoid_dynamic_calls, avoid_catching_errors

import "package:parser/internal_all.dart";

class FilteredParser extends WrapParser {
  final FilterFunction filter;
  final bool replaceResult;

  @override
  Parser get parser => children[0];

  FilteredParser(Parser parser, this.filter, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[parser]);
  FilteredParser.empty(this.filter, {bool replace = false})
      : replaceResult = replace,
        super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    Context ctx = parser.pegApply(context, mutable);

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
  Parser get base => parser.base;

  @override
  FilteredParser empty() => FilteredParser.empty(filter, replace: replaceResult);

  @override
  bool hasEqualProperties(FilteredParser target) =>
      super.hasEqualProperties(target) && target.filter == filter && target.replaceResult == replaceResult;
}

FilteredParser filtered(Parser parser, FilterFunction filter, {bool replace = false}) =>
    FilteredParser(parser, filter, replace: replace);

extension ParserFilteredExtension on Parser {
  FilteredParser filter(FilterFunction filter, {bool replace = false}) => filtered(this, filter, replace: replace);
}

extension LazyParserFilteredExtension on LazyParser {
  FilteredParser filter(FilterFunction filter, {bool replace = false}) => this.$.filter(filter, replace: replace);
}

extension StringFilteredExtension on String {
  FilteredParser filter(FilterFunction filter, {bool replace = false}) => this.$.filter(filter, replace: replace);
}

extension ExtendedFilterFunctionExtension on FilteredParser Function(FilterFunction filter, {bool replace}) {
  FilteredParser replace(FilterFunction filter) => this(filter, replace: true);
}

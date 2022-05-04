import "package:parser/internal_all.dart";

class DropLeftRightParser extends WrapParser with SequentialParser {
  Parser get left => children[0];
  @override
  Parser get parser => children[1];
  Parser get right => children[2];

  DropLeftRightParser(Parser left, Parser parser, Parser right) : super(<Parser>[left, parser, right]);
  DropLeftRightParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(left, context);
    if (ctx is ContextFailure) {
      return ctx;
    }

    Context res = handler.apply(parser, ctx);
    if (res is ContextFailure) {
      return res;
    }

    Context last = handler.apply(right, res);
    if (last is ContextFailure) {
      return last;
    }

    if (res is ContextSuccess) {
      return last.success(res.mappedResult, res.unmappedResult);
    }

    return last.ignore();
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(left, context, (Context ctx) {
      if (ctx is ContextFailure) {
        return continuation(ctx);
      }

      trampoline.push(parser, ctx, (Context res) {
        if (res is ContextFailure) {
          return continuation(res);
        }

        trampoline.push(right, res, (Context last) {
          if (last is ContextFailure) {
            return continuation(last);
          }

          if (res is ContextSuccess) {
            return continuation(last.success(res.mappedResult, res.unmappedResult));
          }

          return continuation(res);
        });
      });
    });
  }

  @override
  Parser get base => parser.base;

  @override
  DropLeftRightParser empty() => DropLeftRightParser.empty();
}

extension ParserDropLeftRightExtension on Parser {
  DropLeftRightParser dropLeftRight(Object left, Object right) => DropLeftRightParser(left.$, this, right.$);
}

extension LazyParserDropLeftRightParserExtension on LazyParser {
  DropLeftRightParser dropLeftRight(Object left, Object right) => this.$.dropLeftRight(left, right);
}

extension StringDropLeftRightParserExtension on String {
  DropLeftRightParser dropLeftRight(Object left, Object right) => this.$.dropLeftRight(left, right);
}

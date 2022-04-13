import "package:parser/internal_all.dart";

class DropLeftRightParser extends WrapParser with SequentialParser {
  Parser get left => children[0];
  @override
  Parser get parser => children[1];
  Parser get right => children[2];

  DropLeftRightParser(Parser left, Parser parser, Parser right) : super(<Parser>[left, parser, right]);
  DropLeftRightParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, ParserMutable mutable) {
    Context ctx = left.pegApply(context, mutable);
    if (ctx is ContextFailure) {
      return ctx;
    }

    Context res = parser.pegApply(ctx, mutable);
    if (res is ContextFailure) {
      return res;
    }

    Context last = right.pegApply(res, mutable);
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
    void runParser(Context context) => trampoline.push(parser, context, continuation);
    void runRight(Context nextContext, ParseResult mapped, ParseResult unmapped, {required bool ignore}) {
      trampoline.push(right, nextContext, (Context context) {
        late Context resultContext = ignore ? context.ignore() : context.success(mapped, unmapped);

        if (context is! ContextFailure) {
          continuation(resultContext);
        } else {
          continuation(context);
        }
      });
    }

    trampoline.push(left, context, (Context context) {
      if (context is! ContextFailure) {
        trampoline.push(parser, context, (Context context) {
          if (context is ContextSuccess) {
            runRight(context, context.mappedResult, context.unmappedResult, ignore: false);
          } else if (context is ContextIgnore) {
            runRight(context, null, null, ignore: true);
          } else {
            continuation(context);
          }
        });
      } else {
        continuation(context);
      }
    });
  }

  @override
  Parser get base => parser.base;

  @override
  DropLeftRightParser empty() => DropLeftRightParser.empty();
}

extension DropLeftRightParserExtension on Parser {
  DropLeftRightParser dropLeftRight(Object left, Object right) => DropLeftRightParser(left.$, this, right.$);
}

extension LazyDropLeftRightParserExtension on LazyParser {
  DropLeftRightParser dropLeftRight(Object left, Object right) => this.$.dropLeftRight(left, right);
}

extension StringDropLeftRightParserExtension on String {
  DropLeftRightParser dropLeftRight(Object left, Object right) => this.$.dropLeftRight(left, right);
}

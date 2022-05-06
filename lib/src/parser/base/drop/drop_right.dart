import "package:parser/internal_all.dart";

class DropRightParser extends WrapParser with SequentialParser {
  @override
  Parser get parser => children[0];
  Parser get right => children[1];

  DropRightParser(Parser parser, Parser right) : super(<Parser>[parser, right]);
  DropRightParser.empty() : super(<Parser>[]);

  @override
  Context parsePeg(Context context, PegHandler handler) {
    Context ctx = handler.apply(parser, context);
    if (ctx is ContextFailure) {
      return ctx;
    }

    Context last = handler.apply(right, ctx);
    if (last is ContextFailure) {
      return last;
    }

    return ctx.index(last.state.index);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    trampoline.push(parser, context, (Context ctx) {
      if (ctx is ContextFailure) {
        return continuation(ctx);
      }

      trampoline.push(right, ctx, (Context last) {
        if (last is ContextFailure) {
          return continuation(last);
        }

        return continuation(ctx.index(last.state.index));
      });
    });
  }

  @override
  DropRightParser empty() => DropRightParser.empty();
}

extension ParserDropRightExtension on Parser {
  DropRightParser dropRight(Object right) => DropRightParser(this, right.$);
  Parser operator <<(Object right) {
    Parser self = this;
    if (self is DropLeftParser) {
      return self.parser.dropLeftRight(self.left, right);
    } else {
      return dropRight(right);
    }
  }
}

extension LazyParserDropRightExtension on LazyParser {
  DropRightParser dropRight(Object right) => this.$.dropRight(right);
  Parser operator <<(Object right) => this.$ << right;
}

extension StringDropRightExtension on String {
  DropRightParser dropRight(Object right) => this.$.dropRight(right);
  Parser operator <<(Object right) => this.$ << right;
}

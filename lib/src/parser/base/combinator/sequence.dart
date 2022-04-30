import "package:parser/internal_all.dart";

class SequenceParser extends CombinatorParser with SequentialParser {
  SequenceParser(List<Parser> children) : super(children);

  @override
  Context parsePeg(Context context, PegParserMutable mutable) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = context;
    for (int i = 0; i < children.length; i++) {
      ctx = children[i].pegApply(ctx, mutable);

      if (ctx.isFailure) {
        return ctx;
      }

      ctx.addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  void parseGll(Context context, Trampoline trampoline, GllContinuation continuation) {
    void run(Context context, int i, List<ParseResult> mapped, List<ParseResult> unmapped) {
      if (i >= children.length) {
        return continuation(context.success(mapped, unmapped));
      }

      trampoline.push(children[i], context, (Context context) {
        if (context is ContextSuccess) {
          return run(context, i + 1, <ParseResult>[...mapped, context.mappedResult],
              <ParseResult>[...unmapped, context.unmappedResult]);
        } else if (context is ContextIgnore) {
          return run(context, i + 1, mapped, unmapped);
        }
        return continuation(context);
      });
    }

    run(context, 0, <ParseResult>[], <ParseResult>[]);
  }

  @override
  SequenceParser empty() => SequenceParser(<Parser>[]);
}

extension ParserSequenceExtension on Parser {
  SequenceParser then(Object other) => ((Parser self) => ((Parser other) => SequenceParser(<Parser>[
        if (self is SequenceParser) ...self.children else this,
        if (other is SequenceParser) ...other.children else other,
      ]))(other.$))(this);
  SequenceParser operator &(Object other) => then(other);
}

extension LazyParserSequenceExtension on LazyParser {
  SequenceParser then(Object other) => this.$.then(other);
  SequenceParser operator &(Object other) => this.$ & other;
}

extension StringSequenceExtension on String {
  SequenceParser then(Object other) => this.$.then(other);
  SequenceParser operator &(Object other) => this.$ & other;
}

extension IterableSequenceExtension on Iterable<Parser> {
  SequenceParser sequenceParser() => SequenceParser(toList());
}

SequenceParser sequence(List<Parser> parsers) => SequenceParser(parsers);

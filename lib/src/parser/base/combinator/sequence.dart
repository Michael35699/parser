import "package:parser/internal_all.dart";

class SequenceParser extends CombinatorParser with SequentialParser {
  SequenceParser(List<Parser> children) : super(children);

  @override
  Context parse(Context context, ParserMutable mutable) {
    List<ParseResult> mapped = <ParseResult>[];
    List<ParseResult> unmapped = <ParseResult>[];

    Context ctx = context;
    for (int i = 0; i < children.length; i++) {
      ctx = children[i].apply(ctx, mutable);

      if (ctx.isFailure) {
        return ctx;
      }

      ctx.addResult(mapped, unmapped);
    }

    return ctx.success(mapped, unmapped);
  }

  @override
  SequenceParser empty() => SequenceParser(<Parser>[]);
}

extension SequenceExtension on Parser {
  SequenceParser then(Object other) => ((Parser self) => ((Parser other) => SequenceParser(<Parser>[
        if (self is SequenceParser) ...self.children else this,
        if (other is SequenceParser) ...other.children else other,
      ]))(other.$))(this);
  SequenceParser operator &(Object other) => then(other);
}

extension LazySequenceExtension on LazyParser {
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

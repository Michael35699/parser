import "package:parser_peg/internal_all.dart";

class ContextualParser<T> extends SpecialParser {
  final Parser Function(Set<T>) callback;

  ContextualParser(this.callback);

  @override
  Context parse(Context context, ParserMutable mutable) =>
      callback(context.state.dataSet.cast()).apply(context, mutable);
}

ContextualParser<T> ctx<T>(Parser Function(Set<T>) callback) => ContextualParser<T>(callback);

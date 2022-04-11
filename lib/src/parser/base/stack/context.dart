import "package:parser_peg/internal_all.dart";

class ContextualParser<T> extends SpecialParser {
  final Parser Function(Set<T>) callback;

  ContextualParser(this.callback);

  @override
  Context parse(Context context, ParserEngine engine) => engine.apply(callback(context.state.dataSet.cast()), context);
}

ContextualParser<T> context<T>(Parser Function(Set<T>) callback) => ContextualParser<T>(callback);

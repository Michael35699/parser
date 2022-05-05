/// Auto-generated. Don't feel bad.
import "package:parser/internal_all.dart";

String _$flatten(dynamic value) => value is List ? value.map(_$flatten).join() : value.toString();

MapFunction _$maybe<T>(ParseResult Function(T) callback) =>
    (ParseResult result, Context context) => result == null ? null : callback(_type(result));

MapFunction _$type<T>(ParseResult Function(T) callback) =>
    (ParseResult result, Context context) => callback(_type(result));

MapFunction _$cast<T extends ParseResult>() => (ParseResult result, Context context) => result as T;

MapFunction _$join([String sep = ""]) =>
    (ParseResult result, Context context) => (result as List<ParseResult>?)?.join(sep);

MapFunction _$named(Function fn) {
  return (ParseResult result, Context context) {
    List<ParseResult> results = result! as List<ParseResult>;
    Iterable<MapEntry<Symbol, ParseResult>> entries = results.whereType<MapEntry<Symbol, ParseResult>>();

    return Function.apply(fn, null, Map<Symbol, ParseResult>.fromEntries(entries));
  };
}

MapFunction _$at(int index) => (ParseResult result, Context context) => (result as List<ParseResult>?)?[index];

MapFunction _$empty(dynamic Function() fn) => (ParseResult result, Context context) => fn();

MapFunction _$res(dynamic Function(ParseResult) fn) {
  return (ParseResult result, Context context) {
    return fn(result);
  };
}

MapFunction _$ctx(dynamic Function(Context) fn) {
  return (ParseResult result, Context context) {
    return fn(context);
  };
}

MapFunction _$spread(int index) => _$type((List<ParseResult> results) => <ParseResult>[
      for (int i = 0; i < results.length; i++)
        if (index == i) ...results[i]! as Iterable<ParseResult> else results[i]
    ]);

MapFunction _$apply(Function fn) => (ParseResult result, Context ctx) {
      return Function.apply(fn, result is List ? result : <ParseResult>[result]);
    };

MapFunction _$remove(int index) => _$type((List<ParseResult> results) => <ParseResult>[
      for (int i = 0; i < results.length; i++)
        if (index != i) results[i]
    ]);
MapFunction _$drop(int index) => _$remove(index);

MapFunction _$tag(Symbol name) => _$res((ParseResult obj) => MapEntry<Symbol, ParseResult>(name, obj));
MapFunction _$tagged(dynamic Function(Symbol, ParseResult) function) =>
    _$type((MapEntry<Symbol, ParseResult> entry) => function(entry.key, entry.value));

MapFunction _$trim() => _$type((String c) => c.trim());
MapFunction _$echo() => _$type((Object? c) {
      print(c);

      return c;
    });
MapFunction _$value(Object? value) => (ParseResult r, Context c) => value;
MapFunction _$flat() => $type(_$flatten);

T _type<T>(ParseResult v) => v as T;

dynamic $pipe(ParseResult r, Context c) => r;
MapFunction $type<T extends ParseResult>(ParseResult Function(T) callback) => _$type(callback);
MapFunction $maybe<T extends ParseResult>(ParseResult Function(T) callback) => _$maybe(callback);
MapFunction $cast<T extends ParseResult>() => _$cast<T>();
MapFunction $join([String sep = ""]) => _$join(sep);
MapFunction $named(Function fn) => _$named(fn);
MapFunction $at(int index) => _$at(index);
MapFunction $empty(dynamic Function() fn) => _$empty(fn);
MapFunction $res(dynamic Function(ParseResult) fn) => _$res(fn);
MapFunction $ctx(dynamic Function(Context) fn) => _$ctx(fn);
MapFunction $spread(int index) => _$spread(index);
MapFunction $apply(Function fn) => _$apply(fn);
MapFunction $remove(int index) => _$remove(index);
MapFunction $drop(int index) => _$drop(index);
MapFunction $tag(Symbol name) => _$tag(name);
MapFunction $tagged(dynamic Function(Symbol, ParseResult) function) => _$tagged(function);
MapFunction $value(Object? value) => _$value(value);
MapFunction $flat() => _$flat();
MapFunction $trim() => _$trim();
MapFunction $echo() => _$echo();

extension ParserBasicMappersExtension on Parser {
  MappedParser $join([String sep = ""]) => map(_$join(sep));
  MappedParser $named(Function fn) => map(_$named(fn));
  MappedParser $at(int index) => map(_$at(index));
  MappedParser $spread(int index) => map(_$spread(index));
  MappedParser $remove(int index) => map(_$remove(index));
  MappedParser $drop(int index) => map(_$remove(index));
  MappedParser $tag(Symbol name) => map(_$tag(name));
  MappedParser $value(Object? value) => map(_$value(value));
  MappedParser $trim() => map(_$trim());
  MappedParser $echo() => map(_$echo());
  MappedParser $flat() => map(_$flat());
  MappedParser $apply(Function fn) => map(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => map(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => map(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => map(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => map(_$tagged(function));
  MappedParser $type<T extends ParseResult>(ParseResult Function(T) callback) => map(_$type(callback));
  MappedParser $maybe<T extends ParseResult>(ParseResult Function(T) callback) => map(_$maybe(callback));
}

extension LazyParserBasicMappersExtension on LazyParser {
  MappedParser $join([String sep = ""]) => map(_$join(sep));
  MappedParser $named(Function fn) => map(_$named(fn));
  MappedParser $at(int index) => map(_$at(index));
  MappedParser $spread(int index) => map(_$spread(index));
  MappedParser $remove(int index) => map(_$remove(index));
  MappedParser $drop(int index) => map(_$remove(index));
  MappedParser $tag(Symbol name) => map(_$tag(name));
  MappedParser $value(Object? value) => map(_$value(value));
  MappedParser $trim() => map(_$trim());
  MappedParser $echo() => map(_$echo());
  MappedParser $flat() => map(_$flat());
  MappedParser $apply(Function fn) => map(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => map(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => map(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => map(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => map(_$tagged(function));
  MappedParser $type<T extends ParseResult>(ParseResult Function(T) callback) => map(_$type(callback));
  MappedParser $maybe<T extends ParseResult>(ParseResult Function(T) callback) => map(_$maybe(callback));
}

extension StringBasicMappersExtension on String {
  MappedParser $join([String sep = ""]) => map(_$join(sep));
  MappedParser $named(Function fn) => map(_$named(fn));
  MappedParser $at(int index) => map(_$at(index));
  MappedParser $spread(int index) => map(_$spread(index));
  MappedParser $remove(int index) => map(_$remove(index));
  MappedParser $drop(int index) => map(_$remove(index));
  MappedParser $tag(Symbol name) => map(_$tag(name));
  MappedParser $value(Object? value) => map(_$value(value));
  MappedParser $trim() => map(_$trim());
  MappedParser $echo() => map(_$echo());
  MappedParser $flat() => map(_$flat());
  MappedParser $apply(Function fn) => map(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => map(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => map(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => map(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => map(_$tagged(function));
  MappedParser $type<T extends ParseResult>(ParseResult Function(T) callback) => map(_$type(callback));
  MappedParser $maybe<T extends ParseResult>(ParseResult Function(T) callback) => map(_$maybe(callback));
}

extension BuiltBasicMappersExtension on MappedParser Function(MapFunction mapper, {bool replace}) {
  MappedParser $join([String sep = ""]) => this(_$join(sep));
  MappedParser $named(Function fn) => this(_$named(fn));
  MappedParser $at(int index) => this(_$at(index));
  MappedParser $spread(int index) => this(_$spread(index));
  MappedParser $remove(int index) => this(_$remove(index));
  MappedParser $drop(int index) => this(_$remove(index));
  MappedParser $tag(Symbol name) => this(_$tag(name));
  MappedParser $value(Object? value) => this(_$value(value));
  MappedParser $trim() => this(_$trim());
  MappedParser $echo() => this(_$echo());
  MappedParser $flat() => this(_$flat());

  MappedParser $apply(Function fn) => this(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => this(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => this(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => this(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => this(_$tagged(function));
  MappedParser $type<T extends ParseResult>(ParseResult Function(T) callback) => this(_$type(callback));
  MappedParser $maybe<T extends ParseResult>(ParseResult Function(T) callback) => this(_$maybe(callback));
}

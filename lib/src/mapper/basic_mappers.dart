/// Auto-generated. Don't feel bad.
import "package:parser_peg/internal_all.dart";

MapFunction _$0(ParseResult Function() callback) =>
    (ParseResult result, Context context) => Function.apply(callback, null);

MapFunction _$seq(Function callback) => (ParseResult result, Context context) =>
    Function.apply(callback, _type(result is List ? result : <ParseResult>[result]));

MapFunction _$type<T>(ParseResult Function(T) callback) =>
    (ParseResult result, Context context) => callback(_type(result));

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
MapFunction _$list<T extends Object?>(ParseResult Function(List<T>) callback) =>
    (ParseResult r, Context c) => r is List //
        ? callback(List<T>.from(r))
        : callback(<T>[r as T]);
T _type<T>(ParseResult v) => v as T;

MapFunction $0(ParseResult Function() callback) => _$0(callback);
MapFunction $1<V1>(ParseResult Function(V1) callback) => _$seq(callback);
MapFunction $2<V1, V2>(ParseResult Function(V1, V2) callback) => _$seq(callback);
MapFunction $3<V1, V2, V3>(ParseResult Function(V1, V2, V3) callback) => _$seq(callback);
MapFunction $4<V1, V2, V3, V4>(ParseResult Function(V1, V2, V3, V4) callback) => _$seq(callback);
MapFunction $5<V1, V2, V3, V4, V5>(ParseResult Function(V1, V2, V3, V4, V5) callback) => _$seq(callback);
MapFunction $6<V1, V2, V3, V4, V5, V6>(ParseResult Function(V1, V2, V3, V4, V5, V6) callback) => _$seq(callback);
MapFunction $7<V1, V2, V3, V4, V5, V6, V7>(ParseResult Function(V1, V2, V3, V4, V5, V6, V7) callback) =>
    _$seq(callback);

MapFunction $8<V1, V2, V3, V4, V5, V6, V7, V8>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8) callback,
) =>
    _$seq(callback);

MapFunction $9<V1, V2, V3, V4, V5, V6, V7, V8, V9>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9) callback,
) =>
    _$seq(callback);

MapFunction $10<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10) callback,
) =>
    _$seq(callback);

MapFunction $11<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11) callback,
) =>
    _$seq(callback);

MapFunction $12<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12) callback,
) =>
    _$seq(callback);

MapFunction $13<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13) callback,
) =>
    _$seq(callback);

MapFunction $14<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14) callback,
) =>
    _$seq(callback);

MapFunction $15<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15) callback,
) =>
    _$seq(callback);

MapFunction $16<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16) callback,
) =>
    _$seq(callback);

MapFunction $17<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17) callback,
) =>
    _$seq(callback);

MapFunction $18<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18) callback,
) =>
    _$seq(callback);

MapFunction $19<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19) callback,
) =>
    _$seq(callback);

MapFunction $20<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20>(
  ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20)
      callback,
) =>
    _$seq(callback);

dynamic $pipe(ParseResult r, Context c) => r;
MapFunction $list<T extends Object?>(ParseResult Function(List<T>) callback) => _$list(callback);
MapFunction $type<T extends Object?>(ParseResult Function(T) callback) => _$type(callback);
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
MapFunction $trim() => _$trim();
MapFunction $echo() => _$echo();

extension BasicMappersExtension on Parser {
  MappedParser $join([String sep = ""]) => map(_$join(sep));
  MappedParser $named(Function fn) => map(_$named(fn));
  MappedParser $at(int index) => map(_$at(index));
  MappedParser $spread(int index) => map(_$spread(index));
  MappedParser $remove(int index) => map(_$remove(index));
  MappedParser $drop(int index) => map(_$remove(index));
  MappedParser $tag(Symbol name) => map(_$tag(name));
  MappedParser $trim() => map(_$trim());
  MappedParser $echo() => map(_$echo());
  MappedParser $apply(Function fn) => map(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => map(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => map(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => map(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => map(_$tagged(function));
  MappedParser $type<T extends Object?>(ParseResult Function(T) callback) => map(_$type(callback));
  MappedParser $list<T extends Object?>(ParseResult Function(List<T>) callback) => map(_$list(callback));

  MappedParser $0(ParseResult Function() callback) => map(_$0(callback));
  MappedParser $1<V1>(ParseResult Function(V1) callback) => map(_$seq(callback));
  MappedParser $2<V1, V2>(ParseResult Function(V1, V2) callback) => map(_$seq(callback));
  MappedParser $3<V1, V2, V3>(ParseResult Function(V1, V2, V3) callback) => map(_$seq(callback));
  MappedParser $4<V1, V2, V3, V4>(ParseResult Function(V1, V2, V3, V4) callback) => map(_$seq(callback));
  MappedParser $5<V1, V2, V3, V4, V5>(ParseResult Function(V1, V2, V3, V4, V5) callback) => map(_$seq(callback));
  MappedParser $6<V1, V2, V3, V4, V5, V6>(ParseResult Function(V1, V2, V3, V4, V5, V6) callback) =>
      map(_$seq(callback));
  MappedParser $7<V1, V2, V3, V4, V5, V6, V7>(ParseResult Function(V1, V2, V3, V4, V5, V6, V7) callback) =>
      map(_$seq(callback));

  MappedParser $8<V1, V2, V3, V4, V5, V6, V7, V8>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $9<V1, V2, V3, V4, V5, V6, V7, V8, V9>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $10<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $11<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $12<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $13<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $14<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $15<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $16<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $17<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $18<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $19<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19) callback,
  ) =>
      map(_$seq(callback));

  MappedParser $20<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20)
        callback,
  ) =>
      map(_$seq(callback));
}

extension LazyBasicMappersExtension on LazyParser {
  MappedParser $join([String sep = ""]) => this.$.map(_$join(sep));
  MappedParser $named(Function fn) => this.$.map(_$named(fn));
  MappedParser $at(int index) => this.$.map(_$at(index));
  MappedParser $spread(int index) => this.$.map(_$spread(index));
  MappedParser $remove(int index) => this.$.map(_$remove(index));
  MappedParser $drop(int index) => this.$.map(_$remove(index));
  MappedParser $tag(Symbol name) => this.$.map(_$tag(name));
  MappedParser $trim() => this.$.map(_$trim());
  MappedParser $echo() => this.$.map(_$echo());
  MappedParser $apply(Function fn) => this.$.map(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => this.$.map(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => this.$.map(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => this.$.map(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => this.$.map(_$tagged(function));
  MappedParser $type<T extends Object?>(ParseResult Function(T) callback) => this.$.map(_$type(callback));
  MappedParser $list<T extends Object?>(ParseResult Function(List<T>) callback) => this.$.map(_$list(callback));

  MappedParser $0(ParseResult Function() callback) => this.$.map(_$0(callback));
  MappedParser $1<V1>(ParseResult Function(V1) callback) => this.$.map(_$seq(callback));
  MappedParser $2<V1, V2>(ParseResult Function(V1, V2) callback) => this.$.map(_$seq(callback));
  MappedParser $3<V1, V2, V3>(ParseResult Function(V1, V2, V3) callback) => this.$.map(_$seq(callback));
  MappedParser $4<V1, V2, V3, V4>(ParseResult Function(V1, V2, V3, V4) callback) => this.$.map(_$seq(callback));
  MappedParser $5<V1, V2, V3, V4, V5>(ParseResult Function(V1, V2, V3, V4, V5) callback) => this.$.map(_$seq(callback));
  MappedParser $6<V1, V2, V3, V4, V5, V6>(ParseResult Function(V1, V2, V3, V4, V5, V6) callback) =>
      this.$.map(_$seq(callback));
  MappedParser $7<V1, V2, V3, V4, V5, V6, V7>(ParseResult Function(V1, V2, V3, V4, V5, V6, V7) callback) =>
      this.$.map(_$seq(callback));

  MappedParser $8<V1, V2, V3, V4, V5, V6, V7, V8>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $9<V1, V2, V3, V4, V5, V6, V7, V8, V9>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $10<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $11<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $12<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $13<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $14<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $15<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $16<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $17<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $18<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $19<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $20<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20)
        callback,
  ) =>
      this.$.map(_$seq(callback));
}

extension StringBasicMappersExtension on String {
  MappedParser $join([String sep = ""]) => this.$.map(_$join(sep));
  MappedParser $named(Function fn) => this.$.map(_$named(fn));
  MappedParser $at(int index) => this.$.map(_$at(index));
  MappedParser $spread(int index) => this.$.map(_$spread(index));
  MappedParser $remove(int index) => this.$.map(_$remove(index));
  MappedParser $drop(int index) => this.$.map(_$remove(index));
  MappedParser $tag(Symbol name) => this.$.map(_$tag(name));
  MappedParser $trim() => this.$.map(_$trim());
  MappedParser $echo() => this.$.map(_$echo());
  MappedParser $apply(Function fn) => this.$.map(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => this.$.map(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => this.$.map(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => this.$.map(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => this.$.map(_$tagged(function));
  MappedParser $type<T extends Object?>(ParseResult Function(T) callback) => this.$.map(_$type(callback));
  MappedParser $list<T extends Object?>(ParseResult Function(List<T>) callback) => this.$.map(_$list(callback));

  MappedParser $0(ParseResult Function() callback) => this.$.map(_$0(callback));
  MappedParser $1<V1>(ParseResult Function(V1) callback) => this.$.map(_$seq(callback));
  MappedParser $2<V1, V2>(ParseResult Function(V1, V2) callback) => this.$.map(_$seq(callback));
  MappedParser $3<V1, V2, V3>(ParseResult Function(V1, V2, V3) callback) => this.$.map(_$seq(callback));
  MappedParser $4<V1, V2, V3, V4>(ParseResult Function(V1, V2, V3, V4) callback) => this.$.map(_$seq(callback));
  MappedParser $5<V1, V2, V3, V4, V5>(ParseResult Function(V1, V2, V3, V4, V5) callback) => this.$.map(_$seq(callback));
  MappedParser $6<V1, V2, V3, V4, V5, V6>(ParseResult Function(V1, V2, V3, V4, V5, V6) callback) =>
      this.$.map(_$seq(callback));
  MappedParser $7<V1, V2, V3, V4, V5, V6, V7>(ParseResult Function(V1, V2, V3, V4, V5, V6, V7) callback) =>
      this.$.map(_$seq(callback));

  MappedParser $8<V1, V2, V3, V4, V5, V6, V7, V8>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $9<V1, V2, V3, V4, V5, V6, V7, V8, V9>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $10<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $11<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $12<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $13<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $14<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $15<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $16<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $17<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $18<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $19<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19) callback,
  ) =>
      this.$.map(_$seq(callback));

  MappedParser $20<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20)
        callback,
  ) =>
      this.$.map(_$seq(callback));
}

extension BuiltBasicMappersExtension on MappedParser Function(MapFunction mapper, {bool replace}) {
  MappedParser $join([String sep = ""]) => this(_$join(sep));
  MappedParser $named(Function fn) => this(_$named(fn));
  MappedParser $at(int index) => this(_$at(index));
  MappedParser $spread(int index) => this(_$spread(index));
  MappedParser $remove(int index) => this(_$remove(index));
  MappedParser $drop(int index) => this(_$remove(index));
  MappedParser $tag(Symbol name) => this(_$tag(name));
  MappedParser $trim() => this(_$trim());
  MappedParser $echo() => this(_$echo());

  MappedParser $apply(Function fn) => this(_$apply(fn));
  MappedParser $empty(dynamic Function() fn) => this(_$empty(fn));
  MappedParser $ctx(dynamic Function(Context) fn) => this(_$ctx(fn));
  MappedParser $res(dynamic Function(ParseResult) fn) => this(_$res(fn));
  MappedParser $tagged(dynamic Function(Symbol, ParseResult) function) => this(_$tagged(function));
  MappedParser $type<T extends Object?>(ParseResult Function(T) callback) => this(_$type(callback));
  MappedParser $list<T extends Object?>(ParseResult Function(List<T>) callback) => this(_$list(callback));

  MappedParser $0(ParseResult Function() callback) => this(_$0(callback));
  MappedParser $1<V1>(ParseResult Function(V1) callback) => this(_$seq(callback));
  MappedParser $2<V1, V2>(ParseResult Function(V1, V2) callback) => this(_$seq(callback));
  MappedParser $3<V1, V2, V3>(ParseResult Function(V1, V2, V3) callback) => this(_$seq(callback));
  MappedParser $4<V1, V2, V3, V4>(ParseResult Function(V1, V2, V3, V4) callback) => this(_$seq(callback));
  MappedParser $5<V1, V2, V3, V4, V5>(ParseResult Function(V1, V2, V3, V4, V5) callback) => this(_$seq(callback));
  MappedParser $6<V1, V2, V3, V4, V5, V6>(ParseResult Function(V1, V2, V3, V4, V5, V6) callback) =>
      this(_$seq(callback));
  MappedParser $7<V1, V2, V3, V4, V5, V6, V7>(ParseResult Function(V1, V2, V3, V4, V5, V6, V7) callback) =>
      this(_$seq(callback));

  MappedParser $8<V1, V2, V3, V4, V5, V6, V7, V8>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $9<V1, V2, V3, V4, V5, V6, V7, V8, V9>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $10<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $11<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $12<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $13<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $14<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $15<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $16<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $17<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $18<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $19<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19) callback,
  ) =>
      this(_$seq(callback));

  MappedParser $20<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20>(
    ParseResult Function(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20)
        callback,
  ) =>
      this(_$seq(callback));
}

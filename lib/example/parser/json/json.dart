// ignore_for_file: avoid_private_typedef_functions

import "package:parser/parser.dart";

typedef _JsonObject = Object?;
typedef _JsonList = List<_JsonObject>;
typedef _JsonMap = Map<String, _JsonObject>;
typedef _JsonEntry = MapEntry<String, _JsonObject>;

Parser jsonParser() => _value.end();
Parser _value() => _valueBody.trim();
Parser _valueBody() => _array | _object | jsonNumber | _string | _trueValue | _falseValue | _nullValue;

Parser _array() => "[" >> _elements.trim() << "]";
Parser _elements() => _value % -",".t | success(_JsonList.empty());

Parser _object() => "{" >> _members.trim() << "}";
Parser _members() =>
    _pair % -",".t ^ $list<_JsonEntry>() >>> _JsonMap.fromEntries | //
    success(_JsonMap.identity());

Parser _pair() => _string & -":".t & _value ^ $2(_JsonEntry.new);

Parser _string() => jsonString().map.$at(1);

Parser _trueValue = "true" ^ $value(true);
Parser _falseValue = "false" ^ $value(false);
Parser _nullValue = "null" ^ $value(null);

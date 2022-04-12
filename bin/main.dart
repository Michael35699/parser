import "package:parser_peg/internal_all.dart";

part "utils.dart";

typedef JsonEntry = MapEntry<String, Object>;
typedef JsonMap = Map<String, Object>;
typedef JsonList = List<Object>;

Parser jsonParser() => value.end();
Parser value() => valueBody.trim();
Parser valueBody() => array | object | jsonNumber | string | trueValue | falseValue | nullValue;

Parser array() => "[" >> elements.trim() << "]";
Parser elements() =>
    value % -",".t | //
    success(JsonList.empty());

Parser object() => "{" >> members.trim() << "}";
Parser members() =>
    pair % -",".t ^ $list<JsonEntry>() ^ $type(JsonMap.fromEntries) | //
    success(JsonMap.identity());

Parser pair() => string & -":".t & value ^ $2(JsonEntry.new);

Parser string() => jsonString().$at(1);

Parser trueValue = "true" ^ $value(true);
Parser falseValue = "false" ^ $value(false);
Parser nullValue = "null" ^ $value(null);

void main() {
  print(jsonParser.run("""[123, "hello", null, 123, 123, {"one": "two"}]"""));
}

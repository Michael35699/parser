import "package:parser/parser.dart";

class OptimizedJsonGrammar with Grammar {
  @override
  Parser start() => value.$;

  Parser value() => valueBody.trim();
  Parser valueBody() => array | object | jsonNumber | jsonString | trueValue | falseValue | nullValue;

  Parser array() => "[" & (elements ~/ <Object>[]).trim() & "]";
  Parser elements() => value % -",".t;

  Parser object() => "{" & (members ~/ <Object>[]).trim() & "}";
  Parser members() => pair % -",".t;
  Parser pair() => string & ":".t & value;

  Parser trueValue = "true".p();
  Parser falseValue = "false".p();
  Parser nullValue = "null".p();
}

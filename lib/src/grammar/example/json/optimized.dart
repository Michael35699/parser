import "package:parser_peg/parser_peg.dart";

class OptimizedJsonGrammar with Grammar {
  @override
  Parser start() => value.$;

  Parser value() => valueBody.trim();
  Parser valueBody() => array | object | jsonNumber | string | trueValue | falseValue | nullValue;

  Parser array() => "[" & elements.orElse(<Object>[]).trim() & "]";
  Parser elements() => value % -",".t;

  Parser object() => "{" & members.orElse(<Object>[]).trim() & "}";
  Parser members() => pair % -",".t;
  Parser pair() => string & ":".t & value;

  Parser trueValue = "true".p();
  Parser falseValue = "false".p();
  Parser nullValue = "null".p();
}

import "package:parser_peg/parser_peg.dart";

class JsonGrammar with Grammar {
  @override
  Parser start() => value.$;

  Parser value() => whitespace & valueBody & whitespace;
  Parser valueBody() => array | object | number | string | trueValue | falseValue | nullValue;

  Parser array() =>
      "[" & whitespace & elements & whitespace & "]" | //
      "[" & whitespace & "]";

  Parser elements() =>
      value & ",".p & elements | //
      value;

  Parser object() => "{" & whitespace & members & whitespace & "}" | "{" & whitespace & "}";
  Parser members() => pair & whitespace & ",".p & whitespace & members | pair;
  Parser pair() => string & whitespace & ":".p & whitespace & value;

  Parser string() => '"' & stringChars & '"' | '"' & '"';
  Parser stringChars() => stringChar & stringChars | stringChar;
  Parser stringChar() => ~stringAvoid >> source | controlChar;
  Parser stringAvoid() => '"'.p | controlChar;
  Parser controlChar() => r"\".p & controlCharBody;
  Parser controlCharBody() => '"'.p | r"\".p | "/".p | "b".p | "f".p | "n".p | "r".p | "t".p | hexCode;
  Parser hexCode() => hex & hex & hex & hex;
  Parser hex = "A".urng("F") | "a".urng("f") | "0".urng("9");

  Parser number() => sign & whole & fraction & exponent;
  Parser sign() => "-".p | "".p;
  Parser whole() => digits.$;
  Parser fraction() => ".".p & digits | "".p;
  Parser exponent() => eCharacter & exponentialSign & digits | "".p;

  Parser eCharacter = "e".p | "E".p;
  Parser exponentialSign = "-".p | "+".p | "".p;

  Parser digits() => digit & digits | digit;
  Parser digit = "0".urng("9");
  Parser trueValue = "true".p();
  Parser falseValue = "false".p();
  Parser nullValue = "null".p();

  Parser whitespace() => whitespaceStar | "".p;
  Parser whitespaceStar() => whitespaceCharacter & whitespaceStar | whitespaceCharacter;
  Parser whitespaceCharacter = " ".p | "\r".p | "\n".p | "\t".p;
}

import "package:parser_peg/parser_peg.dart";

class PrimitiveJsonGrammar with Grammar {
  @override
  Parser start() => value.$;

  Parser value() => whitespace & valueBody & whitespace;
  Parser valueBody() =>
      array | //
      object |
      number |
      string |
      trueValue |
      falseValue |
      nullValue;

  Parser array() =>
      "[" & whitespace & elements & whitespace & "]" | //
      "[" & whitespace & "]";

  Parser elements() =>
      value & ",".p & elements | //
      value;

  Parser object() =>
      "{" & whitespace & members & whitespace & "}" | //
      "{" & whitespace & "}";

  Parser members() =>
      members & whitespace & ",".p & whitespace & pair | //
      pair;

  Parser pair() => string & whitespace & ":".p & whitespace & value;

  Parser string() =>
      '"' & stringChars & '"' | //
      '"' & '"';

  Parser stringChars() =>
      stringChars & stringChar | //
      stringChar;

  Parser stringChar() =>
      ~stringAvoid >> source | //
      controlChar;

  Parser stringAvoid() =>
      '"' | //
      controlChar;

  Parser controlChar() => r"\" & controlCharBody;

  Parser controlCharBody() =>
      '"' | //
      r"\" |
      "/" |
      "b" |
      "f" |
      "n" |
      "r" |
      "t" |
      hexCode;

  Parser hexCode() => hex & hex & hex & hex;
  Parser hex() =>
      "A" >> "F" | //
      "a" >> "f" |
      "0" >> "9";

  Parser number() => sign & whole & fraction & exponent;
  Parser sign() => "-".p | "".p;
  Parser whole() => digits.$;
  Parser fraction() => ".".p & digits | "".p;
  Parser exponent() => eCharacter & exponentialSign & digits | "".p;

  Parser eCharacter = "e".p | "E".p;
  Parser exponentialSign = "-".p | "+".p | "".p;

  Parser digits() => digits & digit | digit;
  Parser digit = "0" >> "9";
  Parser trueValue = "true".p();
  Parser falseValue = "false".p();
  Parser nullValue = "null".p();

  Parser whitespace() => whitespaceStar | "".p;
  Parser whitespaceStar() => whitespaceStar & whitespaceCharacter | whitespaceCharacter;
  Parser whitespaceCharacter = " ".p | "\r".p | "\n".p | "\t".p;
}

part of "builtin.dart";

// BASIC
Parser _digit() => "[0-9]".r();
Parser _digits() => "[0-9]+".r();

Parser _lowercase() => "[a-z]".r();
Parser _uppercase() => "[A-Z]".r();

Parser _lowercaseGreek() => "[α-ω]".r();
Parser _uppercaseGreek() => "[Α-Ω]".r();

Parser _letter() => "[A-Za-z]".r();
Parser _letters() => "[A-Za-z]+".r();

Parser _greek() => "[Α-Ωα-ω]".r();
Parser _greeks() => "[Α-Ωα-ω]+".r();

Parser _alphanum() => "[0-9A-Fa-f]".r();
Parser _alphanums() => "[0-9A-Fa-f]+".r();

Parser _hex() => "[0-9A-Fa-f]".r();
Parser _hexes() => "[0-9A-Fa-f]+".r();

Parser _octal() => "[0-7]".r();
Parser _octals() => "[0-7]+".r();

// STRING
Parser _string() => r"""(?:(')((?:(?:\\.)|[^'\\]+)*)('))|(?:(")((?:(?:\\.)|[^"\\]+)*)("))""".r();
Parser _singleString() => r"(')((?:(?:\\.)|[^'\\]+)*)(')".r();
Parser _doubleString() => r'(")((?:(?:\\.)|[^"\\]+)*)(")'.r();

// CHAR
Parser _char() => r"""(?:(')((?:(?:\\.)|[^'\\])?)('))|(?:(")((?:(?:\\.)|[^"\\])?)("))""".r();
Parser _singleChar() => r"(')((?:(?:\\.)|[^'\\])?)(')".r();
Parser _doubleChar() => r'(")((?:(?:\\.)|[^"\\])?)(")'.r();

// INTEGER /DECIMAL
Parser _number() => r"""(?:[0-9]*\.[0-9]+)|(?:[0-9]+)""".r ^ $type(num.parse);
Parser _integer() => "[0-9]+".r ^ $type(int.parse);
Parser _decimal() => r"[0-9]*\.[0-9]+".r ^ $type(double.parse);

// IDENTIFIER
Parser _identifier() => r"[A-Za-zΑ-Ωα-ω\_\$\:][A-Za-zΑ-Ωα-ω0-9\_\$\-]*".r();
Parser _cIdentifier() => r"[A-Za-z\_\$\:][A-Za-z0-9\_\$]*".r();

// OPERATOR
Parser _operator() => r"[<>=!\/&^%+\-#*~]+".r();
Parser _binaryMathOp() => r"[+\-*\/%^]|(?:~/)".r();
Parser _preUnaryMathOp() => "√".r();
Parser _postUnaryMathOp() => "!".r();

// JSON NUMBER

Parser __sign() => "-" ^ $type((str r) => r == "-" ? -1 : 1) | success(1);
Parser __whole() => "[0-9]+".r ^ $type(int.parse);
Parser __fraction() => r"\.[0-9]+".r ^ $type((str r) => double.parse("0$r")) | success(0);
Parser __eMark() => "[Ee]".r();
Parser __eSign() => "[+-]".r | success("+");
Parser __power() => __eMark & __eSign & __whole ^ $3((_, str s, int v) => pow(10, s == "-" ? -v : v)) | success(1);
Parser __base() => __whole & __fraction ^ $2((num w, num f) => w + f);
Parser _completeNumberSlow() => __base & __power ^ $2((num b, num p) => b * p);
Parser _jsonNumberSlow() => __sign & __base & __power ^ $3((num s, num b, num p) => s * b * p);

Parser _completeNumber() => r"(?<b>[0-9]+)(?:\.(?<f>[0-9]+))?(?:[eE](?<s>[+-]?)(?<e>[0-9]+))?".r.map(
      $named(({String b = "0", String? f, String? s, String? e}) {
        num base = int.parse(b) + (f == null ? 0 : double.parse("0.$f"));
        num exp = e == null ? 1 : pow(10, s == "-" ? -1 : 1 * int.parse(e));

        return base * exp;
      }),
    );

Parser _jsonNumber() => r"(?<n>-)?(?<b>[0-9]+)(?:\.(?<f>[0-9]+))?(?:[eE](?<s>[+-]?)(?<e>[0-9]+))?".r.map(
      $named(({String? n, String b = "0", String? f, String? s, String? e}) {
        int sign = n == "-" ? -1 : 1;
        num base = int.parse(b) + (f == null ? 0 : double.parse("0.$f"));
        int expSign = s == "-" ? -1 : 1;
        num exp = e == null ? 1 : pow(10, expSign * int.parse(e));

        return sign * base * exp;
      }),
    );

Parser __controlCharBody() => '"' | r"\" | "/" | "b" | "f" | "n" | "r" | "t" | hex * 4;
Parser __controlChar() => r"\" & __controlCharBody;
Parser __stringAvoid() => '"' | __controlChar;
Parser __stringChar() => __controlChar | ~__stringAvoid >> source;
Parser _jsonStringSlow() => '"' & __stringChar.star & '"';

Parser _jsonString() => r"""(")((?:(?:(?=\\)\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4}))|[^"\\\0-\x1F\x7F]+)*)(")""".r();

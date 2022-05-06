import "dart:math";

import "package:parser/internal_all.dart";

part "implementation.dart";

class Parsers {
  // BASIC
  static Parser digit() => _digit();
  static Parser digits() => _digits();

  static Parser lowercase() => _lowercase();
  static Parser uppercase() => _uppercase();

  static Parser lowercaseGreek() => _lowercaseGreek();
  static Parser uppercaseGreek() => _uppercaseGreek();

  static Parser letter() => _letter();
  static Parser letters() => _letters();

  static Parser greek() => _greek();
  static Parser greeks() => _greeks();

  static Parser alphanum() => _alphanum();
  static Parser alphanums() => _alphanums();

  static Parser hex() => _hex();
  static Parser hexes() => _hexes();

  static Parser octal() => _octal();
  static Parser octals() => _octals();

  // STRING
  static Parser string() => _string();
  static Parser singleString() => _singleString();
  static Parser doubleString() => _doubleString();

  // CHAR
  static Parser char() => _char();
  static Parser singleChar() => _singleChar();
  static Parser doubleChar() => _doubleChar();

  // INTEGER /DECIMAL
  static Parser number() => _number();
  static Parser integer() => _integer();
  static Parser decimal() => _decimal();

  // IDENTIFIER
  static Parser identifier() => _identifier();
  static Parser cIdentifier() => _cIdentifier();

  // OPERATOR
  static Parser operator() => _operator();
  static Parser binaryMathOp() => _binaryMathOp();
  static Parser preUnaryMathOp() => _preUnaryMathOp();
  static Parser postUnaryMathOp() => _postUnaryMathOp();

  // JSON NUMBER
  static Parser completeNumberSlow() => _completeNumberSlow();
  static Parser jsonNumberSlow() => _jsonNumberSlow();
  static Parser completeNumber() => _completeNumber();
  static Parser jsonNumber() => _jsonNumber();

  // JSON STRING
  static Parser jsonStringSlow() => _jsonStringSlow();
  static Parser jsonString() => _jsonString();
}

// BASIC
Parser digit() => _digit();
Parser digits() => _digits();

Parser lowercase() => _lowercase();
Parser uppercase() => _uppercase();

Parser lowercaseGreek() => _lowercaseGreek();
Parser uppercaseGreek() => _uppercaseGreek();

Parser letter() => _letter();
Parser letters() => _letters();

Parser greek() => _greek();
Parser greeks() => _greeks();

Parser alphanum() => _alphanum();
Parser alphanums() => _alphanums();

Parser hex() => _hex();
Parser hexes() => _hexes();

Parser octal() => _octal();
Parser octals() => _octals();

// STRING
Parser string([String? pattern]) => pattern == null ? _string() : StringParser(pattern);
Parser singleString() => _singleString();
Parser doubleString() => _doubleString();

// CHAR
Parser char([String? pattern]) => pattern == null ? _char() : CharacterParser(pattern);
Parser singleChar() => _singleChar();
Parser doubleChar() => _doubleChar();

// INTEGER /DECIMAL
Parser number() => _number();
Parser integer() => _integer();
Parser decimal() => _decimal();

// IDENTIFIER
Parser identifier() => _identifier();
Parser cIdentifier() => _cIdentifier();

// OPERATOR
Parser operator() => _operator();
Parser binaryMathOp() => _binaryMathOp();
Parser preUnaryMathOp() => _preUnaryMathOp();
Parser postUnaryMathOp() => _postUnaryMathOp();

// JSON NUMBER
Parser completeNumberSlow() => _completeNumberSlow();
Parser jsonNumberSlow() => _jsonNumberSlow();
Parser completeNumber() => _completeNumber();
Parser jsonNumber() => _jsonNumber();

// JSON STRING
Parser jsonStringSlow() => _jsonStringSlow();
Parser jsonString() => _jsonString();

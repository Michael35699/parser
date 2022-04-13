import "dart:math" as math;

import "package:parser/internal_all.dart";

typedef _NumFunction = num Function(List<num>);

extension on num {
  static num factorialN(num n, num i) {
    if (n <= 0) {
      return i;
    }
    return factorialN(n - 1, n * i);
  }

  num get factorial => factorialN(this, 1);
}

Parser calculatorParser() => _expression.$;

Parser _expression() =>
    // Addition
    // Subtraction
    6.$ ^ _expression[6] & _additiveOp & _expression[5] ^ _$binary |

    // Multiplication
    // Division
    // Modulus
    5.$ ^ _expression[5] & _multiplicativeOp & _expression[4] ^ _$binary |

    // Parenthesis Factor
    5.$ ^ _expression[3] & "(".$ >> _expression[5] << ")".$ ^ _$parenthesisFactor |

    // Negative Expression
    5.$ ^ "[-√]".r.t & _expression[5] ^ _$preUnary |

    // Exponent Expression
    4.$ ^ _expression[3] & "^".$ & _expression[4] ^ _$binary |

    // Factorial Expression
    3.$ ^ _expression[3] & "!".$ ^ _$postUnary |

    // Grouped Expression
    2.$ ^ "(" >> _expression[6] << -")" |

    // Absolute Value
    2.$ ^ "|" >> _expression[6] << "|" ^ _$absolute |

    // Plain Product
    1.$ ^ _expression[1] & ~r"[-\(]".r.t >> _expression[2] ^ _$plainFactor |

    // Wrapped Function Call
    1.$ ^ _identifier & _ws & -"(".$ & (_expression[6] % -",".t).orElse(<num>[]) & -")".$ ^ _$fullFn |

    // Unwrapped Function Call
    1.$ ^ _identifier & _ws & ~"(".$ >> (_expression[0] % -",".t) ^ _$cleanFn |

    // Predefined Constant
    0.$ ^ _constants.keys.map(StringParser.new).choiceParser() ^ _$constant |

    // Degree Number
    0.$ ^ _number & "deg|°|%|rad|r".r ^ _$postUnary |

    // Plain Number
    0.$ ^ _number |

    // Blank
    blank;

Parser _additiveOp() => "[+-]".r.t();
Parser _multiplicativeOp() => r"(?:~\/|\/{2})|[*×\/÷]|%".r.t();
Parser _ws() => -r"\s*".r.nullable();
Parser _identifier() => r"[A-Za-zΑ-Ωα-ω_$:][A-Za-zΑ-Ωα-ω0-9_$-]*".r();
Parser _number() =>
    r"(?:[0-9'_]*\.[0-9'_]+)|(?:[0-9'_]+)".r ^ $type((String c) => c.replaceAll(RegExp("['_]"), "")) >>> num.parse;

final Map<String, int> _functionsArgc = <String, int>{
  "sin": 1,
  "cos": 1,
  "tan": 1,
  "asin": 1,
  "acos": 1,
  "atan": 1,
  "atan2": 2,
  "sec": 1,
  "csc": 1,
  "cot": 1,
  "log-b": 2,
  "log": 1,
  "ln": 1,
  "permutation": 2,
  "combination": 2,
  "sqrt": 1,
  "abs": 1,
  "floor": 1,
  "ceil": 1,
  "round": 1,
  "rad": 1,
  "deg": 1,
  "pow": 2,
  "root": 2,
  "fixed": 2,
};
final Map<String, _NumFunction> _functions = <String, _NumFunction>{
  "sin": (List<num> args) => math.sin(args[0] % (2 * math.pi)),
  "cos": (List<num> args) => math.cos(args[0] % (2 * math.pi)),
  "tan": (List<num> args) => math.tan(args[0] % (2 * math.pi)),
  "sec": (List<num> args) => 1 / math.cos(args[0] % (2 * math.pi)),
  "csc": (List<num> args) => 1 / math.sin(args[0] % (2 * math.pi)),
  "cot": (List<num> args) => 1 / math.tan(args[0] % (2 * math.pi)),
  "asin": (List<num> args) => math.asin(args[0]),
  "acos": (List<num> args) => math.acos(args[0]),
  "atan": (List<num> args) => math.atan(args[0]),
  "atan2": (List<num> args) => math.atan2(args[0], args[1]),
  "log-b": (List<num> args) => math.log(args[1]) / math.log(args[0]),
  "log": (List<num> args) => math.log(args[0]),
  "ln": (List<num> args) => math.log(args[0]) / math.log(math.e),
  "permutation": (List<num> args) => _permutation(args[0], args[1]),
  "combination": (List<num> args) => _combination(args[0], args[1]),
  "sqrt": (List<num> args) => math.sqrt(args[0]),
  "abs": (List<num> args) => args[0] < 0 ? -args[0] : args[0],
  "floor": (List<num> args) => args[0].floor(),
  "ceil": (List<num> args) => args[0].ceil(),
  "round": (List<num> args) => args[0].round(),
  "rad": (List<num> args) => args[0] * (180 / math.pi),
  "deg": (List<num> args) => args[0] * (math.pi / 180),
  "pow": (List<num> args) => math.pow(args[0], args[1]),
  "root": (List<num> args) => math.pow(args[1], 1 / args[0]),
  "fixed": (List<num> args) => num.parse(args[0].toStringAsFixed(args[1].floor()))
};
final Map<String, num> _constants = <String, num>{
  "pi": math.pi,
  "π": math.pi,
  "e": math.e,
  "phi": (1 + math.sqrt(5)) / 2,
  "φ": (1 + math.sqrt(5)) / 2,
};

num _permutation(num n, num r) => n.factorial ~/ (n - r).factorial;
num _combination(num n, num r) => n.factorial ~/ (n - r).factorial ~/ r.factorial;

num _evalFunction(String name, List<num> args) {
  _NumFunction? function = _functions[name];
  int? argc = _functionsArgc[name];

  if (function == null || argc == null) {
    log.error("Unknown function '$name'");
  }

  if (argc != args.length) {
    log.error("Function '$name' requires $argc arguments. Received ${args.length}");
  }

  num result = function(args);

  return result;
}

num _$constant(dynamic r, Context ctx) {
  String key = r as String;
  num value = _constants[key]!;

  return value;
}

num _$absolute(dynamic r, Context ctx) {
  num base = r as num;

  return base < 0 ? -base : base;
}

num _$fullFn(dynamic r, Context ctx) {
  List<dynamic> results = r as List<dynamic>;
  String functionName = results[0] as String;
  List<num> args = List<num>.from(results[1] as List<dynamic>);

  return _evalFunction(functionName, args);
}

num _$cleanFn(dynamic r, Context ctx) {
  List<dynamic> results = r as List<dynamic>;
  String functionName = results[0] as String;
  List<num> args = List<num>.from(results[1] as List<dynamic>);

  return _evalFunction(functionName, args);
}

num _$preUnary(dynamic r, Context ctx) {
  List<dynamic> results = r as List<dynamic>;
  String operator = results[0] as String;
  num value = results[1] as num;

  switch (operator) {
    case "-":
      return -value;
    case "√":
      return math.sqrt(value);
    default:
      log.error("Unknown operator '$operator'");
  }
}

num _$postUnary(dynamic r, Context ctx) {
  return $2((num v, String o) {
    switch (o) {
      case "deg":
      case "°":
        return v * (math.pi / 180);
      case "rad":
      case "r":
        return v * (180 / math.pi);
      case "%":
        return v / 100;
      case "!":
        return v.factorial;
      default:
        log.error("Unknown operator '$o'");
    }
  })(r, ctx)! as num;
}

num _$binary(dynamic r, Context ctx) {
  List<dynamic> results = r as List<dynamic>;
  num left = results[0] as num;
  String operator = results[1] as String;
  num right = results[2] as num;
  num result;

  switch (operator) {
    case "+":
      result = left + right;
      break;
    case "-":
      result = left - right;
      break;
    case "*":
    case "×":
      result = left * right;
      break;
    case "/":
    case "÷":
      result = left / right;
      break;
    case "//":
    case "~/":
      result = left ~/ right;
      break;
    case "mod":
    case "%":
      result = left % right;
      break;
    case "^":
      result = math.pow(left, right);
      break;
    default:
      log.error("Unknown operator '$operator'");
  }

  return result;
}

num _$parenthesisFactor(dynamic r, Context ctx) {
  List<dynamic> results = r as List<dynamic>;

  return (results[0] as num) * (results[1] as num);
}

num _$plainFactor(dynamic r, Context ctx) {
  List<dynamic> results = r as List<dynamic>;

  return (results[0] as num) * (results[1] as num);
}

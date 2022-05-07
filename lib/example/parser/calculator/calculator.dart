import "dart:math" as math;

import "package:parser/parser.dart";
import "package:parser/util.dart";

extension on num {
  num _factorialN(num n, num i) {
    if (n <= 0) {
      return i;
    }
    return _factorialN(n - 1, n * i);
  }

  num get factorial => _factorialN(this, 1);
}

Parser expression() => additive.thunk() ^ $type(_normalizeNum);
Parser additive() =>
    additive & ("+" | "add").t & multiplicative ^ $3((num l, _, num r) => l + r) |
    additive & ("-" | "sub").t & multiplicative ^ $3((num l, _, num r) => l - r) |
    multiplicative;

Parser multiplicative() =>
    multiplicative & ("*" | "×" | "mul").t & preUnary ^ $3((num l, _, num r) => l * r) |
    multiplicative & ("/" | "÷" | "div").t & preUnary ^ $3((num l, _, num r) => l / r) |
    multiplicative & ("~/" | "//" | "fdiv").t & preUnary ^ $3((num l, _, num r) => l ~/ r) |
    multiplicative & ("%" | "mod").t & preUnary ^ $3((num l, _, num r) => l % r) |
    preUnary;

Parser preUnary() =>
    preUnary & "(" >> additive << ")" ^ $2((num l, num r) => l * r) | //
    "-" & preUnary ^ $1((num v) => -v) |
    exponential;

Parser exponential() =>
    factorial & ("^" | "pow").t & exponential ^ $3((num l, _, num r) => math.pow(l, r)) | //
    factorial;

Parser factorial() => factorial << "!" ^ $1((num v) => v.factorial) | group;
Parser group() =>
    "(".t >> additive << ")".t | //
    "|".t >> additive << "|".t ^ $1((num v) => v.abs()) |
    plain;

Parser plain() =>
    plain & ~("-" | "(").t >> group ^ $2((num l, num r) => l * r) | //
    identifier.tr() & -"(" & additive.sep(-",".t).$list<num>().failure(<num>[]) & -")" ^ $2(_evalFunction) |
    identifier.tr() & ~"(" >> plain.sep(-",".t).$list<num>() ^ $2(_evalFunction) |
    atomic;

Parser atomic() =>
    constants.keys.map(StringParser.new).choiceParser().map.$type((String c) => constants[c]!) |
    number << ("deg" / "°") ^ $type((num v) => v * (math.pi / 180)) |
    number << ("rad" / "r") |
    number << "%" ^ $type((num v) => v / 100) |
    number;

Parser number() =>
    r"(?:[0-9'_]*\.[0-9'_]+)|(?:[0-9'_]+)".r ^ $type((String c) => c.replaceAll(RegExp("['_]"), "")) >>> num.parse;

const double dx = 0.0000000001;
final Map<String, int> functionsArgc = <String, int>{
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
  "√": 1,
  "abs": 1,
  "floor": 1,
  "ceil": 1,
  "round": 1,
  "rad-to-deg": 1,
  "deg-to-rad": 1,
  "pow": 2,
  "root": 2,
  "fixed": 2,
};
final Map<String, Function> functions = <String, Function>{
  "sin": (num v) => math.sin(v % (2 * math.pi)),
  "cos": (num v) => math.cos(v % (2 * math.pi)),
  "tan": (num v) => math.tan(v % (2 * math.pi)),
  "sec": (num v) => 1 / math.cos(v % (2 * math.pi)),
  "csc": (num v) => 1 / math.sin(v % (2 * math.pi)),
  "cot": (num v) => 1 / math.tan(v % (2 * math.pi)),
  "asin": (num v) => math.asin(v),
  "acos": (num v) => math.acos(v),
  "atan": (num v) => math.atan(v),
  "atan2": (num a, num b) => math.atan2(a, b),
  "log-b": (num v, num b) => math.log(v) / math.log(b),
  "log": (num v) => math.log(v),
  "ln": (num v) => math.log(v) / math.log(math.e),
  "permutation": (num n, num r) => n.factorial ~/ (n - r).factorial,
  "combination": (num n, num r) => n.factorial ~/ (n - r).factorial ~/ r.factorial,
  "sqrt": (num v) => math.sqrt(v),
  "√": (num v) => math.sqrt(v),
  "abs": (num v) => v < 0 ? -v : v,
  "floor": (num v) => v.floor(),
  "ceil": (num v) => v.ceil(),
  "round": (num v) => v.round(),
  "rad-to-deg": (num v) => v * (180 / math.pi),
  "deg-to-rad": (num v) => v * (math.pi / 180),
  "pow": (num l, num r) => math.pow(l, r),
  "root": (num r, num v) => math.pow(v, 1 / r),
  "fixed": (num l, num f) => num.parse(l.toStringAsFixed(f.floor()))
};
final Map<String, num> constants = <String, num>{
  "pi": math.pi,
  "π": math.pi,
  "e": math.e,
  "phi": (1 + math.sqrt(5)) / 2,
  "φ": (1 + math.sqrt(5)) / 2,
};

num _normalizeNum(num n, [int decimal = 16]) {
  if (n.isNaN || n.isInfinite) {
    return n;
  }

  if (n - n.floor() <= dx) {
    return n.floor();
  }

  if (-dx < n && n < dx) {
    return 0;
  }

  return double.parse(n.toStringAsFixed(decimal));
}

num _evalFunction(String name, List<num> args) {
  Function? function = functions[name];
  int? argc = functionsArgc[name];

  if (function == null || argc == null) {
    log.error("Unknown function '$name'");
  }

  if (argc != args.length) {
    log.error("Function '$name' requires $argc arguments. Received ${args.length}");
  }

  num result = Function.apply(function, args) as num;

  return result;
}

import "package:parser_peg/internal_all.dart";
import "package:parser_peg/src/grammar/text/expression/node.dart";

enum UnaryOperatorType { post, pre }

enum UnaryOperator {
  negative("-", UnaryOperatorType.pre),
  factorial("!", UnaryOperatorType.post),
  ;

  final String representation;
  final UnaryOperatorType type;
  const UnaryOperator(this.representation, this.type);
}

enum BinaryOperator {
  addition("+"),
  subtraction("-"),
  multiplication("*"),
  division("/"),
  floorDivision("~/"),
  modulo("%"),
  exponent("^"),
  ;

  final String representation;
  const BinaryOperator(this.representation);
}

Parser expressionParser() => _expression();

Parser _lambdaParameters() => _lambdaParameter % -",".t | success(<Node>[]);
Parser _lambdaParameter() => identifier();

Parser _expression() => _lambda();
Parser _lambda() =>
    "(".t & _lambdaParameters & ")".t & "->".t & _lambda ^ _$lambdaNode() | //
    "(".t & _lambdaParameters & ")".t & "=>".t & _lambda ^ _$lambdaNode() | //
    _addition;

Parser _addition() =>
    _addition & _binaryPlus & _multiplication ^ _$binaryNode() |
    _addition & _binaryMinus & _multiplication ^ _$binaryNode() |
    _multiplication;

Parser _multiplication() =>
    _multiplication & _binaryStar & _power ^ _$binaryNode() |
    _multiplication & _binarySlash & _power ^ _$binaryNode() |
    _multiplication & _binaryFSlash & _power ^ _$binaryNode() |
    _multiplication & _binaryPercent & _power ^ _$binaryNode() |
    _power;

Parser _power() =>
    _preUnary & _binaryCaret & _power ^ _$binaryNode() | //
    _preUnary & _binaryDoubleStar & _power ^ _$binaryNode() |
    _preUnary;

Parser _preUnary() => _unaryMinus & _postUnary ^ _$preUnaryNode() | _postUnary;
Parser _postUnary() => _postUnary & _unaryExclamation ^ _$postUnaryNode() | _functionCall;
Parser _callParameter() => identifier & ":".t & _expression | _expression;
Parser _functionCall() =>
    _functionCall & "(".t & _callParameter % -",".t & ")".t ^ _$callNode() | //
    _functionCall & "(".t & success(<Node>[]) & ")".t ^ _$callNode() |
    _atomic;

Parser _atomic() => _literal();

Parser _literal() =>
    number ^ _$numberNode() | //
    string ^ _$stringNode() |
    r"[A-Za-z\_\$\:][A-Za-z0-9\_\$\-]*".r ^ _$identifierNode();

Parser _binaryPlus = "+".t ^ $0(() => BinaryOperator.addition);
Parser _binaryMinus = "-".t ^ $0(() => BinaryOperator.subtraction);
Parser _binaryStar = "*".t ^ $0(() => BinaryOperator.multiplication);
Parser _binarySlash = "/".t ^ $0(() => BinaryOperator.division);
Parser _binaryFSlash = "~/".t ^ $0(() => BinaryOperator.floorDivision);
Parser _binaryPercent = "%".t ^ $0(() => BinaryOperator.modulo);
Parser _binaryCaret = "^".t ^ $0(() => BinaryOperator.exponent);
Parser _binaryDoubleStar = "**".t ^ $0(() => BinaryOperator.exponent);
Parser _unaryMinus = "-".t ^ $0(() => UnaryOperator.negative);
Parser _unaryExclamation = "!".t ^ $0(() => UnaryOperator.negative);

MapFunction _$lambdaNode() => $5((_, List<ParseResult> args, __, ___, Node body) {
      List<String> arguments = List<String>.from(args);

      return LambdaNode(parameters: arguments, body: body);
    });
MapFunction _$callNode() => $4((Node target, _, List<ParseResult> args, __) {
      List<Node> positional = <Node>[];
      Map<Symbol, Node> named = <Symbol, Node>{};

      for (ParseResult r in args) {
        if (r is List) {
          named[Symbol(r[0] as String)] = r[2] as Node;
        } else if (r is Node) {
          positional.add(r);
        }
      }

      return FunctionCallNode(
        target: target,
        positional: positional,
        named: named,
      );
    });
MapFunction _$binaryNode() => $3((Node l, BinaryOperator o, Node r) => BinaryNode(left: l, operator: o, right: r));
MapFunction _$postUnaryNode() => $2((Node v, UnaryOperator o) => UnaryNode(value: v, operator: o));
MapFunction _$preUnaryNode() => $2((UnaryOperator o, Node v) => UnaryNode(value: v, operator: o));

MapFunction _$numberNode() => $type((int n) => NumberNode(n));
MapFunction _$stringNode() => $3((_, String content, __) => StringNode(content));
MapFunction _$identifierNode() => $type((String n) => IdentifierNode(n));

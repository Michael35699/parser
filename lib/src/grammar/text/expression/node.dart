import "dart:math";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser_peg/internal_all.dart";
import "package:parser_peg/src/grammar/text/expression/environment.dart";
import "package:parser_peg/src/grammar/text/expression/grammar.dart";

enum NodeType { number, binary, lambda, function, identifier, object, call, none }

@optionalTypeArgs
abstract class Node<T> {
  final NodeType type;

  const Node(this.type);

  T evaluateNew() => evaluate(Environment());
  T evaluate(Environment env);

  @override
  String toString() => "Node";
}

class NumberNode extends Node<num> {
  final num value;
  const NumberNode(this.value) : super(NodeType.number);

  @override
  num evaluate(Environment env) => value;
}

@optionalTypeArgs
class BinaryNode extends Node<num> {
  final Node left;
  final BinaryOperator operator;
  final Node right;
  const BinaryNode({
    required this.left,
    required this.operator,
    required this.right,
  }) : super(NodeType.binary);

  @override
  num evaluate(Environment env) {
    dynamic leftValue = left.evaluate(env);
    dynamic rightValue = right.evaluate(env);
    if (leftValue is num && rightValue is num) {
      switch (operator) {
        case BinaryOperator.addition:
          return leftValue + rightValue;
        case BinaryOperator.subtraction:
          return leftValue - rightValue;
        case BinaryOperator.multiplication:
          return leftValue * rightValue;
        case BinaryOperator.division:
          return leftValue / rightValue;
        case BinaryOperator.floorDivision:
          return leftValue ~/ rightValue;
        case BinaryOperator.modulo:
          return leftValue % rightValue;
        case BinaryOperator.exponent:
          return pow(leftValue, rightValue);
      }
    }

    log.error("Unable to apply binary operator to types '${leftValue.runtimeType}' and '${rightValue.runtimeType}'");
  }
}

@optionalTypeArgs
class UnaryNode extends Node<num> {
  final Node value;
  final UnaryOperator operator;
  const UnaryNode({
    required this.value,
    required this.operator,
  }) : super(NodeType.binary);

  @override
  num evaluate(Environment env) {
    dynamic value = this.value.evaluate(env);
    if (value is num) {
      switch (operator) {
        case UnaryOperator.negative:
          return -value;
        case UnaryOperator.factorial:
          return value;
      }
    }

    log.error("Unable to apply unary operator to type '${value.runtimeType}'");
  }
}

class ValueNode<T extends Object?> extends Node<T> {
  final T value;

  const ValueNode(this.value) : super(NodeType.object);

  @override
  T evaluate(Environment env) => value;
}

class IdentifierNode extends Node<Object> {
  final String name;

  const IdentifierNode(this.name) : super(NodeType.identifier);

  @override
  Object evaluate(Environment env) =>
      (env //
          .search(name)
          ?.evaluate(env) as Object?) ??
      (throw Exception("Undefined identifier '$name'"));
}

class StringNode extends Node<String> {
  final String content;

  const StringNode(this.content) : super(NodeType.identifier);

  @override
  String evaluate(Environment env) => content;
}

class LambdaNode extends Node<Function> {
  final List<String> parameters;
  final Node body;

  LambdaNode({
    required this.parameters,
    required this.body,
  }) : super(NodeType.lambda);

  @override
  Function evaluate(Environment env) {
    return (List<Node> values, Map<Symbol, Node> named) {
      if (values.length != parameters.length) {
        throw Exception("Expected ${parameters.length} values in function, received  ${values.length}");
      }

      Environment environment = env.descendant();
      for (int i = 0; i < parameters.length; i++) {
        environment[parameters[i]] = values[i];
      }

      return body.evaluate(environment);
    };
  }
}

class FunctionNode extends Node<Function> {
  final Function function;

  FunctionNode(this.function) : super(NodeType.function);

  @override
  Function evaluate(Environment env) {
    return (List<Node> values, Map<Symbol, Node> named) {
      Environment environment = env.descendant();
      List<Object?> evaluatedPositional = values.map<dynamic>((Node c) => c.evaluate(environment)).toList();
      Map<Symbol, Object?> evaluatedNamed = <Symbol, Object?>{
        for (MapEntry<Symbol, Node> entry in named.entries) entry.key: entry.value.evaluate(environment),
      };

      return Function.apply(function, evaluatedPositional, evaluatedNamed);
    };
  }
}

class FunctionCallNode extends Node<Object> {
  final Node target;
  final List<Node> positional;
  final Map<Symbol, Node> named;

  const FunctionCallNode({
    required this.target,
    required this.positional,
    required this.named,
  }) : super(NodeType.call);

  @override
  Object evaluate(Environment env) {
    dynamic lambda = target.evaluate(env);
    if (lambda is! Function) {
      throw Exception("Function target is not a function.");
    }
    return (Function.apply(lambda, <Object?>[positional, named]) as Object?) ?? -1;
  }
}

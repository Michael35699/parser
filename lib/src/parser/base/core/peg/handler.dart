// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/packrat/basic.dart";
import "package:parser/src/parser/base/core/peg/packrat/linear.dart";
import "package:parser/src/parser/base/core/peg/packrat/quadratic.dart";
import "package:parser/src/parser/base/core/peg/pure/left.dart";
import "package:parser/src/parser/base/core/peg/pure/pure.dart";

abstract class PegHandler {
  abstract final PegMutable mutable;

  PegHandler();
  factory PegHandler.packrat(PackratMode mode) {
    switch (mode) {
      case PackratMode.basic:
        return BasicPackrat();
      case PackratMode.linear:
        return LinearPackrat();
      case PackratMode.quadratic:
        return QuadraticPackrat();
    }
  }
  factory PegHandler.peg(PegMode mode) {
    switch (mode) {
      case PegMode.pure:
        return PurePeg();
      case PegMode.left:
        return LeftPeg();
    }
  }

  Context parse(Parser parser, Context context);

  @internal
  Context apply(Parser parser, Context context) {
    if (context is ContextFailure) {
      return context;
    }

    if (parser.memoize) {
      return parse(parser, context);
    } else {
      return parser.parsePeg(context, this);
    }
  }
}

// ignore_for_file: deprecated_member_use_from_same_package

import "package:freezed_annotation/freezed_annotation.dart";
import "package:parser/internal_all.dart";
import "package:parser/src/parser/base/core/peg/handler/linear.dart";
import "package:parser/src/parser/base/core/peg/handler/pure.dart";
import "package:parser/src/parser/base/core/peg/handler/quadratic.dart";

abstract class PegHandler {
  static final Map<ParseMode, PegHandler Function()> handlerFactory = <ParseMode, PegHandler Function()>{
    ParseMode.purePeg: () => PegPure.new(PegPureMutable()),
    ParseMode.linearPeg: () => LinearPeg.new(LinearPegMutable()),
    ParseMode.quadraticPeg: () => QuadraticPeg.new(QuadraticPegMutable()),
  };
  abstract final PegMutable mutable;

  const PegHandler();
  factory PegHandler.create(ParseMode mode) {
    return handlerFactory[mode]?.call() ?? (throw Exception("Unsupported PEG type $mode"));
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

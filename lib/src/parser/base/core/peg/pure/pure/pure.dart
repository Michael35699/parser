// ignore_for_file: deprecated_member_use_from_same_package

import "package:parser/internal_all.dart";

class PurePeg extends PegHandler {
  @override
  PegMutable get mutable => Parser.never;

  @override
  Context parse(Parser parser, Context context) => parser.parsePeg(context, this);
}

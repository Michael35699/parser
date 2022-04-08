import "package:parser_peg/internal_all.dart";

mixin SequentialParser on Parser {
  @override
  abstract final List<Parser> children;
}

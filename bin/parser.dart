import "package:parser/parser.dart";

Parser S() => S & "s" | "s";

void main() {
  int i = 0;
  Parser built = S.build().transform((Parser target) =>
      ctx((_) {
        print("${"  " * ++i}$target");

        return empty();
      }) >>
      target.flatMap((_, Context ctx) {
        print("${"  " * i--} $ctx");

        return ctx;
      }));
  print(built.run("sssss"));
}

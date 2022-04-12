import "package:parser_peg/internal_all.dart";

part "utils.dart";

Parser infixMath() => _addition.$;
Parser _addition() => _addition & "+" & _multiplication | _multiplication;
Parser _multiplication() => _multiplication & "*" & _atomic | _atomic;
Parser _atomic() => "[0-9]+".r ^ $type(int.parse) | "(".t & _addition & ")".t;

void main() {
  Parser built = infixMath.build();

  int indentation = -1;
  built.transform((Parser p) => p.cc((ParseFunction fn, Context ctx) {
        ++indentation;
        String ind = "  " * indentation;
        print("$ind$p");
        Context res = fn(ctx);
        if (res is ContextSuccess) {
          print("$ind${res.mappedResult}");
        } else if (res is ContextFailure) {
          print("$ind${res.message}");
        }
        --indentation;

        return res;
      }));
  print(built.run("""1+2*3"""));
}

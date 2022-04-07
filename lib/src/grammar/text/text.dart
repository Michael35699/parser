import "package:parser_peg/parser_peg.dart";
import "package:parser_peg/src/grammar/text/expression/environment.dart";
import "package:parser_peg/src/grammar/text/expression/grammar.dart";
import "package:parser_peg/src/grammar/text/expression/node.dart";

Never error(String message) => throw Exception(message);

Map<String, Function> commonFunctions = <String, Function>{
  "int-parse": int.parse,
  "num-parse": num.parse,
  "double-parse": double.parse,
  "join": (Object? v) => (v as List<Object?>?)?.join(),
};

class TextGrammarDefinition with Grammar {
  final Map<String, Parser> definedRules;
  final Environment main;

  TextGrammarDefinition(this.main) : definedRules = <String, Parser>{};

  @override
  Parser start() => declarations.$type((List<Parser> p) => definedRules["start"]);
  Parser declarations() => declaration.sep(-newline).$type(List<Parser>.from);
  Parser declaration() => identifier & "=".tnl & value[10] ^ $3((String n, _, Parser p) => definedRules[n] = p);

  Parser value() =>
      8.$ ^ value[8] & "|".tnl & value[7] ^ $3((Parser l, _, Parser r) => l | r) |
      7.$ ^ value[6] & "{".t & expressionParser() & "}".t ^ $action() |
      6.$ ^ number & ":".t & value[5] ^ $3((int i, _, Parser p) => i.$ ^ p) |
      5.$ ^ value[5] & whitespace & value[4] ^ $3((Parser l, _, Parser r) => l & r) |
      4.$ ^ value[3] & "%".tnl & value[4] ^ $3((Parser l, _, Parser r) => l % r) |
      3.$ ^ "-".p & value[3] ^ $2((_, Parser p) => drop(p)) |
      3.$ ^ "!".p & value[3] ^ $2((_, Parser p) => negativeLookahead(p)) |
      3.$ ^ value[3] & "*".p ^ $2((Parser p, _) => p.star()) |
      3.$ ^ value[3] & "+".p ^ $2((Parser p, _) => p.plus()) |
      3.$ ^ value[3] & "?".p ^ $2((Parser p, _) => p.optional()) |
      3.$ ^ value[2] & "[".p & number & "]".p ^ $4((Parser p, _, int i, __) => p[i]) |
      2.$ ^ identifier ^ $type((String n) => thunk(() => definedRules[n] ?? noRule(n))) |
      2.$ ^ stringValue ^ $3((_, List<dynamic> r, __) => r.join().p()) |
      2.$ ^ "(".t & value[8] & ")".t ^ $3((_, Parser v, __) => v) |
      2.$ ^ value[1] & ">>".t & value[1] ^ $3((StringParser l, _, StringParser r) => l.pattern.urng(r.pattern)) |
      1.$ ^ charValue ^ $3((_, String c, __) => c.p()) |
      0.$ ^ ".".p ^ $empty(() => drop(whitespace())) |
      blank;

  Parser stringValue() => '"' & stringChar >>> '"' & '"';
  Parser stringChar = r'\"' | ~'"' >> source;

  Parser charValue() => "'" & char & "'";
  Parser char() => r"\'" | ~"'" >> source;
  Parser identifier() => r"[A-Za-zΑ-Ωα-ω\_\$\:][A-Za-zΑ-Ωα-ω0-9\_\$\-]*".r();

  Parser number() => decimal | integer;
  Parser integer = "[0-9]+".r ^ $type(int.parse);
  Parser decimal = r"[0-9]*\.[0-9]+".r ^ $type(double.parse);

  Never noMap(String name) => error("Undefined map function '$name'");
  Never noRule(String name) => error("Undefined rule '$name'");

  MapFunction $action() {
    return $4((Parser p, _, Node n, __) => p.map.$type((ParseResult values) {
          Environment env = Environment();
          for (String key in commonFunctions.keys) {
            env[key] = FunctionNode(commonFunctions[key]!);
          }
          dynamic result = n.evaluate(env);

          if (result is! Function) {
            throw Exception("Parser actions should be a function!");
          }

          return Function.apply(
            result,
            <Object>[
              <Node>[
                if (p.base is SequenceParser)
                  ...(values! as List<ParseResult>).map(ValueNode<ParseResult>.new)
                else
                  ValueNode<ParseResult>.new(values),
              ],
              <Symbol, Node>{}
            ],
          );
        }));
  }
}

extension ParserExtension on String {
  Parser parserString([Map<String, MapFunction> mapFunctions = const <String, MapFunction>{}]) {
    Environment env = Environment();
    Parser? result = TextGrammarDefinition(env).run(this);

    return result ?? (throw Exception("Rule 'start' is not defined."));
  }
}

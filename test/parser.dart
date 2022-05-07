// ignore_for_file: always_specify_types
// cspell: disable

import "package:parser/example/parser/math.dart" as math_parser;
import "package:parser/parser.dart" as parser;
import "package:test/test.dart";

import "util.dart";

void main() {
  group("build", () {
    parser.Parser untouched = math_parser.infix.clone();

    test("equality", () {
      parser.Parser built = untouched.build();

      expect(untouched.equals(built), isFalse);
    });
    test("built flag", () {
      parser.Parser built = untouched.build();

      expect(built.built, isTrue);
    });
    test("ThunkParser removal", () {
      parser.Parser built = untouched.build();
      int thunkCount = built.traverseBf.whereType<parser.ThunkParser>().length;

      expect(thunkCount, 0);
    });
    test("UnwrappedParser removal", () {
      parser.Parser built = untouched.build();
      int unwrappedCount = built.traverseBf.whereType<parser.UnwrappedParser>().length;

      expect(unwrappedCount, 0);
    });
  });

  group("cycle", () {
    test("star", () {
      parser.Parser star = "a".star();

      expect(star, parserSuccess("bb", emptyList));
      expect(star, parserSuccess("", emptyList));
      expect(star, parserSuccess("a", "a".split("")));
      expect(star, parserSuccess("aaaaaaaaa", "aaaaaaaaa".split("")));
    });
    test("plus", () {
      parser.Parser plus = "a".plus();

      expect(plus, parserFailure(""));
      expect(plus, parserFailure("bb"));
      expect(plus, parserSuccess("a", "a".split("")));
      expect(plus, parserSuccess("aaaaaaaaa", "aaaaaaaaa".split("")));
    });
    test("separated", () {
      parser.Parser separated = "a" % ",".t.drop();

      expect(separated, parserSuccess("a", ["a"]));
      expect(separated, parserSuccess("a,a,a,a", ["a", "a", "a", "a"]));
      expect(separated, parserSuccess("a  , a  , a, a", ["a", "a", "a", "a"]));
      expect(separated, parserSuccess("a  , a  ,b", ["a", "a"], i: 6));
    });
    test("cycle_to", () {
      parser.Parser p = ("a" & "b") >>> "c";

      expect(
        p,
        parserSuccess("abababababc", [
          ["a", "b"],
          ["a", "b"],
          ["a", "b"],
          ["a", "b"],
          ["a", "b"]
        ]),
      );
      expect(
        p & "c",
        parserSuccess("abababc", [
          [
            ["a", "b"],
            ["a", "b"],
            ["a", "b"]
          ],
          "c"
        ]),
      );
      expect(
        p.optional() & "c",
        parserSuccess("abc", [
          [
            ["a", "b"]
          ],
          "c"
        ]),
      );
    });
    test("n_times", () {
      parser.Parser grid = "a".$ * 5 * 5;
      parser.Parser p = "λx".$ * 3;

      expect(p, parserSuccess("λxλxλx", ["λx", "λx", "λx"]));
      expect(p, parserSuccess("λxλxλxλxλx", ["λx", "λx", "λx"], i: 6));
      expect(p, parserFailure("λx"));
      expect(
        p * 3,
        parserSuccess("λxλxλxλxλxλxλxλxλx", [
          ["λx", "λx", "λx"],
          ["λx", "λx", "λx"],
          ["λx", "λx", "λx"]
        ]),
      );
      expect(
          grid,
          parserSuccess("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", [
            ["a", "a", "a", "a", "a"],
            ["a", "a", "a", "a", "a"],
            ["a", "a", "a", "a", "a"],
            ["a", "a", "a", "a", "a"],
            ["a", "a", "a", "a", "a"]
          ]));
    });
  });

  group("functions", () {
    group("map", () {
      void run(parser.Parser pass, parser.Parser fail) {
        expect(pass, parserSuccess("ab", ["b", "b"]));

        expect(fail, parserFailure("abc"));
        expect(fail, parserFailure("foo"));
      }

      test("operator", () {
        parser.Parser pass = ("a" ^ parser.$value("b")) & "b";
        parser.Parser never = parser.failure("oh no!") ^ parser.$0(() => fail("this should not be called"));
        run(pass, never);
      });
      test("extension_dot", () {
        parser.Parser pass = "a".$value("b") & "b";
        parser.Parser never = parser.failure("oh no!").$0(() => fail("this should not be called"));
        run(pass, never);
      });
      test("extension_map", () {
        parser.Parser pass = "a".map(parser.$value("b")) & "b";
        parser.Parser never = parser.failure("oh no!").map(parser.$0(() => fail("this should not be called")));

        run(pass, never);
      });
      test("function", () {
        parser.Parser pass = parser.mapped("a", parser.$value("b")) & "b";
        parser.Parser never = parser.mapped(
          parser.failure("oh no!"),
          parser.$0(() => fail("this should not be called")),
        );

        run(pass, never);
      });
      test("constructor", () {
        parser.Parser pass = parser.MappedParser("a".$, parser.$value("b")) & "b";
        parser.Parser never = parser.MappedParser(
          parser.failure("oh no!"),
          parser.$0(() => fail("this should not be called")),
        );

        run(pass, never);
      });
    });
    test("bind", () {
      parser.Parser bound = "a".bind((l, _) => "b".bind((r, _) => parser.success([l, r])));

      expect(bound, parserSuccess("abc", ["a", "b"], i: 2));
      expect(bound, parserFailure("a", message: "Expected value 'b'."));

      parser.Parser alwaysFails = parser.failure("failure").bind((l, _) => fail("shouldn't be called"));

      expect(alwaysFails, parserFailure("foo bar"));
    });
    test("where", () {
      parser.Parser evenNumber = parser.integer.where((p, _) => p is int && p.isEven);

      expect(evenNumber, parserSuccess("12", 12));
      expect(evenNumber, parserFailure("13", message: "Where check failure."));

      parser.Parser alwaysFails = parser.failure("success!").where((p, _) => fail("shouldn't be called"));

      expect(alwaysFails, parserFailure("foo bar", message: "success!"));
    });
    test("flatMap", () {
      parser.Parser flatMapped = "a" & "b".flatMap((r, c) => c.success("$r$r")).star();

      expect(flatMapped, parserSuccess("a", ["a", <String>[]]));
      expect(
          flatMapped,
          parserSuccess("ab", [
            "a",
            ["bb"]
          ]));
      expect(
          flatMapped,
          parserSuccess("abbb", [
            "a",
            ["bb", "bb", "bb"]
          ]));

      parser.Parser guarded = parser.failure("success!").flatMap((r, _) => fail("Should not be called"));

      expect(guarded, parserFailure("foo bar", message: "success!"));
    });
  });

  group("lazy_wrap", () {
    test("thunk", () {
      parser.Parser built() => "a" & "b";
      parser.ThunkParser lazy = parser.thunk(built);

      expect(lazy.computed == built.thunk().computed, isTrue, reason: "ThunkParsers should be memoized.");
      expect(lazy.computed == lazy.base, isTrue, reason: "ThunkParser bases should be the computed");
      expect(lazy, parserSuccess("ab", ["a", "b"]));
      expect(lazy, parserFailure("a", message: "Expected value 'b'."));
    });
  });

  group("leaf", () {
    group("character", () {
      const String template = "abcdefghijklmnopqrstuvwxyz";
      void run(parser.Parser p) {
        expect(p, parserSuccess("ab", "a"));
        expect(p, parserFailure("123", message: "expected alphabet"));
      }

      test("extension_1", () => run(template.character().message("expected alphabet")));
      test("extension_2", () => run(template.c().message("expected alphabet")));
      test("function", () => run(parser.char(template).message("expected alphabet")));
      test("constructor", () => run(parser.CharacterParser(template).message("expected alphabet")));
      test("identity", () {
        parser.Parser parser1 = template.character();
        parser.Parser parser2 = template.c();
        parser.Parser parser3 = parser.char(template);
        parser.Parser parser4 = parser.CharacterParser(template);

        Set<parser.Parser> parsers = {parser1, parser2, parser3, parser4};
        expect(parsers.length, 1);
      });
    });

    group("regex", () {
      const String template = "[0-9]+";
      void run(parser.Parser p) {
        expect(p, parserSuccess("123", "123"));
        expect(p, parserSuccess("012abc", "012"));
        expect(p, parserFailure("", message: "Expected a numerical value."));
      }

      test("extension_1", () => run(template.r().message("Expected a numerical value.")));
      test("extension_2", () => run(template.regex().message("Expected a numerical value.")));
      test("function", () => run(parser.regex(template).message("Expected a numerical value.")));
      test("constructor", () => run(parser.RegExpParser(template).message("Expected a numerical value.")));
      test("dollar", () => run(RegExp(template).$.message("Expected a numerical value.")));
      test("identity", () {
        parser.Parser parser1 = template.r();
        parser.Parser parser2 = template.regex();
        parser.Parser parser3 = parser.regex(template);
        parser.Parser parser4 = parser.RegExpParser(template);
        parser.Parser parser5 = RegExp(template).$;

        Set<parser.Parser> parsers = {parser1, parser2, parser3, parser4, parser5};
        expect(parsers.length, 2); // parser1-4 is identity, parser5 is fresh.
      });
    });

    group("string", () {
      const String template = "foo bar";
      void run(parser.Parser p) {
        expect(p, parserSuccess("foo bar baz", "foo bar"));
        expect(p, parserFailure("hello", message: "Expected value 'foo bar'."));
      }

      test("extension_1", () => run(template.parser()));
      test("extension_2", () => run(template.p()));
      test("function", () => run(parser.string(template)));
      test("constructor", () => run(parser.StringParser(template)));
      test("dollar", () => run(template.$));
      test("identity", () {
        parser.Parser parser1 = template.$;
        parser.Parser parser2 = template.parser();
        parser.Parser parser3 = template.p();
        parser.Parser parser4 = parser.string(template);
        parser.Parser parser5 = parser.StringParser(template);

        Set<parser.Parser> parsers = {parser1, parser2, parser3, parser4, parser5};
        expect(parsers.length, 1);
      });
    });
  });

  group("lookahead", () {
    test("not", () {
      parser.Parser not = "a".not() & "b" | "d";

      expect(not, parserSuccess("b", [#negativeLookahead, "b"]));
      expect(not, parserSuccess("d", "d"));
      expect(not, parserFailure("ab"));
    });

    test("and", () {
      parser.Parser and = "a".and() & "a" & "b" | "c";

      expect(and, parserSuccess("ab", [#positiveLookahead, "a", "b"]));
      expect(and, parserSuccess("cbc", "c"));
      expect(and, parserFailure("df"));
    });
  });

  group("on", () {
    group("failure", () {
      void run(parser.Parser p) {
        expect(p, parserSuccess("b", "b"));
        expect(p, parserSuccess("d", "c"));
      }

      test("operator", () => run("b" ~/ "c"));
      test("extension", () => run("b".failure("c")));
      test("function", () => run(parser.onFailure("b", "c")));
      test("constructor", () => run(parser.OnFailureParser("b".$, "c")));
    });
    group("success", () {
      void run(parser.Parser p) {
        expect(p, parserSuccess("ab", ["a", "c"]));
        expect(p, parserFailure("ac", message: "Expected value 'b'."));
      }

      test("extension", () => run("a" & "b".success("c")));
      test("function", () => run("a" & parser.onSuccess("b", "c")));
      test("constructor", () => run("a" & parser.OnSuccessParser("b".$, "c")));
    });
  });

  group("precedence", () {
    parser.Parser p = 1.$ ^ "a" | 2.$ ^ "a" & "b";
    test("function", () {
      expect(parser.fromPrecedence(1, p), parserSuccess("ab", "a"));
      expect(parser.fromPrecedence(2, p), parserSuccess("ab", ["a", "b"]));
    });
    test("extension_1", () {
      expect(p.from(1), parserSuccess("ab", "a"));
      expect(p.from(2), parserSuccess("ab", ["a", "b"]));
    });
    test("extension_2", () {
      expect(p.fromPrecedence(1), parserSuccess("ab", "a"));
      expect(p.fromPrecedence(2), parserSuccess("ab", ["a", "b"]));
    });
    test("constructor", () {
      expect(parser.FromPrecedenceParser(1, p), parserSuccess("ab", "a"));
      expect(parser.FromPrecedenceParser(2, p), parserSuccess("ab", ["a", "b"]));
    });
    test("operator", () {
      expect(p[1], parserSuccess("ab", "a"));
      expect(p[2], parserSuccess("ab", ["a", "b"]));
    });
  });

  group("predicate", () {
    group("empty", () {
      void run(parser.Parser p) {
        expect(p, parserEmpty("ab"));
        expect(p, parserEmpty(""));
      }

      test("function", () => run(parser.empty()));
      test("constructor", () => run(parser.EmptyParser()));
    });
    group("failure", () {
      void run(parser.Parser p) {
        expect(p, parserFailure("ab"));
        expect(p, parserFailure(""));
      }

      test("function", () => run(parser.failure("no chance")));
      test("constructor", () => run(parser.FailureParser("no chance")));
    });
    group("success", () {
      void run(parser.Parser p) {
        expect(p, parserSuccess("ab", "yes chance"));
        expect(p, parserSuccess("", "yes chance"));
      }

      test("function", () => run(parser.success("yes chance")));
      test("constructor", () => run(parser.SuccessParser("yes chance")));
    });
  });

  group("special", () {
    group("blank", () {
      void run(parser.Parser p) {
        expect(p, parserFailure("any input", message: "Blank"));
        expect(p, parserFailure("doesn't work", message: "Blank"));
      }

      test("function", () => run(parser.blank()));
      test("constructor", () => run(parser.BlankParser()));
    });
    group("eoi", () {
      void run(parser.Parser p) {
        expect(p, parserFailure("foo", message: "Expected end of input."));
        expect(p, parserSuccess("", #eoi));
      }

      test("function", () => run(parser.eoi()));
      test("constructor", () => run(parser.EoiParser()));
    });
    group("epsilon", () {
      void run(parser.Parser p) {
        expect(p, parserSuccess("", ""));
        expect(p, parserSuccess("abc", ""));
      }

      test("function", () => run(parser.epsilon()));
      test("constructor", () => run(parser.EpsilonParser()));
    });
    group("source", () {
      void run(parser.Parser p) {
        expect(parser.source(), parserFailure("", message: "Expected any character, received end of input"));
        expect(parser.source(), parserSuccess("abc", "a"));
      }

      test("function", () => run(parser.source()));
      test("constructor", () => run(parser.SourceParser()));
    });
  });

  group("wrap", () {
    group("cache", () {
      parser.Parser delegate = parser.letters().message("Expected letters");
      void run(parser.Parser p) {
        expect(p, parserFailure("", message: "Expected letters"));
        expect(p, parserSuccess("abc", "abc"));
      }

      test("extension", () => run(delegate.cache()));
      test("function", () => run(parser.cache(delegate)));
      test("constructor", () => run(parser.CacheParser(delegate)));
    });
    group("continuation", () {
      parser.Parser delegate = "a".parser();
      void run(parser.Parser p) {
        expect(p, parserFailure("b"));
        expect(p, parserSuccess("a", "a"));
      }

      test("extension", () => run(delegate.cc((fn, ctx) => fn(ctx))));
      test("function", () => run(parser.ContinuationParser(delegate, (fn, ctx) => fn(ctx))));
    });
    group("drop", () {
      parser.Parser delegate = "ab".parser();
      void run(parser.Parser p) {
        expect(p, parserEmpty("ab"));
        expect(p, parserFailure("ac"));
      }

      test("extension", () => run(delegate.drop()));
      test("function", () => run(parser.drop(delegate)));
      test("constructor", () => run(parser.DropParser(delegate)));
    });
    group("except", () {
      parser.Parser delegate = "foo".parser();
      parser.Parser except = "foob".parser();
      void run(parser.Parser p) {
        expect(p, parserSuccess("foo", "foo"));
        expect(p, parserFailure("foob"));
      }

      test("operator", () => run(delegate - except));
      test("extension", () => run(delegate.except(except)));
      test("function", () => run(parser.except(delegate, except)));
      test("constructor", () => run(parser.ExceptParser(delegate, except)));
    });
    group("failure_message", () {
      parser.Parser delegate = parser.string();
      void run(parser.Parser p) {
        expect(p, parserSuccess("'hello world!'", ["'", "hello world!", "'"]));
        expect(p, parserFailure("'hello world!", message: "Expected string literal"));
      }

      test("extension", () => run(delegate.message("Expected string literal")));
      test("function", () => run(parser.failureMessage(delegate, "Expected string literal")));
      test("constructor", () => run(parser.FailureMessageParser(delegate, "Expected string literal")));
    });
    group("flat", () {
      parser.Parser template = "foo" & parser.ws >> "bar" & parser.ws >> "baz";
      void run(parser.Parser p) {
        expect(p, parserSuccess("foo bar baz", "foo bar baz"));
        expect(p, parserSuccess("foobarbaz", "foobarbaz"));
        expect(p, parserFailure("foo"));
      }

      test("extension", () => run(template.flat()));
      test("function", () => run(parser.flat(template)));
      test("constructor", () => run(parser.FlatParser(template)));
    });
    group("optional", () {
      parser.Parser delegate = "a".parser();
      void run(parser.Parser p) {
        expect(p, parserSuccess("a", "a"));
        expect(p, parserSuccess("b", null));
      }

      test("extension", () => run(delegate.optional()));
      test("function", () => run(parser.optional(delegate)));
      test("constructor", () => run(parser.OptionalParser(delegate)));
    });
    group("trim", () {
      parser.Parser left = parser.string("a");
      parser.Parser delegate = parser.operator();
      parser.Parser right = parser.string("b");

      group("trim_newline", () {
        group("trim_left", () {
          void run(parser.Parser p) {
            expect(p, parserSuccess("a+b", ["a", "+", "b"]));
            expect(p, parserSuccess("a \n \n +b", ["a", "+", "b"]));
            expect(p, parserFailure("a+  \n b"));
            expect(p, parserFailure("a \n  + \n  b"));
          }

          test("extension_1", () => run(left & delegate.trimNewlineLeft() & right));
          test("extension_2", () => run(left & delegate.tnlLeft() & right));
          test("function", () => run(left & parser.trimNewlineLeft(delegate) & right));
        });
        group("trim_right", () {
          void run(parser.Parser p) {
            expect(p, parserSuccess("a+b", ["a", "+", "b"]));
            expect(p, parserSuccess("a+  \n b", ["a", "+", "b"]));
            expect(p, parserFailure("a \n \n +b"));
            expect(p, parserFailure("a \n  + \n  b"));
          }

          test("extension_1", () => run(left & delegate.trimNewlineRight() & right));
          test("extension_2", () => run(left & delegate.tnlRight() & right));
          test("function", () => run(left & parser.trimNewlineRight(delegate) & right));
        });
        group("trim_left_right", () {
          void run(parser.Parser p) {
            expect(p, parserSuccess("a+b", ["a", "+", "b"]));
            expect(p, parserSuccess("a+  \n b", ["a", "+", "b"]));
            expect(p, parserSuccess("a \n \n +b", ["a", "+", "b"]));
            expect(p, parserSuccess("a \n  + \n  b", ["a", "+", "b"]));
          }

          test("extension_1", () => run(left & delegate.trimNewline() & right));
          test("extension_2", () => run(left & delegate.tnl() & right));
          test("function", () => run(left & parser.trimNewline(delegate) & right));
        });
      });
      group("trim", () {
        group("trim_left", () {
          void run(parser.Parser p) {
            expect(p, parserSuccess("a+b", ["a", "+", "b"]));
            expect(p, parserSuccess("a   +b", ["a", "+", "b"]));
            expect(p, parserFailure("a+   b"));
            expect(p, parserFailure("a   +   b"));
          }

          test("extension_1", () => run(left & delegate.trimLeft() & right));
          test("extension_2", () => run(left & delegate.tl() & right));
          test("function", () => run(left & parser.trimLeft(delegate) & right));
        });
        group("trim_right", () {
          void run(parser.Parser p) {
            expect(p, parserSuccess("a+b", ["a", "+", "b"]));
            expect(p, parserSuccess("a+   b", ["a", "+", "b"]));
            expect(p, parserFailure("a   +b"));
            expect(p, parserFailure("a   +   b"));
          }

          test("extension_1", () => run(left & delegate.trimRight() & right));
          test("extension_2", () => run(left & delegate.tr() & right));
          test("function", () => run(left & parser.trimRight(delegate) & right));
        });
        group("trim_left_right", () {
          void run(parser.Parser p) {
            expect(p, parserSuccess("a+b", ["a", "+", "b"]));
            expect(p, parserSuccess("a+   b", ["a", "+", "b"]));
            expect(p, parserSuccess("a   +b", ["a", "+", "b"]));
            expect(p, parserSuccess("a   +   b", ["a", "+", "b"]));
          }

          test("extension_1", () => run(left & delegate.trim() & right));
          test("extension_2", () => run(left & delegate.t() & right));
          test("function", () => run(left & parser.trim(delegate) & right));
        });
      });
    });
  });
}

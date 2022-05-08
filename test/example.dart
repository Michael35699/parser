// ignore_for_file: always_specify_types

import "package:parser/example/grammar/xml/xml.dart" as xml;
import "package:parser/parser.dart" as p;
import "package:test/test.dart";

import "util.dart";

void main() {
  group("xml", () {
    group("parser", () {
      xml.XmlGrammar grammar = xml.XmlGrammar();

      group("single_tag", () {
        p.Parser parser = grammar.singleTag();

        test("empty", () {
          expect(parser, parserSuccess("<alpha />", ["alpha", emptyList]));
        });
        test("implicit_property", () {
          expect(
              parser,
              parserSuccess("<alpha beta />", [
                "alpha",
                [
                  ["beta", "true"]
                ]
              ]));
          expect(
              parser,
              parserSuccess("<alpha beta gamma />", [
                "alpha",
                [
                  ["beta", "true"],
                  ["gamma", "true"]
                ]
              ]));
        });
        test("explicit_property", () {
          expect(
              parser,
              parserSuccess("<alpha beta='gamma'/>", [
                "alpha",
                [
                  ["beta", "gamma"],
                ]
              ]));
          expect(
              parser,
              parserSuccess("<alpha beta='gamma' delta='epsilon'/>", [
                "alpha",
                [
                  ["beta", "gamma"],
                  ["delta", "epsilon"],
                ]
              ]));
        });
        test("mixed", () {
          expect(
              parser,
              parserSuccess("<alpha beta='gamma' delta/>", [
                "alpha",
                [
                  ["beta", "gamma"],
                  ["delta", "true"]
                ]
              ]));
          expect(
              parser,
              parserSuccess("<alpha beta='gamma' delta epsilon='zeta'/>", [
                "alpha",
                [
                  ["beta", "gamma"],
                  ["delta", "true"],
                  ["epsilon", "zeta"],
                ]
              ]));
        });
      });
      group("block_tag", () {
        p.Parser parser = grammar.blockTag();

        group("empty", () {
          test("childless", () {
            expect(
                parser,
                parserSuccess("<alpha></alpha>", [
                  ["alpha", emptyList],
                  emptyList,
                  "alpha"
                ]));

            expect(
                parser,
                parserSuccess("<alpha></beta>", [
                  ["alpha", emptyList],
                  emptyList,
                  "beta"
                ]));
          });
          group("single_child", () {
            test("text_node", () {
              expect(
                  parser,
                  parserSuccess("<alpha>hello</alpha>", [
                    ["alpha", emptyList],
                    ["hello"],
                    "alpha"
                  ]));
              expect(
                  parser,
                  parserSuccess("<alpha>hello my name</alpha>", [
                    ["alpha", emptyList],
                    ["hello my name"],
                    "alpha"
                  ]));
            });
            group("html_node", () {
              test("single_node", () {
                expect(
                    parser,
                    parserSuccess("<alpha><single-node/></alpha>", [
                      ["alpha", emptyList],
                      [
                        ["single-node", emptyList]
                      ],
                      "alpha"
                    ]));
              });
            });
          });
        });
      });
    });
  });
}

import "package:parser/example.dart" as xml;
import "package:parser/parser.dart" as parser;
import "package:parser/src/util/logger/logger.dart";

int counter = 0;

typedef Parser = parser.Parser;
typedef XmlGrammar = xml.XmlGrammar;

void main() {
  xml.XmlEvaluator grammar = xml.XmlEvaluator();
  Parser parser = grammar.start.build();
  print(parser.peg("""
<html>
  <head>Heading</head>
  <body attr1=true>
    <div class='container'>
        <div id='class'>Something here</div>
        <div>Something else</div>
        impossible
    </div>
  </body>
</html>""", except: log.cerror));
}

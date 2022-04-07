import "package:parser_peg/internal_all.dart";

typedef O = Object;

class MarkdownGrammar with Grammar {
  @override
  Parser start() => body.$;
  Parser body() => table | atomic | r"\s".r ^ $empty(() => "");

  Parser atomics([List<LazyParser> toExclude = const <LazyParser>[]]) => atomic(toExclude).cycle();
  Parser atomic([List<LazyParser> toExclude = const <LazyParser>[]]) =>
      (<O>[bold, italic, strikeThrough, hyperlink] + <O>[image, paragraph, basicCharacter])
          .where((O it) => !toExclude.contains(it))
          .map(Parser.resolve)
          .choiceParser();

  // Italic
  Parser italic() => star & italicBody & star;
  Parser italicBody() => italicAtomic >>> italicDelimiter;
  Parser italicDelimiter() => ctx((Set<Symbol> data) => data.contains(#bold) ? star : ~doubleStar >> star);
  Parser italicAtomic() => atomic.rest(italic, basicCharacter) | ~star >> basicCharacter;

  Parser star = "*".p();

  // Bold
  Parser bold() => doubleStar & push(#bold) & boldBody & pop(#bold) & doubleStar;
  Parser boldBody() => boldAtomic >>> doubleStar;
  Parser boldAtomic() => atomic.rest(bold, basicCharacter) | ~doubleStar >> basicCharacter;

  Parser doubleStar = "**".p();

  // Strike Through
  Parser strikeThrough() => doubleTilde & strikeThroughBody & doubleTilde;
  Parser strikeThroughBody() => strikeThroughAtomic >>> doubleTilde;
  Parser strikeThroughAtomic() => atomic.rest(strikeThrough, basicCharacter) | ~doubleTilde >> basicCharacter;

  Parser doubleTilde = "~~".p();

  // Hyperlink
  Parser hyperlink() => "[" & hyperlinkDisplay & "]" & whitespace & "(" & hyperlinkUrl & ")";
  Parser hyperlinkDisplay() => hyperlinkDisplayAtomic >>> "]";
  Parser hyperlinkDisplayAtomic() => atomic.rest(basicCharacter) | ~"]" >> basicCharacter;
  Parser hyperlinkUrl() => hyperlinkUrlAtomic >>> ")";
  Parser hyperlinkUrlAtomic() => atomic.rest(basicCharacter) | ~")" >> basicCharacter;

  // Image
  Parser image() => "![" & imageDisplay & "]" & whitespace & "(" & imageUrl & ")";
  Parser imageDisplay() => imageDisplayAtomic >>> "]";
  Parser imageDisplayAtomic() => atomic.rest(basicCharacter) | ~"]" >> basicCharacter;
  Parser imageUrl() => imageUrlAtomic >>> ")";
  Parser imageUrlAtomic() => atomic.rest(basicCharacter) | ~")" >> basicCharacter;

  // Paragraph
  Parser paragraph() => paragraphBody >>> ("\n\n" | eoi);
  Parser paragraphBody() => ~"\n\n" >> atomic.rest(paragraph);

  // Table
  Parser table() => tableRow & nl & tableFormatRow & nl & (tableRow % nl);

  Parser tableRow() => bar >> tableRowBody << bar;
  Parser tableRowBody() => tableCharacters % tableCellSeparator;
  Parser tableCharacters() => tableCharacter >>> tableCellSeparator;
  Parser tableCharacter() => escapedBar | ~bar >> atomic.rest(paragraph);

  Parser tableFormatRow() => bar >> (center | left | right | default_).t % bar << bar;
  Parser tableCellSeparator() => (~escapedBar >> bar).drop();

  Parser default_ = double.infinity.$ ^ "-".plus;
  Parser left = ":" & "-".plus;
  Parser right = "-".plus & ":";
  Parser center = ":" & "-".plus & ":";

  Parser bar = "|".p();
  Parser nl = -newline;
  Parser ws = r"[ \t]+".r();
  Parser escapedBar = r"\|".p();

  Parser basicCharacter() => ~nl >> source;
}

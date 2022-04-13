// cspell: disable

import "dart:io";
import "dart:math";

import "package:ansicolor/ansicolor.dart" as ansi;
import "package:parser/internal_all.dart";
import "package:path/path.dart" as path;

final ansi.AnsiPen _red = ansi.AnsiPen()..red();
final ansi.AnsiPen _lime = ansi.AnsiPen()..xterm(002);
final ansi.AnsiPen _blue = ansi.AnsiPen()..xterm(012);
final ansi.AnsiPen _green = ansi.AnsiPen()..green();
final ansi.AnsiPen _orange = ansi.AnsiPen()..xterm(172);
final ansi.AnsiPen _greyish = ansi.AnsiPen()..xterm(247);

// ignore_for_file: avoid_field_initializers_in_const_classes
class Logger {
  const Logger()
      : successln = _success,
        println = _print,
        warnln = _warn,
        documentorln = _documentor,
        cerrorln = _cerror,
        errorln = _error,
        todoln = _todo,
        writeln = _writeln,
        success = _success,
        print = _print,
        warn = _warn,
        documentor = _documentor,
        cerror = _cerror,
        error = _error,
        todo = _todo;

  final void Function(Object?, [Metadata?]) successln;
  final void Function(Object?, [Metadata?]) println;
  final void Function(Object?, [Metadata?]) warnln;
  final void Function(Object?, [Metadata?]) documentorln;
  final void Function(Object?, [Metadata?]) cerrorln;
  final Never Function(Object?, [Metadata?]) errorln;
  final Never Function(Object?, [Metadata?]) todoln;
  final void Function(Object?, [Metadata?]) writeln;
  final void Function(Object?, [Metadata?]) success;
  final void Function(Object?, [Metadata?]) print;
  final void Function(Object?, [Metadata?]) warn;
  final void Function(Object?, [Metadata?]) documentor;
  final void Function(Object?, [Metadata?]) cerror;
  final Never Function(Object?, [Metadata?]) error;
  final Never Function(Object?, [Metadata?]) todo;
}

Metadata _generateMetadata() {
  String stack = StackTrace.current.toString();
  String capturedLine = stack.split("\n")[2];
  String noParenthesis = capturedLine.substring(0, capturedLine.length - 1);
  List<String> split = noParenthesis.split(":");

  List<String> lastTwo = split.sublist(split.length - 2, split.length);
  List<int> parsed = lastTwo
      .where((String c) => int.tryParse(c) != null) //
      .map((String c) => int.parse(c))
      .toList();

  String url = _shortenUrl(
    split
        .sublist(split.length - parsed.length - 2, split.length - parsed.length)
        .join(":") //
        .substring(3),
  );

  if (parsed.length < 2) {
    return Metadata(start: 0, end: 0, index: 0, line: 0, raw: "", url: url);
  }

  return Metadata(start: 0, end: 0, index: parsed[1], line: parsed[0], raw: "", url: url);
}

String _msg(Object? message, Metadata m) {
  return "[${m.url}](${m.line}, ${m.index}): $message";
  // return "$message";
}

String _normalizeAbsoluteUrl(String url) {
  return path.prettyUri(path.absolute(url).split("/").join(r"\").split(r"\").join("/"));
}

Never _error(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stderr.writeln(_red(_msg(message, m)));
  exit(255);
}

void _cerror(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stderr.writeln(_red(_msg(message, m)));
}

void _warn(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stderr.writeln(_orange(_msg(message, m)));
}

void _print(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stdout.writeln(_blue(_msg(message, m)));
}

void _success(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stdout.writeln(_green(_msg(message, m)));
}

void _documentor(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stdout.writeln(_greyish(_msg(message, m)));
}

void _writeln(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stdout.writeln(_msg(message, m));
}

Never _todo(Object? message, [Metadata? meta]) {
  Metadata m = meta ?? _generateMetadata();

  stderr.writeln(_lime(_msg("TODO: $message", m)));
  exit(255);
}

String _shortenUrl(String url) {
  List<String> newSplits = <String>[];
  List<String> splits = url.split("/").join(r"\").split(r"\").map((String k) => k.trim()).toList();

  for (String split in splits) {
    if (split != splits.last) {
      newSplits.add(split.substring(0, min(split.length, 3)));
    } else {
      newSplits.add(split);
    }
  }

  if (splits.length >= 4) {
    return _normalizeAbsoluteUrl(
      <String>[...newSplits.sublist(0, 1), "...", ...newSplits.sublist(newSplits.length - 3, newSplits.length)]
          .join("/"),
    );
  } else {
    return _normalizeAbsoluteUrl(newSplits.join("/"));
  }
}

enum TimeUnit { picosecond, nanosecond, microsecond, millisecond, second, minute, hour, day, month, year }

const Logger log = Logger();

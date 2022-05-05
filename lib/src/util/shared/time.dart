R time<R extends Object?>(R Function() callback, {int? count, String? name, Symbol? functionSignature}) {
  count ??= 1;

  Stopwatch watch = Stopwatch()..start();
  for (int i = 0; i < count - 1; i++) {
    callback();
  }
  R result = callback();
  watch.stop();

  print("Time${name == null ? "" : "[$name]"}: ${formatMicroseconds(watch.elapsedMicroseconds ~/ count)}");

  return result;
}

extension NamedTimeFunctionExtension<R> on R Function(R Function() callback,
    {int? count, String? name, Symbol? functionSignature}) {
  R named(String name, R Function() callback) => this(callback, name: name);
  R average(int count, R Function() callback) => this(callback, count: count);
}

String formatMicroseconds(int value) {
  const Map<int, String> table = <int, String>{
    1 * 1000 * 1000 * 60 * 60 * 24 * 30: "months",
    1 * 1000 * 1000 * 60 * 60 * 24: "days",
    1 * 1000 * 1000 * 60 * 60: "hr",
    1 * 1000 * 1000 * 60: "m",
    1 * 1000 * 1000: "s",
    1 * 1000: "ms",
    1: "μs",
  };

  StringBuffer buffer = StringBuffer();
  int currentDenomination = value;

  for (MapEntry<int, String> entry in table.entries) {
    int current = 0;
    while (entry.key <= currentDenomination) {
      currentDenomination -= entry.key;
      current++;
    }

    if (current == 0) {
      continue;
    }

    buffer.write("$current ${entry.value} ");
  }

  return buffer.toString().trimRight();
}

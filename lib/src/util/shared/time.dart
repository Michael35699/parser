T time<T>(T Function() callback, {String? name, Symbol? functionSignature}) {
  Stopwatch watch = Stopwatch()..start();
  T result = callback();
  watch.stop();

  print("Time${name == null ? "" : "[$name]"}: ${formatMicroseconds(watch.elapsedMicroseconds)}");

  return result;
}

extension NamedTimeFunctionExtension<T> on V Function<V extends T>(V Function() callback,
    {String? name, Symbol? functionSignature}) {
  T named(String name, T Function() callback) => this(callback, name: name);
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

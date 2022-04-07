extension NumberLoopExtension on int {
  Iterable<int> get times sync* {
    for (int i = 0; i < this; i++) {
      yield i;
    }
  }

  Iterable<int> to(int target) sync* {
    if (this < target) {
      for (int i = this; i < target; i++) {
        yield i;
      }
    } else {
      for (int i = this; i > target; i--) {
        yield i;
      }
    }
  }

  // Adds one if target is positive, else subtracts.
  Iterable<int> toEq(int target) => to(target + target ~/ target.abs());
}

extension IterableLoopExtension<T> on Iterable<T> {
  Iterable<T> by(int skip) sync* {
    int counter = 0;

    for (T item in this) {
      if (counter++ % skip == 0) {
        yield item;
      }
    }
  }
}

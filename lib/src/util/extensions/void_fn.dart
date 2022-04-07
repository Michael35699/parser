extension PrintExtension on void Function(Object?) {
  void Function(Object?) operator <<(Object? item) {
    this(item);

    return this;
  }
}

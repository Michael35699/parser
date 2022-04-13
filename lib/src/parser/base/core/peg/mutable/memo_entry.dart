mixin MemoizationEntryValue {}

class PegMemoizationEntry {
  MemoizationEntryValue value;

  PegMemoizationEntry(this.value);
}

extension MemoizationExtensionEntry on MemoizationEntryValue {
  PegMemoizationEntry entry() => PegMemoizationEntry(this);
}

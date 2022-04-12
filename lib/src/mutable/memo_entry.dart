mixin MemoizationEntryValue {}

class MemoizationEntry {
  MemoizationEntryValue value;

  MemoizationEntry(this.value);
}

extension MemoizationExtensionEntry on MemoizationEntryValue {
  MemoizationEntry entry() => MemoizationEntry(this);
}

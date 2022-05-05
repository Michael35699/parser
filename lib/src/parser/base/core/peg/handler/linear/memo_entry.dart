mixin LinearPegMemoValue {}

class PegMemoizationEntry {
  LinearPegMemoValue value;

  PegMemoizationEntry(this.value);
}

extension MemoizationExtensionEntry on LinearPegMemoValue {
  PegMemoizationEntry entry() => PegMemoizationEntry(this);
}

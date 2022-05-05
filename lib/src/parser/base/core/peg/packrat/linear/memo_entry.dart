mixin LinearPegMemoValue {}

class MemoizationEntry {
  LinearPegMemoValue value;

  MemoizationEntry(this.value);
}

extension MemoizationExtensionEntry on LinearPegMemoValue {
  MemoizationEntry entry() => MemoizationEntry(this);
}

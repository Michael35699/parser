mixin QuadraticPegMemoValue {}

class MemoizationEntry {
  QuadraticPegMemoValue value;

  MemoizationEntry(this.value);
}

extension MemoizationExtensionEntry on QuadraticPegMemoValue {
  MemoizationEntry entry() => MemoizationEntry(this);
}

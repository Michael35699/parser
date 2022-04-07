mixin DisabledMappers {
  @override
  dynamic noSuchMethod(Invocation invocation) => invocation.positionalArguments[0];
}

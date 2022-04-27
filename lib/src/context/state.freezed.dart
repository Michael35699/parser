// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$State {
  String get input => throw _privateConstructorUsedError;
  ParseMode get mode => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  num get precedence => throw _privateConstructorUsedError;
  List<int> get indentStack => throw _privateConstructorUsedError;
  Set<dynamic> get dataSet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StateCopyWith<State> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateCopyWith<$Res> {
  factory $StateCopyWith(State value, $Res Function(State) then) =
      _$StateCopyWithImpl<$Res>;
  $Res call(
      {String input,
      ParseMode mode,
      int index,
      num precedence,
      List<int> indentStack,
      Set<dynamic> dataSet});
}

/// @nodoc
class _$StateCopyWithImpl<$Res> implements $StateCopyWith<$Res> {
  _$StateCopyWithImpl(this._value, this._then);

  final State _value;
  // ignore: unused_field
  final $Res Function(State) _then;

  @override
  $Res call({
    Object? input = freezed,
    Object? mode = freezed,
    Object? index = freezed,
    Object? precedence = freezed,
    Object? indentStack = freezed,
    Object? dataSet = freezed,
  }) {
    return _then(_value.copyWith(
      input: input == freezed
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ParseMode,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      precedence: precedence == freezed
          ? _value.precedence
          : precedence // ignore: cast_nullable_to_non_nullable
              as num,
      indentStack: indentStack == freezed
          ? _value.indentStack
          : indentStack // ignore: cast_nullable_to_non_nullable
              as List<int>,
      dataSet: dataSet == freezed
          ? _value.dataSet
          : dataSet // ignore: cast_nullable_to_non_nullable
              as Set<dynamic>,
    ));
  }
}

/// @nodoc
abstract class $StateDefaultCopyWith<$Res> implements $StateCopyWith<$Res> {
  factory $StateDefaultCopyWith(
          StateDefault value, $Res Function(StateDefault) then) =
      _$StateDefaultCopyWithImpl<$Res>;
  @override
  $Res call(
      {String input,
      ParseMode mode,
      int index,
      num precedence,
      List<int> indentStack,
      Set<dynamic> dataSet});
}

/// @nodoc
class _$StateDefaultCopyWithImpl<$Res> extends _$StateCopyWithImpl<$Res>
    implements $StateDefaultCopyWith<$Res> {
  _$StateDefaultCopyWithImpl(
      StateDefault _value, $Res Function(StateDefault) _then)
      : super(_value, (v) => _then(v as StateDefault));

  @override
  StateDefault get _value => super._value as StateDefault;

  @override
  $Res call({
    Object? input = freezed,
    Object? mode = freezed,
    Object? index = freezed,
    Object? precedence = freezed,
    Object? indentStack = freezed,
    Object? dataSet = freezed,
  }) {
    return _then(StateDefault(
      input: input == freezed
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ParseMode,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      precedence: precedence == freezed
          ? _value.precedence
          : precedence // ignore: cast_nullable_to_non_nullable
              as num,
      indentStack: indentStack == freezed
          ? _value.indentStack
          : indentStack // ignore: cast_nullable_to_non_nullable
              as List<int>,
      dataSet: dataSet == freezed
          ? _value.dataSet
          : dataSet // ignore: cast_nullable_to_non_nullable
              as Set<dynamic>,
    ));
  }
}

/// @nodoc

class _$StateDefault extends StateDefault {
  _$StateDefault(
      {required this.input,
      this.mode = ParseMode.purePeg,
      this.index = 0,
      this.precedence = double.infinity,
      final List<int> indentStack = const <int>[],
      final Set<dynamic> dataSet = const <dynamic>{}})
      : _indentStack = indentStack,
        _dataSet = dataSet,
        super._();

  @override
  final String input;
  @override
  @JsonKey()
  final ParseMode mode;
  @override
  @JsonKey()
  final int index;
  @override
  @JsonKey()
  final num precedence;
  final List<int> _indentStack;
  @override
  @JsonKey()
  List<int> get indentStack {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_indentStack);
  }

  final Set<dynamic> _dataSet;
  @override
  @JsonKey()
  Set<dynamic> get dataSet {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_dataSet);
  }

  @override
  String toString() {
    return 'State(input: $input, mode: $mode, index: $index, precedence: $precedence, indentStack: $indentStack, dataSet: $dataSet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateDefault &&
            const DeepCollectionEquality().equals(other.input, input) &&
            const DeepCollectionEquality().equals(other.mode, mode) &&
            const DeepCollectionEquality().equals(other.index, index) &&
            const DeepCollectionEquality()
                .equals(other.precedence, precedence) &&
            const DeepCollectionEquality()
                .equals(other.indentStack, indentStack) &&
            const DeepCollectionEquality().equals(other.dataSet, dataSet));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(input),
      const DeepCollectionEquality().hash(mode),
      const DeepCollectionEquality().hash(index),
      const DeepCollectionEquality().hash(precedence),
      const DeepCollectionEquality().hash(indentStack),
      const DeepCollectionEquality().hash(dataSet));

  @JsonKey(ignore: true)
  @override
  $StateDefaultCopyWith<StateDefault> get copyWith =>
      _$StateDefaultCopyWithImpl<StateDefault>(this, _$identity);
}

abstract class StateDefault extends State {
  factory StateDefault(
      {required final String input,
      final ParseMode mode,
      final int index,
      final num precedence,
      final List<int> indentStack,
      final Set<dynamic> dataSet}) = _$StateDefault;
  StateDefault._() : super._();

  @override
  String get input => throw _privateConstructorUsedError;
  @override
  ParseMode get mode => throw _privateConstructorUsedError;
  @override
  int get index => throw _privateConstructorUsedError;
  @override
  num get precedence => throw _privateConstructorUsedError;
  @override
  List<int> get indentStack => throw _privateConstructorUsedError;
  @override
  Set<dynamic> get dataSet => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $StateDefaultCopyWith<StateDefault> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StateSnapshot {
  int get index => throw _privateConstructorUsedError;
  num get precedence => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StateSnapshotCopyWith<StateSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateSnapshotCopyWith<$Res> {
  factory $StateSnapshotCopyWith(
          StateSnapshot value, $Res Function(StateSnapshot) then) =
      _$StateSnapshotCopyWithImpl<$Res>;
  $Res call({int index, num precedence});
}

/// @nodoc
class _$StateSnapshotCopyWithImpl<$Res>
    implements $StateSnapshotCopyWith<$Res> {
  _$StateSnapshotCopyWithImpl(this._value, this._then);

  final StateSnapshot _value;
  // ignore: unused_field
  final $Res Function(StateSnapshot) _then;

  @override
  $Res call({
    Object? index = freezed,
    Object? precedence = freezed,
  }) {
    return _then(_value.copyWith(
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      precedence: precedence == freezed
          ? _value.precedence
          : precedence // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
abstract class $StateSnapshotDefaultCopyWith<$Res>
    implements $StateSnapshotCopyWith<$Res> {
  factory $StateSnapshotDefaultCopyWith(StateSnapshotDefault value,
          $Res Function(StateSnapshotDefault) then) =
      _$StateSnapshotDefaultCopyWithImpl<$Res>;
  @override
  $Res call({int index, num precedence});
}

/// @nodoc
class _$StateSnapshotDefaultCopyWithImpl<$Res>
    extends _$StateSnapshotCopyWithImpl<$Res>
    implements $StateSnapshotDefaultCopyWith<$Res> {
  _$StateSnapshotDefaultCopyWithImpl(
      StateSnapshotDefault _value, $Res Function(StateSnapshotDefault) _then)
      : super(_value, (v) => _then(v as StateSnapshotDefault));

  @override
  StateSnapshotDefault get _value => super._value as StateSnapshotDefault;

  @override
  $Res call({
    Object? index = freezed,
    Object? precedence = freezed,
  }) {
    return _then(StateSnapshotDefault(
      index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      precedence == freezed
          ? _value.precedence
          : precedence // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc

class _$StateSnapshotDefault implements StateSnapshotDefault {
  const _$StateSnapshotDefault(this.index, this.precedence);

  @override
  final int index;
  @override
  final num precedence;

  @override
  String toString() {
    return 'StateSnapshot(index: $index, precedence: $precedence)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateSnapshotDefault &&
            const DeepCollectionEquality().equals(other.index, index) &&
            const DeepCollectionEquality()
                .equals(other.precedence, precedence));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(index),
      const DeepCollectionEquality().hash(precedence));

  @JsonKey(ignore: true)
  @override
  $StateSnapshotDefaultCopyWith<StateSnapshotDefault> get copyWith =>
      _$StateSnapshotDefaultCopyWithImpl<StateSnapshotDefault>(
          this, _$identity);
}

abstract class StateSnapshotDefault implements StateSnapshot {
  const factory StateSnapshotDefault(final int index, final num precedence) =
      _$StateSnapshotDefault;

  @override
  int get index => throw _privateConstructorUsedError;
  @override
  num get precedence => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $StateSnapshotDefaultCopyWith<StateSnapshotDefault> get copyWith =>
      throw _privateConstructorUsedError;
}

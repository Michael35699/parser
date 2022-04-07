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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$StateTearOff {
  const _$StateTearOff();

  StateDefault call(
      {required String input,
      int index = 0,
      bool map = false,
      num precedence = double.infinity,
      List<int> indentStack = const <int>[],
      Set<dynamic> dataSet = const <dynamic>{}}) {
    return StateDefault(
      input: input,
      index: index,
      map: map,
      precedence: precedence,
      indentStack: indentStack,
      dataSet: dataSet,
    );
  }
}

/// @nodoc
const $State = _$StateTearOff();

/// @nodoc
mixin _$State {
  String get input => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  bool get map => throw _privateConstructorUsedError;
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
      int index,
      bool map,
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
    Object? index = freezed,
    Object? map = freezed,
    Object? precedence = freezed,
    Object? indentStack = freezed,
    Object? dataSet = freezed,
  }) {
    return _then(_value.copyWith(
      input: input == freezed
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      map: map == freezed
          ? _value.map
          : map // ignore: cast_nullable_to_non_nullable
              as bool,
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
      int index,
      bool map,
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
    Object? index = freezed,
    Object? map = freezed,
    Object? precedence = freezed,
    Object? indentStack = freezed,
    Object? dataSet = freezed,
  }) {
    return _then(StateDefault(
      input: input == freezed
          ? _value.input
          : input // ignore: cast_nullable_to_non_nullable
              as String,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      map: map == freezed
          ? _value.map
          : map // ignore: cast_nullable_to_non_nullable
              as bool,
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
      this.index = 0,
      this.map = false,
      this.precedence = double.infinity,
      this.indentStack = const <int>[],
      this.dataSet = const <dynamic>{}})
      : super._();

  @override
  final String input;
  @JsonKey()
  @override
  final int index;
  @JsonKey()
  @override
  final bool map;
  @JsonKey()
  @override
  final num precedence;
  @JsonKey()
  @override
  final List<int> indentStack;
  @JsonKey()
  @override
  final Set<dynamic> dataSet;

  @override
  String toString() {
    return 'State(input: $input, index: $index, map: $map, precedence: $precedence, indentStack: $indentStack, dataSet: $dataSet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateDefault &&
            const DeepCollectionEquality().equals(other.input, input) &&
            const DeepCollectionEquality().equals(other.index, index) &&
            const DeepCollectionEquality().equals(other.map, map) &&
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
      const DeepCollectionEquality().hash(index),
      const DeepCollectionEquality().hash(map),
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
      {required String input,
      int index,
      bool map,
      num precedence,
      List<int> indentStack,
      Set<dynamic> dataSet}) = _$StateDefault;
  StateDefault._() : super._();

  @override
  String get input;
  @override
  int get index;
  @override
  bool get map;
  @override
  num get precedence;
  @override
  List<int> get indentStack;
  @override
  Set<dynamic> get dataSet;
  @override
  @JsonKey(ignore: true)
  $StateDefaultCopyWith<StateDefault> get copyWith =>
      throw _privateConstructorUsedError;
}

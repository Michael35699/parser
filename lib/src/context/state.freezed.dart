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
  String get buffer => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  num get precedence => throw _privateConstructorUsedError;
  List<int> get indentStack => throw _privateConstructorUsedError;
  List<dynamic> get dataStack => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StateCopyWith<State> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateCopyWith<$Res> {
  factory $StateCopyWith(State value, $Res Function(State) then) =
      _$StateCopyWithImpl<$Res>;
  $Res call(
      {String buffer,
      int index,
      num precedence,
      List<int> indentStack,
      List<dynamic> dataStack});
}

/// @nodoc
class _$StateCopyWithImpl<$Res> implements $StateCopyWith<$Res> {
  _$StateCopyWithImpl(this._value, this._then);

  final State _value;
  // ignore: unused_field
  final $Res Function(State) _then;

  @override
  $Res call({
    Object? buffer = freezed,
    Object? index = freezed,
    Object? precedence = freezed,
    Object? indentStack = freezed,
    Object? dataStack = freezed,
  }) {
    return _then(_value.copyWith(
      buffer: buffer == freezed
          ? _value.buffer
          : buffer // ignore: cast_nullable_to_non_nullable
              as String,
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
      dataStack: dataStack == freezed
          ? _value.dataStack
          : dataStack // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
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
      {String buffer,
      int index,
      num precedence,
      List<int> indentStack,
      List<dynamic> dataStack});
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
    Object? buffer = freezed,
    Object? index = freezed,
    Object? precedence = freezed,
    Object? indentStack = freezed,
    Object? dataStack = freezed,
  }) {
    return _then(StateDefault(
      buffer: buffer == freezed
          ? _value.buffer
          : buffer // ignore: cast_nullable_to_non_nullable
              as String,
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
      dataStack: dataStack == freezed
          ? _value.dataStack
          : dataStack // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc

class _$StateDefault extends StateDefault {
  _$StateDefault(
      {required this.buffer,
      this.index = 0,
      this.precedence = double.infinity,
      final List<int> indentStack = const <int>[],
      final List<dynamic> dataStack = const <dynamic>[]})
      : _indentStack = indentStack,
        _dataStack = dataStack,
        super._();

  @override
  final String buffer;
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

  final List<dynamic> _dataStack;
  @override
  @JsonKey()
  List<dynamic> get dataStack {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataStack);
  }

  @override
  String toString() {
    return 'State(buffer: $buffer, index: $index, precedence: $precedence, indentStack: $indentStack, dataStack: $dataStack)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StateDefault &&
            const DeepCollectionEquality().equals(other.buffer, buffer) &&
            const DeepCollectionEquality().equals(other.index, index) &&
            const DeepCollectionEquality()
                .equals(other.precedence, precedence) &&
            const DeepCollectionEquality()
                .equals(other.indentStack, indentStack) &&
            const DeepCollectionEquality().equals(other.dataStack, dataStack));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(buffer),
      const DeepCollectionEquality().hash(index),
      const DeepCollectionEquality().hash(precedence),
      const DeepCollectionEquality().hash(indentStack),
      const DeepCollectionEquality().hash(dataStack));

  @JsonKey(ignore: true)
  @override
  $StateDefaultCopyWith<StateDefault> get copyWith =>
      _$StateDefaultCopyWithImpl<StateDefault>(this, _$identity);
}

abstract class StateDefault extends State {
  factory StateDefault(
      {required final String buffer,
      final int index,
      final num precedence,
      final List<int> indentStack,
      final List<dynamic> dataStack}) = _$StateDefault;
  StateDefault._() : super._();

  @override
  String get buffer => throw _privateConstructorUsedError;
  @override
  int get index => throw _privateConstructorUsedError;
  @override
  num get precedence => throw _privateConstructorUsedError;
  @override
  List<int> get indentStack => throw _privateConstructorUsedError;
  @override
  List<dynamic> get dataStack => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $StateDefaultCopyWith<StateDefault> get copyWith =>
      throw _privateConstructorUsedError;
}

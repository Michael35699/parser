// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ContextTearOff {
  const _$ContextTearOff();

  ContextIgnore ignore(State state) {
    return ContextIgnore(
      state,
    );
  }

  ContextFailure failure(State state, String message) {
    return ContextFailure(
      state,
      message,
    );
  }

  ContextSuccess success(
      State state, Object? mappedResult, Object? unmappedResult) {
    return ContextSuccess(
      state,
      mappedResult,
      unmappedResult,
    );
  }
}

/// @nodoc
const $Context = _$ContextTearOff();

/// @nodoc
mixin _$Context {
  State get state => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State state) ignore,
    required TResult Function(State state, String message) failure,
    required TResult Function(
            State state, Object? mappedResult, Object? unmappedResult)
        success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContextIgnore value) ignore,
    required TResult Function(ContextFailure value) failure,
    required TResult Function(ContextSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ContextCopyWith<Context> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextCopyWith<$Res> {
  factory $ContextCopyWith(Context value, $Res Function(Context) then) =
      _$ContextCopyWithImpl<$Res>;
  $Res call({State state});

  $StateCopyWith<$Res> get state;
}

/// @nodoc
class _$ContextCopyWithImpl<$Res> implements $ContextCopyWith<$Res> {
  _$ContextCopyWithImpl(this._value, this._then);

  final Context _value;
  // ignore: unused_field
  final $Res Function(Context) _then;

  @override
  $Res call({
    Object? state = freezed,
  }) {
    return _then(_value.copyWith(
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
    ));
  }

  @override
  $StateCopyWith<$Res> get state {
    return $StateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc
abstract class $ContextIgnoreCopyWith<$Res> implements $ContextCopyWith<$Res> {
  factory $ContextIgnoreCopyWith(
          ContextIgnore value, $Res Function(ContextIgnore) then) =
      _$ContextIgnoreCopyWithImpl<$Res>;
  @override
  $Res call({State state});

  @override
  $StateCopyWith<$Res> get state;
}

/// @nodoc
class _$ContextIgnoreCopyWithImpl<$Res> extends _$ContextCopyWithImpl<$Res>
    implements $ContextIgnoreCopyWith<$Res> {
  _$ContextIgnoreCopyWithImpl(
      ContextIgnore _value, $Res Function(ContextIgnore) _then)
      : super(_value, (v) => _then(v as ContextIgnore));

  @override
  ContextIgnore get _value => super._value as ContextIgnore;

  @override
  $Res call({
    Object? state = freezed,
  }) {
    return _then(ContextIgnore(
      state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
    ));
  }
}

/// @nodoc

class _$ContextIgnore extends ContextIgnore {
  const _$ContextIgnore(this.state) : super._();

  @override
  final State state;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContextIgnore &&
            const DeepCollectionEquality().equals(other.state, state));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(state));

  @JsonKey(ignore: true)
  @override
  $ContextIgnoreCopyWith<ContextIgnore> get copyWith =>
      _$ContextIgnoreCopyWithImpl<ContextIgnore>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State state) ignore,
    required TResult Function(State state, String message) failure,
    required TResult Function(
            State state, Object? mappedResult, Object? unmappedResult)
        success,
  }) {
    return ignore(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
  }) {
    return ignore?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
    required TResult orElse(),
  }) {
    if (ignore != null) {
      return ignore(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContextIgnore value) ignore,
    required TResult Function(ContextFailure value) failure,
    required TResult Function(ContextSuccess value) success,
  }) {
    return ignore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
  }) {
    return ignore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
    required TResult orElse(),
  }) {
    if (ignore != null) {
      return ignore(this);
    }
    return orElse();
  }
}

abstract class ContextIgnore extends Context {
  const factory ContextIgnore(State state) = _$ContextIgnore;
  const ContextIgnore._() : super._();

  @override
  State get state;
  @override
  @JsonKey(ignore: true)
  $ContextIgnoreCopyWith<ContextIgnore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextFailureCopyWith<$Res> implements $ContextCopyWith<$Res> {
  factory $ContextFailureCopyWith(
          ContextFailure value, $Res Function(ContextFailure) then) =
      _$ContextFailureCopyWithImpl<$Res>;
  @override
  $Res call({State state, String message});

  @override
  $StateCopyWith<$Res> get state;
}

/// @nodoc
class _$ContextFailureCopyWithImpl<$Res> extends _$ContextCopyWithImpl<$Res>
    implements $ContextFailureCopyWith<$Res> {
  _$ContextFailureCopyWithImpl(
      ContextFailure _value, $Res Function(ContextFailure) _then)
      : super(_value, (v) => _then(v as ContextFailure));

  @override
  ContextFailure get _value => super._value as ContextFailure;

  @override
  $Res call({
    Object? state = freezed,
    Object? message = freezed,
  }) {
    return _then(ContextFailure(
      state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ContextFailure extends ContextFailure {
  const _$ContextFailure(this.state, this.message) : super._();

  @override
  final State state;
  @override
  final String message;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContextFailure &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(state),
      const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  $ContextFailureCopyWith<ContextFailure> get copyWith =>
      _$ContextFailureCopyWithImpl<ContextFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State state) ignore,
    required TResult Function(State state, String message) failure,
    required TResult Function(
            State state, Object? mappedResult, Object? unmappedResult)
        success,
  }) {
    return failure(state, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
  }) {
    return failure?.call(state, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(state, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContextIgnore value) ignore,
    required TResult Function(ContextFailure value) failure,
    required TResult Function(ContextSuccess value) success,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class ContextFailure extends Context {
  const factory ContextFailure(State state, String message) = _$ContextFailure;
  const ContextFailure._() : super._();

  @override
  State get state;
  String get message;
  @override
  @JsonKey(ignore: true)
  $ContextFailureCopyWith<ContextFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextSuccessCopyWith<$Res> implements $ContextCopyWith<$Res> {
  factory $ContextSuccessCopyWith(
          ContextSuccess value, $Res Function(ContextSuccess) then) =
      _$ContextSuccessCopyWithImpl<$Res>;
  @override
  $Res call({State state, Object? mappedResult, Object? unmappedResult});

  @override
  $StateCopyWith<$Res> get state;
}

/// @nodoc
class _$ContextSuccessCopyWithImpl<$Res> extends _$ContextCopyWithImpl<$Res>
    implements $ContextSuccessCopyWith<$Res> {
  _$ContextSuccessCopyWithImpl(
      ContextSuccess _value, $Res Function(ContextSuccess) _then)
      : super(_value, (v) => _then(v as ContextSuccess));

  @override
  ContextSuccess get _value => super._value as ContextSuccess;

  @override
  $Res call({
    Object? state = freezed,
    Object? mappedResult = freezed,
    Object? unmappedResult = freezed,
  }) {
    return _then(ContextSuccess(
      state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
      mappedResult == freezed ? _value.mappedResult : mappedResult,
      unmappedResult == freezed ? _value.unmappedResult : unmappedResult,
    ));
  }
}

/// @nodoc

class _$ContextSuccess extends ContextSuccess {
  const _$ContextSuccess(this.state, this.mappedResult, this.unmappedResult)
      : super._();

  @override
  final State state;
  @override
  final Object? mappedResult;
  @override
  final Object? unmappedResult;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContextSuccess &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality()
                .equals(other.mappedResult, mappedResult) &&
            const DeepCollectionEquality()
                .equals(other.unmappedResult, unmappedResult));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(state),
      const DeepCollectionEquality().hash(mappedResult),
      const DeepCollectionEquality().hash(unmappedResult));

  @JsonKey(ignore: true)
  @override
  $ContextSuccessCopyWith<ContextSuccess> get copyWith =>
      _$ContextSuccessCopyWithImpl<ContextSuccess>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(State state) ignore,
    required TResult Function(State state, String message) failure,
    required TResult Function(
            State state, Object? mappedResult, Object? unmappedResult)
        success,
  }) {
    return success(state, mappedResult, unmappedResult);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
  }) {
    return success?.call(state, mappedResult, unmappedResult);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(State state)? ignore,
    TResult Function(State state, String message)? failure,
    TResult Function(State state, Object? mappedResult, Object? unmappedResult)?
        success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(state, mappedResult, unmappedResult);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ContextIgnore value) ignore,
    required TResult Function(ContextFailure value) failure,
    required TResult Function(ContextSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ContextIgnore value)? ignore,
    TResult Function(ContextFailure value)? failure,
    TResult Function(ContextSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class ContextSuccess extends Context {
  const factory ContextSuccess(
          State state, Object? mappedResult, Object? unmappedResult) =
      _$ContextSuccess;
  const ContextSuccess._() : super._();

  @override
  State get state;
  Object? get mappedResult;
  Object? get unmappedResult;
  @override
  @JsonKey(ignore: true)
  $ContextSuccessCopyWith<ContextSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

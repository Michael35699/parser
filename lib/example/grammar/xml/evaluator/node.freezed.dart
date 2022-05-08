// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$XmlNode {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) text,
    required TResult Function(List<XmlNode> children) fragment,
    required TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)
        tag,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(XmlTextNode value) text,
    required TResult Function(XmlFragmentNode value) fragment,
    required TResult Function(XmlTagNode value) tag,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XmlNodeCopyWith<$Res> {
  factory $XmlNodeCopyWith(XmlNode value, $Res Function(XmlNode) then) =
      _$XmlNodeCopyWithImpl<$Res>;
}

/// @nodoc
class _$XmlNodeCopyWithImpl<$Res> implements $XmlNodeCopyWith<$Res> {
  _$XmlNodeCopyWithImpl(this._value, this._then);

  final XmlNode _value;
  // ignore: unused_field
  final $Res Function(XmlNode) _then;
}

/// @nodoc
abstract class $XmlTextNodeCopyWith<$Res> {
  factory $XmlTextNodeCopyWith(
          XmlTextNode value, $Res Function(XmlTextNode) then) =
      _$XmlTextNodeCopyWithImpl<$Res>;
  $Res call({String value});
}

/// @nodoc
class _$XmlTextNodeCopyWithImpl<$Res> extends _$XmlNodeCopyWithImpl<$Res>
    implements $XmlTextNodeCopyWith<$Res> {
  _$XmlTextNodeCopyWithImpl(
      XmlTextNode _value, $Res Function(XmlTextNode) _then)
      : super(_value, (v) => _then(v as XmlTextNode));

  @override
  XmlTextNode get _value => super._value as XmlTextNode;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(XmlTextNode(
      value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$XmlTextNode extends XmlTextNode {
  const _$XmlTextNode(this.value) : super._();

  @override
  final String value;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is XmlTextNode &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  $XmlTextNodeCopyWith<XmlTextNode> get copyWith =>
      _$XmlTextNodeCopyWithImpl<XmlTextNode>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) text,
    required TResult Function(List<XmlNode> children) fragment,
    required TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)
        tag,
  }) {
    return text(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
  }) {
    return text?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(XmlTextNode value) text,
    required TResult Function(XmlFragmentNode value) fragment,
    required TResult Function(XmlTagNode value) tag,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class XmlTextNode extends XmlNode {
  const factory XmlTextNode(final String value) = _$XmlTextNode;
  const XmlTextNode._() : super._();

  String get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $XmlTextNodeCopyWith<XmlTextNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XmlFragmentNodeCopyWith<$Res> {
  factory $XmlFragmentNodeCopyWith(
          XmlFragmentNode value, $Res Function(XmlFragmentNode) then) =
      _$XmlFragmentNodeCopyWithImpl<$Res>;
  $Res call({List<XmlNode> children});
}

/// @nodoc
class _$XmlFragmentNodeCopyWithImpl<$Res> extends _$XmlNodeCopyWithImpl<$Res>
    implements $XmlFragmentNodeCopyWith<$Res> {
  _$XmlFragmentNodeCopyWithImpl(
      XmlFragmentNode _value, $Res Function(XmlFragmentNode) _then)
      : super(_value, (v) => _then(v as XmlFragmentNode));

  @override
  XmlFragmentNode get _value => super._value as XmlFragmentNode;

  @override
  $Res call({
    Object? children = freezed,
  }) {
    return _then(XmlFragmentNode(
      children: children == freezed
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<XmlNode>,
    ));
  }
}

/// @nodoc

class _$XmlFragmentNode extends XmlFragmentNode {
  const _$XmlFragmentNode({required final List<XmlNode> children})
      : _children = children,
        super._();

  final List<XmlNode> _children;
  @override
  List<XmlNode> get children {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is XmlFragmentNode &&
            const DeepCollectionEquality().equals(other.children, children));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(children));

  @JsonKey(ignore: true)
  @override
  $XmlFragmentNodeCopyWith<XmlFragmentNode> get copyWith =>
      _$XmlFragmentNodeCopyWithImpl<XmlFragmentNode>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) text,
    required TResult Function(List<XmlNode> children) fragment,
    required TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)
        tag,
  }) {
    return fragment(children);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
  }) {
    return fragment?.call(children);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
    required TResult orElse(),
  }) {
    if (fragment != null) {
      return fragment(children);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(XmlTextNode value) text,
    required TResult Function(XmlFragmentNode value) fragment,
    required TResult Function(XmlTagNode value) tag,
  }) {
    return fragment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
  }) {
    return fragment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
    required TResult orElse(),
  }) {
    if (fragment != null) {
      return fragment(this);
    }
    return orElse();
  }
}

abstract class XmlFragmentNode extends XmlNode {
  const factory XmlFragmentNode({required final List<XmlNode> children}) =
      _$XmlFragmentNode;
  const XmlFragmentNode._() : super._();

  List<XmlNode> get children => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $XmlFragmentNodeCopyWith<XmlFragmentNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XmlTagNodeCopyWith<$Res> {
  factory $XmlTagNodeCopyWith(
          XmlTagNode value, $Res Function(XmlTagNode) then) =
      _$XmlTagNodeCopyWithImpl<$Res>;
  $Res call(
      {String name, Map<String, String> attributes, List<XmlNode>? children});
}

/// @nodoc
class _$XmlTagNodeCopyWithImpl<$Res> extends _$XmlNodeCopyWithImpl<$Res>
    implements $XmlTagNodeCopyWith<$Res> {
  _$XmlTagNodeCopyWithImpl(XmlTagNode _value, $Res Function(XmlTagNode) _then)
      : super(_value, (v) => _then(v as XmlTagNode));

  @override
  XmlTagNode get _value => super._value as XmlTagNode;

  @override
  $Res call({
    Object? name = freezed,
    Object? attributes = freezed,
    Object? children = freezed,
  }) {
    return _then(XmlTagNode(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      children: children == freezed
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<XmlNode>?,
    ));
  }
}

/// @nodoc

class _$XmlTagNode extends XmlTagNode {
  const _$XmlTagNode(
      {required this.name,
      required final Map<String, String> attributes,
      final List<XmlNode>? children})
      : _attributes = attributes,
        _children = children,
        super._();

  @override
  final String name;
  final Map<String, String> _attributes;
  @override
  Map<String, String> get attributes {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_attributes);
  }

  final List<XmlNode>? _children;
  @override
  List<XmlNode>? get children {
    final value = _children;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is XmlTagNode &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.attributes, attributes) &&
            const DeepCollectionEquality().equals(other.children, children));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(attributes),
      const DeepCollectionEquality().hash(children));

  @JsonKey(ignore: true)
  @override
  $XmlTagNodeCopyWith<XmlTagNode> get copyWith =>
      _$XmlTagNodeCopyWithImpl<XmlTagNode>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) text,
    required TResult Function(List<XmlNode> children) fragment,
    required TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)
        tag,
  }) {
    return tag(name, attributes, children);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
  }) {
    return tag?.call(name, attributes, children);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? text,
    TResult Function(List<XmlNode> children)? fragment,
    TResult Function(String name, Map<String, String> attributes,
            List<XmlNode>? children)?
        tag,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(name, attributes, children);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(XmlTextNode value) text,
    required TResult Function(XmlFragmentNode value) fragment,
    required TResult Function(XmlTagNode value) tag,
  }) {
    return tag(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
  }) {
    return tag?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(XmlTextNode value)? text,
    TResult Function(XmlFragmentNode value)? fragment,
    TResult Function(XmlTagNode value)? tag,
    required TResult orElse(),
  }) {
    if (tag != null) {
      return tag(this);
    }
    return orElse();
  }
}

abstract class XmlTagNode extends XmlNode {
  const factory XmlTagNode(
      {required final String name,
      required final Map<String, String> attributes,
      final List<XmlNode>? children}) = _$XmlTagNode;
  const XmlTagNode._() : super._();

  String get name => throw _privateConstructorUsedError;
  Map<String, String> get attributes => throw _privateConstructorUsedError;
  List<XmlNode>? get children => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $XmlTagNodeCopyWith<XmlTagNode> get copyWith =>
      throw _privateConstructorUsedError;
}

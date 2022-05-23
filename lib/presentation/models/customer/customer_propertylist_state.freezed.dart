// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'customer_propertylist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CustomerPropertylistStateTearOff {
  const _$CustomerPropertylistStateTearOff();

  _CustomerPropertylistState call({required List<PropertyData> propertylist}) {
    return _CustomerPropertylistState(
      propertylist: propertylist,
    );
  }
}

/// @nodoc
const $CustomerPropertylistState = _$CustomerPropertylistStateTearOff();

/// @nodoc
mixin _$CustomerPropertylistState {
  List<PropertyData> get propertylist => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CustomerPropertylistStateCopyWith<CustomerPropertylistState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerPropertylistStateCopyWith<$Res> {
  factory $CustomerPropertylistStateCopyWith(CustomerPropertylistState value,
          $Res Function(CustomerPropertylistState) then) =
      _$CustomerPropertylistStateCopyWithImpl<$Res>;
  $Res call({List<PropertyData> propertylist});
}

/// @nodoc
class _$CustomerPropertylistStateCopyWithImpl<$Res>
    implements $CustomerPropertylistStateCopyWith<$Res> {
  _$CustomerPropertylistStateCopyWithImpl(this._value, this._then);

  final CustomerPropertylistState _value;
  // ignore: unused_field
  final $Res Function(CustomerPropertylistState) _then;

  @override
  $Res call({
    Object? propertylist = freezed,
  }) {
    return _then(_value.copyWith(
      propertylist: propertylist == freezed
          ? _value.propertylist
          : propertylist // ignore: cast_nullable_to_non_nullable
              as List<PropertyData>,
    ));
  }
}

/// @nodoc
abstract class _$CustomerPropertylistStateCopyWith<$Res>
    implements $CustomerPropertylistStateCopyWith<$Res> {
  factory _$CustomerPropertylistStateCopyWith(_CustomerPropertylistState value,
          $Res Function(_CustomerPropertylistState) then) =
      __$CustomerPropertylistStateCopyWithImpl<$Res>;
  @override
  $Res call({List<PropertyData> propertylist});
}

/// @nodoc
class __$CustomerPropertylistStateCopyWithImpl<$Res>
    extends _$CustomerPropertylistStateCopyWithImpl<$Res>
    implements _$CustomerPropertylistStateCopyWith<$Res> {
  __$CustomerPropertylistStateCopyWithImpl(_CustomerPropertylistState _value,
      $Res Function(_CustomerPropertylistState) _then)
      : super(_value, (v) => _then(v as _CustomerPropertylistState));

  @override
  _CustomerPropertylistState get _value =>
      super._value as _CustomerPropertylistState;

  @override
  $Res call({
    Object? propertylist = freezed,
  }) {
    return _then(_CustomerPropertylistState(
      propertylist: propertylist == freezed
          ? _value.propertylist
          : propertylist // ignore: cast_nullable_to_non_nullable
              as List<PropertyData>,
    ));
  }
}

/// @nodoc

class _$_CustomerPropertylistState implements _CustomerPropertylistState {
  _$_CustomerPropertylistState({required this.propertylist});

  @override
  final List<PropertyData> propertylist;

  @override
  String toString() {
    return 'CustomerPropertylistState(propertylist: $propertylist)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CustomerPropertylistState &&
            (identical(other.propertylist, propertylist) ||
                const DeepCollectionEquality()
                    .equals(other.propertylist, propertylist)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(propertylist);

  @JsonKey(ignore: true)
  @override
  _$CustomerPropertylistStateCopyWith<_CustomerPropertylistState>
      get copyWith =>
          __$CustomerPropertylistStateCopyWithImpl<_CustomerPropertylistState>(
              this, _$identity);
}

abstract class _CustomerPropertylistState implements CustomerPropertylistState {
  factory _CustomerPropertylistState(
          {required List<PropertyData> propertylist}) =
      _$_CustomerPropertylistState;

  @override
  List<PropertyData> get propertylist => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CustomerPropertylistStateCopyWith<_CustomerPropertylistState>
      get copyWith => throw _privateConstructorUsedError;
}

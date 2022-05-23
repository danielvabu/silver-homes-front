// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'propertyform_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PropertyFormStateTearOff {
  const _$PropertyFormStateTearOff();

  _PropertyFormState call(
      {required String property_address,
      required int selectView,
      required bool isValueUpdate}) {
    return _PropertyFormState(
      property_address: property_address,
      selectView: selectView,
      isValueUpdate: isValueUpdate,
    );
  }
}

/// @nodoc
const $PropertyFormState = _$PropertyFormStateTearOff();

/// @nodoc
mixin _$PropertyFormState {
  String get property_address => throw _privateConstructorUsedError;
  int get selectView => throw _privateConstructorUsedError;
  bool get isValueUpdate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PropertyFormStateCopyWith<PropertyFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyFormStateCopyWith<$Res> {
  factory $PropertyFormStateCopyWith(
          PropertyFormState value, $Res Function(PropertyFormState) then) =
      _$PropertyFormStateCopyWithImpl<$Res>;
  $Res call({String property_address, int selectView, bool isValueUpdate});
}

/// @nodoc
class _$PropertyFormStateCopyWithImpl<$Res>
    implements $PropertyFormStateCopyWith<$Res> {
  _$PropertyFormStateCopyWithImpl(this._value, this._then);

  final PropertyFormState _value;
  // ignore: unused_field
  final $Res Function(PropertyFormState) _then;

  @override
  $Res call({
    Object? property_address = freezed,
    Object? selectView = freezed,
    Object? isValueUpdate = freezed,
  }) {
    return _then(_value.copyWith(
      property_address: property_address == freezed
          ? _value.property_address
          : property_address // ignore: cast_nullable_to_non_nullable
              as String,
      selectView: selectView == freezed
          ? _value.selectView
          : selectView // ignore: cast_nullable_to_non_nullable
              as int,
      isValueUpdate: isValueUpdate == freezed
          ? _value.isValueUpdate
          : isValueUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$PropertyFormStateCopyWith<$Res>
    implements $PropertyFormStateCopyWith<$Res> {
  factory _$PropertyFormStateCopyWith(
          _PropertyFormState value, $Res Function(_PropertyFormState) then) =
      __$PropertyFormStateCopyWithImpl<$Res>;
  @override
  $Res call({String property_address, int selectView, bool isValueUpdate});
}

/// @nodoc
class __$PropertyFormStateCopyWithImpl<$Res>
    extends _$PropertyFormStateCopyWithImpl<$Res>
    implements _$PropertyFormStateCopyWith<$Res> {
  __$PropertyFormStateCopyWithImpl(
      _PropertyFormState _value, $Res Function(_PropertyFormState) _then)
      : super(_value, (v) => _then(v as _PropertyFormState));

  @override
  _PropertyFormState get _value => super._value as _PropertyFormState;

  @override
  $Res call({
    Object? property_address = freezed,
    Object? selectView = freezed,
    Object? isValueUpdate = freezed,
  }) {
    return _then(_PropertyFormState(
      property_address: property_address == freezed
          ? _value.property_address
          : property_address // ignore: cast_nullable_to_non_nullable
              as String,
      selectView: selectView == freezed
          ? _value.selectView
          : selectView // ignore: cast_nullable_to_non_nullable
              as int,
      isValueUpdate: isValueUpdate == freezed
          ? _value.isValueUpdate
          : isValueUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PropertyFormState implements _PropertyFormState {
  const _$_PropertyFormState(
      {required this.property_address,
      required this.selectView,
      required this.isValueUpdate});

  @override
  final String property_address;
  @override
  final int selectView;
  @override
  final bool isValueUpdate;

  @override
  String toString() {
    return 'PropertyFormState(property_address: $property_address, selectView: $selectView, isValueUpdate: $isValueUpdate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PropertyFormState &&
            (identical(other.property_address, property_address) ||
                const DeepCollectionEquality()
                    .equals(other.property_address, property_address)) &&
            (identical(other.selectView, selectView) ||
                const DeepCollectionEquality()
                    .equals(other.selectView, selectView)) &&
            (identical(other.isValueUpdate, isValueUpdate) ||
                const DeepCollectionEquality()
                    .equals(other.isValueUpdate, isValueUpdate)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(property_address) ^
      const DeepCollectionEquality().hash(selectView) ^
      const DeepCollectionEquality().hash(isValueUpdate);

  @JsonKey(ignore: true)
  @override
  _$PropertyFormStateCopyWith<_PropertyFormState> get copyWith =>
      __$PropertyFormStateCopyWithImpl<_PropertyFormState>(this, _$identity);
}

abstract class _PropertyFormState implements PropertyFormState {
  const factory _PropertyFormState(
      {required String property_address,
      required int selectView,
      required bool isValueUpdate}) = _$_PropertyFormState;

  @override
  String get property_address => throw _privateConstructorUsedError;
  @override
  int get selectView => throw _privateConstructorUsedError;
  @override
  bool get isValueUpdate => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PropertyFormStateCopyWith<_PropertyFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

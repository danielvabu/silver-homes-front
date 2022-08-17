// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'eventtypesform_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EventtypesFormStateTearOff {
  const _$EventtypesFormStateTearOff();

  _EventtypesFormState call(
      {required String property_address,
      required int selectView,
      required bool isValueUpdate}) {
    return _EventtypesFormState(
      property_address: property_address,
      selectView: selectView,
      isValueUpdate: isValueUpdate,
    );
  }
}

/// @nodoc
const $EventtypesFormState = _$EventtypesFormStateTearOff();

/// @nodoc
mixin _$EventtypesFormState {
  String get property_address => throw _privateConstructorUsedError;
  int get selectView => throw _privateConstructorUsedError;
  bool get isValueUpdate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventtypesFormStateCopyWith<EventtypesFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventtypesFormStateCopyWith<$Res> {
  factory $EventtypesFormStateCopyWith(
          EventtypesFormState value, $Res Function(EventtypesFormState) then) =
      _$EventtypesFormStateCopyWithImpl<$Res>;
  $Res call({String property_address, int selectView, bool isValueUpdate});
}

/// @nodoc
class _$EventtypesFormStateCopyWithImpl<$Res>
    implements $EventtypesFormStateCopyWith<$Res> {
  _$EventtypesFormStateCopyWithImpl(this._value, this._then);

  final EventtypesFormState _value;
  // ignore: unused_field
  final $Res Function(EventtypesFormState) _then;

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
abstract class _$EventtypesFormStateCopyWith<$Res>
    implements $EventtypesFormStateCopyWith<$Res> {
  factory _$EventtypesFormStateCopyWith(_EventtypesFormState value,
          $Res Function(_EventtypesFormState) then) =
      __$EventtypesFormStateCopyWithImpl<$Res>;
  @override
  $Res call({String property_address, int selectView, bool isValueUpdate});
}

/// @nodoc
class __$EventtypesFormStateCopyWithImpl<$Res>
    extends _$EventtypesFormStateCopyWithImpl<$Res>
    implements _$EventtypesFormStateCopyWith<$Res> {
  __$EventtypesFormStateCopyWithImpl(
      _EventtypesFormState _value, $Res Function(_EventtypesFormState) _then)
      : super(_value, (v) => _then(v as _EventtypesFormState));

  @override
  _EventtypesFormState get _value => super._value as _EventtypesFormState;

  @override
  $Res call({
    Object? property_address = freezed,
    Object? selectView = freezed,
    Object? isValueUpdate = freezed,
  }) {
    return _then(_EventtypesFormState(
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

class _$_EventtypesFormState implements _EventtypesFormState {
  const _$_EventtypesFormState(
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
    return 'EventtypesFormState(property_address: $property_address, selectView: $selectView, isValueUpdate: $isValueUpdate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _EventtypesFormState &&
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
  _$EventtypesFormStateCopyWith<_EventtypesFormState> get copyWith =>
      __$EventtypesFormStateCopyWithImpl<_EventtypesFormState>(
          this, _$identity);
}

abstract class _EventtypesFormState implements EventtypesFormState {
  const factory _EventtypesFormState(
      {required String property_address,
      required int selectView,
      required bool isValueUpdate}) = _$_EventtypesFormState;

  @override
  String get property_address => throw _privateConstructorUsedError;
  @override
  int get selectView => throw _privateConstructorUsedError;
  @override
  bool get isValueUpdate => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$EventtypesFormStateCopyWith<_EventtypesFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

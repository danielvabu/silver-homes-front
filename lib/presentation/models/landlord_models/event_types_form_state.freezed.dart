// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'event_types_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EventTypesFormStateTearOff {
  const _$EventTypesFormStateTearOff();

  _EventTypesFormState call(
      {required String eventtypes_address,
      required int selectView,
      required bool isValueUpdate}) {
    return _EventTypesFormState(
      eventtypes_address: eventtypes_address,
      selectView: selectView,
      isValueUpdate: isValueUpdate,
    );
  }
}

/// @nodoc
const $EventTypesFormState = _$EventTypesFormStateTearOff();

/// @nodoc
mixin _$EventTypesFormState {
  String get eventtypes_address => throw _privateConstructorUsedError;
  int get selectView => throw _privateConstructorUsedError;
  bool get isValueUpdate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventTypesFormStateCopyWith<EventTypesFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventTypesFormStateCopyWith<$Res> {
  factory $EventTypesFormStateCopyWith(
          EventTypesFormState value, $Res Function(EventTypesFormState) then) =
      _$EventTypesFormStateCopyWithImpl<$Res>;
  $Res call({String eventtypes_address, int selectView, bool isValueUpdate});
}

/// @nodoc
class _$EventTypesFormStateCopyWithImpl<$Res>
    implements $EventTypesFormStateCopyWith<$Res> {
  _$EventTypesFormStateCopyWithImpl(this._value, this._then);

  final EventTypesFormState _value;
  // ignore: unused_field
  final $Res Function(EventTypesFormState) _then;

  @override
  $Res call({
    Object? eventtypes_address = freezed,
    Object? selectView = freezed,
    Object? isValueUpdate = freezed,
  }) {
    return _then(_value.copyWith(
      eventtypes_address: eventtypes_address == freezed
          ? _value.eventtypes_address
          : eventtypes_address // ignore: cast_nullable_to_non_nullable
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
abstract class _$EventTypesFormStateCopyWith<$Res>
    implements $EventTypesFormStateCopyWith<$Res> {
  factory _$EventTypesFormStateCopyWith(
          _EventTypesFormState value, $Res Function(_EventTypesFormState) then) =
      __$EventTypesFormStateCopyWithImpl<$Res>;
  @override
  $Res call({String eventtypes_address, int selectView, bool isValueUpdate});
}

/// @nodoc
class __$EventTypesFormStateCopyWithImpl<$Res>
    extends _$EventTypesFormStateCopyWithImpl<$Res>
    implements _$EventTypesFormStateCopyWith<$Res> {
  __$EventTypesFormStateCopyWithImpl(
      _EventTypesFormState _value, $Res Function(_EventTypesFormState) _then)
      : super(_value, (v) => _then(v as _EventTypesFormState));

  @override
  _EventTypesFormState get _value => super._value as _EventTypesFormState;

  @override
  $Res call({
    Object? eventtypes_address = freezed,
    Object? selectView = freezed,
    Object? isValueUpdate = freezed,
  }) {
    return _then(_EventTypesFormState(
      eventtypes_address: eventtypes_address == freezed
          ? _value.eventtypes_address
          : eventtypes_address // ignore: cast_nullable_to_non_nullable
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

class _$_EventTypesFormState implements _EventTypesFormState {
  const _$_EventTypesFormState(
      {required this.eventtypes_address,
      required this.selectView,
      required this.isValueUpdate});

  @override
  final String eventtypes_address;
  @override
  final int selectView;
  @override
  final bool isValueUpdate;

  @override
  String toString() {
    return 'EventTypesFormState(eventtypes_address: $eventtypes_address, selectView: $selectView, isValueUpdate: $isValueUpdate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _EventTypesFormState &&
            (identical(other.eventtypes_address, eventtypes_address) ||
                const DeepCollectionEquality()
                    .equals(other.eventtypes_address, eventtypes_address)) &&
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
      const DeepCollectionEquality().hash(eventtypes_address) ^
      const DeepCollectionEquality().hash(selectView) ^
      const DeepCollectionEquality().hash(isValueUpdate);

  @JsonKey(ignore: true)
  @override
  _$EventTypesFormStateCopyWith<_EventTypesFormState> get copyWith =>
      __$EventTypesFormStateCopyWithImpl<_EventTypesFormState>(this, _$identity);
}

abstract class _EventTypesFormState implements EventTypesFormState {
  const factory _EventTypesFormState(
      {required String eventtypes_address,
      required int selectView,
      required bool isValueUpdate}) = _$_EventTypesFormState;

  @override
  String get eventtypes_address => throw _privateConstructorUsedError;
  @override
  int get selectView => throw _privateConstructorUsedError;
  @override
  bool get isValueUpdate => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$EventTypesFormStateCopyWith<_EventTypesFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'admin_landlorddetails_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AdminLandlordDetailsStateTearOff {
  const _$AdminLandlordDetailsStateTearOff();

  _AdminLandlordDetailsState call({required int selecttab}) {
    return _AdminLandlordDetailsState(
      selecttab: selecttab,
    );
  }
}

/// @nodoc
const $AdminLandlordDetailsState = _$AdminLandlordDetailsStateTearOff();

/// @nodoc
mixin _$AdminLandlordDetailsState {
  int get selecttab => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminLandlordDetailsStateCopyWith<AdminLandlordDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminLandlordDetailsStateCopyWith<$Res> {
  factory $AdminLandlordDetailsStateCopyWith(AdminLandlordDetailsState value,
          $Res Function(AdminLandlordDetailsState) then) =
      _$AdminLandlordDetailsStateCopyWithImpl<$Res>;
  $Res call({int selecttab});
}

/// @nodoc
class _$AdminLandlordDetailsStateCopyWithImpl<$Res>
    implements $AdminLandlordDetailsStateCopyWith<$Res> {
  _$AdminLandlordDetailsStateCopyWithImpl(this._value, this._then);

  final AdminLandlordDetailsState _value;
  // ignore: unused_field
  final $Res Function(AdminLandlordDetailsState) _then;

  @override
  $Res call({
    Object? selecttab = freezed,
  }) {
    return _then(_value.copyWith(
      selecttab: selecttab == freezed
          ? _value.selecttab
          : selecttab // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$AdminLandlordDetailsStateCopyWith<$Res>
    implements $AdminLandlordDetailsStateCopyWith<$Res> {
  factory _$AdminLandlordDetailsStateCopyWith(_AdminLandlordDetailsState value,
          $Res Function(_AdminLandlordDetailsState) then) =
      __$AdminLandlordDetailsStateCopyWithImpl<$Res>;
  @override
  $Res call({int selecttab});
}

/// @nodoc
class __$AdminLandlordDetailsStateCopyWithImpl<$Res>
    extends _$AdminLandlordDetailsStateCopyWithImpl<$Res>
    implements _$AdminLandlordDetailsStateCopyWith<$Res> {
  __$AdminLandlordDetailsStateCopyWithImpl(_AdminLandlordDetailsState _value,
      $Res Function(_AdminLandlordDetailsState) _then)
      : super(_value, (v) => _then(v as _AdminLandlordDetailsState));

  @override
  _AdminLandlordDetailsState get _value =>
      super._value as _AdminLandlordDetailsState;

  @override
  $Res call({
    Object? selecttab = freezed,
  }) {
    return _then(_AdminLandlordDetailsState(
      selecttab: selecttab == freezed
          ? _value.selecttab
          : selecttab // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AdminLandlordDetailsState implements _AdminLandlordDetailsState {
  const _$_AdminLandlordDetailsState({required this.selecttab});

  @override
  final int selecttab;

  @override
  String toString() {
    return 'AdminLandlordDetailsState(selecttab: $selecttab)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AdminLandlordDetailsState &&
            (identical(other.selecttab, selecttab) ||
                const DeepCollectionEquality()
                    .equals(other.selecttab, selecttab)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(selecttab);

  @JsonKey(ignore: true)
  @override
  _$AdminLandlordDetailsStateCopyWith<_AdminLandlordDetailsState>
      get copyWith =>
          __$AdminLandlordDetailsStateCopyWithImpl<_AdminLandlordDetailsState>(
              this, _$identity);
}

abstract class _AdminLandlordDetailsState implements AdminLandlordDetailsState {
  const factory _AdminLandlordDetailsState({required int selecttab}) =
      _$_AdminLandlordDetailsState;

  @override
  int get selecttab => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AdminLandlordDetailsStateCopyWith<_AdminLandlordDetailsState>
      get copyWith => throw _privateConstructorUsedError;
}

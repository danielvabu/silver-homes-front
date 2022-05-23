// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'admin_setting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AdminSettingStateTearOff {
  const _$AdminSettingStateTearOff();

  _AdminSettingState call(
      {int? ID,
      bool? isloading,
      bool? isMaintenance,
      required String title,
      required String instruction}) {
    return _AdminSettingState(
      ID: ID,
      isloading: isloading,
      isMaintenance: isMaintenance,
      title: title,
      instruction: instruction,
    );
  }
}

/// @nodoc
const $AdminSettingState = _$AdminSettingStateTearOff();

/// @nodoc
mixin _$AdminSettingState {
  int? get ID => throw _privateConstructorUsedError;
  bool? get isloading => throw _privateConstructorUsedError;
  bool? get isMaintenance => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get instruction => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminSettingStateCopyWith<AdminSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminSettingStateCopyWith<$Res> {
  factory $AdminSettingStateCopyWith(
          AdminSettingState value, $Res Function(AdminSettingState) then) =
      _$AdminSettingStateCopyWithImpl<$Res>;
  $Res call(
      {int? ID,
      bool? isloading,
      bool? isMaintenance,
      String title,
      String instruction});
}

/// @nodoc
class _$AdminSettingStateCopyWithImpl<$Res>
    implements $AdminSettingStateCopyWith<$Res> {
  _$AdminSettingStateCopyWithImpl(this._value, this._then);

  final AdminSettingState _value;
  // ignore: unused_field
  final $Res Function(AdminSettingState) _then;

  @override
  $Res call({
    Object? ID = freezed,
    Object? isloading = freezed,
    Object? isMaintenance = freezed,
    Object? title = freezed,
    Object? instruction = freezed,
  }) {
    return _then(_value.copyWith(
      ID: ID == freezed
          ? _value.ID
          : ID // ignore: cast_nullable_to_non_nullable
              as int?,
      isloading: isloading == freezed
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMaintenance: isMaintenance == freezed
          ? _value.isMaintenance
          : isMaintenance // ignore: cast_nullable_to_non_nullable
              as bool?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: instruction == freezed
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$AdminSettingStateCopyWith<$Res>
    implements $AdminSettingStateCopyWith<$Res> {
  factory _$AdminSettingStateCopyWith(
          _AdminSettingState value, $Res Function(_AdminSettingState) then) =
      __$AdminSettingStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? ID,
      bool? isloading,
      bool? isMaintenance,
      String title,
      String instruction});
}

/// @nodoc
class __$AdminSettingStateCopyWithImpl<$Res>
    extends _$AdminSettingStateCopyWithImpl<$Res>
    implements _$AdminSettingStateCopyWith<$Res> {
  __$AdminSettingStateCopyWithImpl(
      _AdminSettingState _value, $Res Function(_AdminSettingState) _then)
      : super(_value, (v) => _then(v as _AdminSettingState));

  @override
  _AdminSettingState get _value => super._value as _AdminSettingState;

  @override
  $Res call({
    Object? ID = freezed,
    Object? isloading = freezed,
    Object? isMaintenance = freezed,
    Object? title = freezed,
    Object? instruction = freezed,
  }) {
    return _then(_AdminSettingState(
      ID: ID == freezed
          ? _value.ID
          : ID // ignore: cast_nullable_to_non_nullable
              as int?,
      isloading: isloading == freezed
          ? _value.isloading
          : isloading // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMaintenance: isMaintenance == freezed
          ? _value.isMaintenance
          : isMaintenance // ignore: cast_nullable_to_non_nullable
              as bool?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: instruction == freezed
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AdminSettingState implements _AdminSettingState {
  _$_AdminSettingState(
      {this.ID,
      this.isloading,
      this.isMaintenance,
      required this.title,
      required this.instruction});

  @override
  final int? ID;
  @override
  final bool? isloading;
  @override
  final bool? isMaintenance;
  @override
  final String title;
  @override
  final String instruction;

  @override
  String toString() {
    return 'AdminSettingState(ID: $ID, isloading: $isloading, isMaintenance: $isMaintenance, title: $title, instruction: $instruction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AdminSettingState &&
            (identical(other.ID, ID) ||
                const DeepCollectionEquality().equals(other.ID, ID)) &&
            (identical(other.isloading, isloading) ||
                const DeepCollectionEquality()
                    .equals(other.isloading, isloading)) &&
            (identical(other.isMaintenance, isMaintenance) ||
                const DeepCollectionEquality()
                    .equals(other.isMaintenance, isMaintenance)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.instruction, instruction) ||
                const DeepCollectionEquality()
                    .equals(other.instruction, instruction)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(ID) ^
      const DeepCollectionEquality().hash(isloading) ^
      const DeepCollectionEquality().hash(isMaintenance) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(instruction);

  @JsonKey(ignore: true)
  @override
  _$AdminSettingStateCopyWith<_AdminSettingState> get copyWith =>
      __$AdminSettingStateCopyWithImpl<_AdminSettingState>(this, _$identity);
}

abstract class _AdminSettingState implements AdminSettingState {
  factory _AdminSettingState(
      {int? ID,
      bool? isloading,
      bool? isMaintenance,
      required String title,
      required String instruction}) = _$_AdminSettingState;

  @override
  int? get ID => throw _privateConstructorUsedError;
  @override
  bool? get isloading => throw _privateConstructorUsedError;
  @override
  bool? get isMaintenance => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get instruction => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AdminSettingStateCopyWith<_AdminSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

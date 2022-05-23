// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'reference_check_dialog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ReferenceCheckDialogStateTearOff {
  const _$ReferenceCheckDialogStateTearOff();

  _ReferenceCheckDialogState call(
      {required List<LeadReference> leadReferencelist,
      required bool isAllCheck}) {
    return _ReferenceCheckDialogState(
      leadReferencelist: leadReferencelist,
      isAllCheck: isAllCheck,
    );
  }
}

/// @nodoc
const $ReferenceCheckDialogState = _$ReferenceCheckDialogStateTearOff();

/// @nodoc
mixin _$ReferenceCheckDialogState {
  List<LeadReference> get leadReferencelist =>
      throw _privateConstructorUsedError;
  bool get isAllCheck => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReferenceCheckDialogStateCopyWith<ReferenceCheckDialogState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferenceCheckDialogStateCopyWith<$Res> {
  factory $ReferenceCheckDialogStateCopyWith(ReferenceCheckDialogState value,
          $Res Function(ReferenceCheckDialogState) then) =
      _$ReferenceCheckDialogStateCopyWithImpl<$Res>;
  $Res call({List<LeadReference> leadReferencelist, bool isAllCheck});
}

/// @nodoc
class _$ReferenceCheckDialogStateCopyWithImpl<$Res>
    implements $ReferenceCheckDialogStateCopyWith<$Res> {
  _$ReferenceCheckDialogStateCopyWithImpl(this._value, this._then);

  final ReferenceCheckDialogState _value;
  // ignore: unused_field
  final $Res Function(ReferenceCheckDialogState) _then;

  @override
  $Res call({
    Object? leadReferencelist = freezed,
    Object? isAllCheck = freezed,
  }) {
    return _then(_value.copyWith(
      leadReferencelist: leadReferencelist == freezed
          ? _value.leadReferencelist
          : leadReferencelist // ignore: cast_nullable_to_non_nullable
              as List<LeadReference>,
      isAllCheck: isAllCheck == freezed
          ? _value.isAllCheck
          : isAllCheck // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$ReferenceCheckDialogStateCopyWith<$Res>
    implements $ReferenceCheckDialogStateCopyWith<$Res> {
  factory _$ReferenceCheckDialogStateCopyWith(_ReferenceCheckDialogState value,
          $Res Function(_ReferenceCheckDialogState) then) =
      __$ReferenceCheckDialogStateCopyWithImpl<$Res>;
  @override
  $Res call({List<LeadReference> leadReferencelist, bool isAllCheck});
}

/// @nodoc
class __$ReferenceCheckDialogStateCopyWithImpl<$Res>
    extends _$ReferenceCheckDialogStateCopyWithImpl<$Res>
    implements _$ReferenceCheckDialogStateCopyWith<$Res> {
  __$ReferenceCheckDialogStateCopyWithImpl(_ReferenceCheckDialogState _value,
      $Res Function(_ReferenceCheckDialogState) _then)
      : super(_value, (v) => _then(v as _ReferenceCheckDialogState));

  @override
  _ReferenceCheckDialogState get _value =>
      super._value as _ReferenceCheckDialogState;

  @override
  $Res call({
    Object? leadReferencelist = freezed,
    Object? isAllCheck = freezed,
  }) {
    return _then(_ReferenceCheckDialogState(
      leadReferencelist: leadReferencelist == freezed
          ? _value.leadReferencelist
          : leadReferencelist // ignore: cast_nullable_to_non_nullable
              as List<LeadReference>,
      isAllCheck: isAllCheck == freezed
          ? _value.isAllCheck
          : isAllCheck // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ReferenceCheckDialogState implements _ReferenceCheckDialogState {
  const _$_ReferenceCheckDialogState(
      {required this.leadReferencelist, required this.isAllCheck});

  @override
  final List<LeadReference> leadReferencelist;
  @override
  final bool isAllCheck;

  @override
  String toString() {
    return 'ReferenceCheckDialogState(leadReferencelist: $leadReferencelist, isAllCheck: $isAllCheck)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ReferenceCheckDialogState &&
            (identical(other.leadReferencelist, leadReferencelist) ||
                const DeepCollectionEquality()
                    .equals(other.leadReferencelist, leadReferencelist)) &&
            (identical(other.isAllCheck, isAllCheck) ||
                const DeepCollectionEquality()
                    .equals(other.isAllCheck, isAllCheck)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(leadReferencelist) ^
      const DeepCollectionEquality().hash(isAllCheck);

  @JsonKey(ignore: true)
  @override
  _$ReferenceCheckDialogStateCopyWith<_ReferenceCheckDialogState>
      get copyWith =>
          __$ReferenceCheckDialogStateCopyWithImpl<_ReferenceCheckDialogState>(
              this, _$identity);
}

abstract class _ReferenceCheckDialogState implements ReferenceCheckDialogState {
  const factory _ReferenceCheckDialogState(
      {required List<LeadReference> leadReferencelist,
      required bool isAllCheck}) = _$_ReferenceCheckDialogState;

  @override
  List<LeadReference> get leadReferencelist =>
      throw _privateConstructorUsedError;
  @override
  bool get isAllCheck => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ReferenceCheckDialogStateCopyWith<_ReferenceCheckDialogState>
      get copyWith => throw _privateConstructorUsedError;
}

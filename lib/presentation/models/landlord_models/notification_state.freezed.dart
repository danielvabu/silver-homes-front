// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$NotificationStateTearOff {
  const _$NotificationStateTearOff();

  _NotificationState call(
      {required List<NotificationData> notificationlist,
      required int PageNo,
      required bool IsLoadmore}) {
    return _NotificationState(
      notificationlist: notificationlist,
      PageNo: PageNo,
      IsLoadmore: IsLoadmore,
    );
  }
}

/// @nodoc
const $NotificationState = _$NotificationStateTearOff();

/// @nodoc
mixin _$NotificationState {
  List<NotificationData> get notificationlist =>
      throw _privateConstructorUsedError;
  int get PageNo => throw _privateConstructorUsedError;
  bool get IsLoadmore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationStateCopyWith<NotificationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStateCopyWith<$Res> {
  factory $NotificationStateCopyWith(
          NotificationState value, $Res Function(NotificationState) then) =
      _$NotificationStateCopyWithImpl<$Res>;
  $Res call(
      {List<NotificationData> notificationlist, int PageNo, bool IsLoadmore});
}

/// @nodoc
class _$NotificationStateCopyWithImpl<$Res>
    implements $NotificationStateCopyWith<$Res> {
  _$NotificationStateCopyWithImpl(this._value, this._then);

  final NotificationState _value;
  // ignore: unused_field
  final $Res Function(NotificationState) _then;

  @override
  $Res call({
    Object? notificationlist = freezed,
    Object? PageNo = freezed,
    Object? IsLoadmore = freezed,
  }) {
    return _then(_value.copyWith(
      notificationlist: notificationlist == freezed
          ? _value.notificationlist
          : notificationlist // ignore: cast_nullable_to_non_nullable
              as List<NotificationData>,
      PageNo: PageNo == freezed
          ? _value.PageNo
          : PageNo // ignore: cast_nullable_to_non_nullable
              as int,
      IsLoadmore: IsLoadmore == freezed
          ? _value.IsLoadmore
          : IsLoadmore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$NotificationStateCopyWith<$Res>
    implements $NotificationStateCopyWith<$Res> {
  factory _$NotificationStateCopyWith(
          _NotificationState value, $Res Function(_NotificationState) then) =
      __$NotificationStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<NotificationData> notificationlist, int PageNo, bool IsLoadmore});
}

/// @nodoc
class __$NotificationStateCopyWithImpl<$Res>
    extends _$NotificationStateCopyWithImpl<$Res>
    implements _$NotificationStateCopyWith<$Res> {
  __$NotificationStateCopyWithImpl(
      _NotificationState _value, $Res Function(_NotificationState) _then)
      : super(_value, (v) => _then(v as _NotificationState));

  @override
  _NotificationState get _value => super._value as _NotificationState;

  @override
  $Res call({
    Object? notificationlist = freezed,
    Object? PageNo = freezed,
    Object? IsLoadmore = freezed,
  }) {
    return _then(_NotificationState(
      notificationlist: notificationlist == freezed
          ? _value.notificationlist
          : notificationlist // ignore: cast_nullable_to_non_nullable
              as List<NotificationData>,
      PageNo: PageNo == freezed
          ? _value.PageNo
          : PageNo // ignore: cast_nullable_to_non_nullable
              as int,
      IsLoadmore: IsLoadmore == freezed
          ? _value.IsLoadmore
          : IsLoadmore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_NotificationState implements _NotificationState {
  _$_NotificationState(
      {required this.notificationlist,
      required this.PageNo,
      required this.IsLoadmore});

  @override
  final List<NotificationData> notificationlist;
  @override
  final int PageNo;
  @override
  final bool IsLoadmore;

  @override
  String toString() {
    return 'NotificationState(notificationlist: $notificationlist, PageNo: $PageNo, IsLoadmore: $IsLoadmore)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NotificationState &&
            (identical(other.notificationlist, notificationlist) ||
                const DeepCollectionEquality()
                    .equals(other.notificationlist, notificationlist)) &&
            (identical(other.PageNo, PageNo) ||
                const DeepCollectionEquality().equals(other.PageNo, PageNo)) &&
            (identical(other.IsLoadmore, IsLoadmore) ||
                const DeepCollectionEquality()
                    .equals(other.IsLoadmore, IsLoadmore)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(notificationlist) ^
      const DeepCollectionEquality().hash(PageNo) ^
      const DeepCollectionEquality().hash(IsLoadmore);

  @JsonKey(ignore: true)
  @override
  _$NotificationStateCopyWith<_NotificationState> get copyWith =>
      __$NotificationStateCopyWithImpl<_NotificationState>(this, _$identity);
}

abstract class _NotificationState implements NotificationState {
  factory _NotificationState(
      {required List<NotificationData> notificationlist,
      required int PageNo,
      required bool IsLoadmore}) = _$_NotificationState;

  @override
  List<NotificationData> get notificationlist =>
      throw _privateConstructorUsedError;
  @override
  int get PageNo => throw _privateConstructorUsedError;
  @override
  bool get IsLoadmore => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NotificationStateCopyWith<_NotificationState> get copyWith =>
      throw _privateConstructorUsedError;
}

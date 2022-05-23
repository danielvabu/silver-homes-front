import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tenant_personal_state.freezed.dart';

@freezed
abstract class TenantPersonalState with _$TenantPersonalState {
  const factory TenantPersonalState({
    required String perFirstname,
    required String perLastname,
    required String perEmail,
    required String perPhoneNumber,
    required String perCountryCode,
    required String perDialCode,
    MediaInfo? propertyImage,
    Uint8List? appimage,
  }) = _TenantPersonalState;

  factory TenantPersonalState.initial() => TenantPersonalState(
        perFirstname: "",
        perLastname: "",
        perEmail: "",
        perPhoneNumber: "",
        perCountryCode: "CA",
        perDialCode: "+1",
        propertyImage: null,
        appimage: null,
      );
}

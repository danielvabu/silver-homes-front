import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/common/globlestring.dart';

part 'tenant_portal_state.freezed.dart';

@freezed
abstract class TenantPortalState with _$TenantPortalState {
  factory TenantPortalState({
    bool? isLoading,
    int? index,
    int? subindex,
    required String title,
    required int notificationCount,
    required bool isMenuDialogshow,
  }) = _TenantPortalState;

  factory TenantPortalState.initial() => TenantPortalState(
        isLoading: false,
        index: 0,
        subindex: 0,
        title: GlobleString.NAV_tenant_LeaseDetails,
        notificationCount: 0,
        isMenuDialogshow: false,
      );
}

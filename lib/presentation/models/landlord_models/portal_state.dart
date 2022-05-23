import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'portal_state.freezed.dart';

@freezed
abstract class PortalState with _$PortalState {
  factory PortalState({
    required bool isLoading,
    required int index,
    required int subindex,
    required String title,
    required List<TenancyApplication> listdataviewlist,
    required int notificationCount,
    required bool isMenuDialogshow,
    required int tenantTabIndex,
    required bool isMaintenanceExpand,
  }) = _PortalState;

  factory PortalState.initial() => PortalState(
      isLoading: false,
      index: 1,
      subindex: 0,
      title: GlobleString.NAV_Overview,
      listdataviewlist: List.empty(),
      notificationCount: 0,
      isMenuDialogshow: false,
      tenantTabIndex: 1,
      isMaintenanceExpand: false);
}

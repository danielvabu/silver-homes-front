import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';

part 'tenant_maintenance_state.freezed.dart';

@freezed
abstract class TenantMaintenanceState with _$TenantMaintenanceState {
  const factory TenantMaintenanceState({
    required bool isRequestNameSort,
    required int RequestNameSortAcsDes,
    required bool isCategorySort,
    required int CategorySortAcsDes,
    required bool isPrioritySort,
    required int PrioritySortAcsDes,
    required bool isDateCreatedSort,
    required int DateCreatedSortAcsDes,
    required bool isCreatedBySort,
    required int CreatedBySortAcsDes,
    required bool isStatusSort,
    required int StatusSortAcsDes,
    required bool isEditRightsSort,
    required int EditRightsSortAcsDes,
    required String SearchText,
    required List<MaintenanceData> maintenancedatalist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _TenantMaintenanceState;

  factory TenantMaintenanceState.initial() => TenantMaintenanceState(
        isRequestNameSort: false,
        RequestNameSortAcsDes: 0,
        isCategorySort: false,
        CategorySortAcsDes: 0,
        isPrioritySort: false,
        PrioritySortAcsDes: 0,
        isDateCreatedSort: false,
        DateCreatedSortAcsDes: 0,
        isCreatedBySort: false,
        CreatedBySortAcsDes: 0,
        isStatusSort: false,
        StatusSortAcsDes: 0,
        isEditRightsSort: false,
        EditRightsSortAcsDes: 0,
        SearchText: "",
        maintenancedatalist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}

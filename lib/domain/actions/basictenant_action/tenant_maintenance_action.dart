import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateTenant_maintenancedatalist implements Action {
  final List<MaintenanceData> maintenancedatalist;

  UpdateTenant_maintenancedatalist(this.maintenancedatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(maintenancedatalist: maintenancedatalist);
  }
}

class UpdateTenantMaintenance_isloding implements Action {
  final bool isloding;

  UpdateTenantMaintenance_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isloding: isloding);
  }
}

class UpdateTenantMaintenance_pageNo implements Action {
  final int pageNo;

  UpdateTenantMaintenance_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(pageNo: pageNo);
  }
}

class UpdateTenantMaintenance_totalpage implements Action {
  final int totalpage;

  UpdateTenantMaintenance_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(totalpage: totalpage);
  }
}

class UpdateTenantMaintenance_totalRecord implements Action {
  final int totalRecord;

  UpdateTenantMaintenance_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(totalRecord: totalRecord);
  }
}

class UpdateTenantMaintenance_isRequestNameSort implements Action {
  final bool isSort;

  UpdateTenantMaintenance_isRequestNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isRequestNameSort: isSort);
  }
}

class UpdateTenantMaintenance_RequestNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateTenantMaintenance_RequestNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(RequestNameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateTenantMaintenance_isCategorySort implements Action {
  final bool isSort;

  UpdateTenantMaintenance_isCategorySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isCategorySort: isSort);
  }
}

class UpdateTenantMaintenance_CategorySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateTenantMaintenance_CategorySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(CategorySortAcsDes: NameSortAcsDes);
  }
}

class UpdateTenantMaintenance_isPrioritySort implements Action {
  final bool isSort;

  UpdateTenantMaintenance_isPrioritySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isPrioritySort: isSort);
  }
}

class UpdateTenantMaintenance_PrioritySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateTenantMaintenance_PrioritySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(PrioritySortAcsDes: NameSortAcsDes);
  }
}

class UpdateTenantMaintenance_isDateCreatedSort implements Action {
  final bool isSort;

  UpdateTenantMaintenance_isDateCreatedSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isDateCreatedSort: isSort);
  }
}

class UpdateTenantMaintenance_DateCreatedSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateTenantMaintenance_DateCreatedSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(DateCreatedSortAcsDes: NameSortAcsDes);
  }
}

class UpdateTenantMaintenance_isCreatedBySort implements Action {
  final bool isSort;

  UpdateTenantMaintenance_isCreatedBySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isCreatedBySort: isSort);
  }
}

class UpdateTenantMaintenance_CreatedBySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateTenantMaintenance_CreatedBySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(CreatedBySortAcsDes: NameSortAcsDes);
  }
}

class UpdateTenantMaintenance_isStatusSort implements Action {
  final bool isSort;

  UpdateTenantMaintenance_isStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isStatusSort: isSort);
  }
}

class UpdateTenantMaintenance_StatusSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateTenantMaintenance_StatusSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(StatusSortAcsDes: NameSortAcsDes);
  }
}

class UpdateTenantMaintenance_isEditRightsSort implements Action {
  final bool isSort;

  UpdateTenantMaintenance_isEditRightsSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(isEditRightsSort: isSort);
  }
}

class UpdateTenantMaintenance_EditRightsSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateTenantMaintenance_EditRightsSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantMaintenanceState(EditRightsSortAcsDes: NameSortAcsDes);
  }
}

class UpdateTenantMaintenance_SearchText implements Action {
  final String SearchText;

  UpdateTenantMaintenance_SearchText(this.SearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantMaintenanceState(SearchText: SearchText);
  }
}

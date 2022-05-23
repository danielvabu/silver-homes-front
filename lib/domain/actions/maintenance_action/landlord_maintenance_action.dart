import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLMaintenance_status_New implements Action {
  final int count;

  UpdateLLMaintenance_status_New(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(status_New: count);
  }
}

class UpdateLLMaintenance_status_Approved implements Action {
  final int count;

  UpdateLLMaintenance_status_Approved(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(status_Approved: count);
  }
}

class UpdateLLMaintenance_status_WorkinProgress implements Action {
  final int count;

  UpdateLLMaintenance_status_WorkinProgress(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(status_WorkinProgress: count);
  }
}

class UpdateLLMaintenance_status_Resolved implements Action {
  final int count;

  UpdateLLMaintenance_status_Resolved(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(status_Resolved: count);
  }
}

class UpdateLLMaintenance_status_Paid implements Action {
  final int count;

  UpdateLLMaintenance_status_Paid(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(status_Paid: count);
  }
}

class UpdateLL_maintenancedatalist implements Action {
  final List<MaintenanceData> maintenancedatalist;

  UpdateLL_maintenancedatalist(this.maintenancedatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(maintenancedatalist: maintenancedatalist);
  }
}

class UpdateLLMaintenance_isloding implements Action {
  final bool isloding;

  UpdateLLMaintenance_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(isloding: isloding);
  }
}

class UpdateLLMaintenance_pageNo implements Action {
  final int pageNo;

  UpdateLLMaintenance_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(pageNo: pageNo);
  }
}

class UpdateLLMaintenance_totalpage implements Action {
  final int totalpage;

  UpdateLLMaintenance_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(totalpage: totalpage);
  }
}

class UpdateLLMaintenance_totalRecord implements Action {
  final int totalRecord;

  UpdateLLMaintenance_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(totalRecord: totalRecord);
  }
}

class UpdateLLMaintenance_isPropertyNameSort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isPropertyNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(isPropertyNameSort: isSort);
  }
}

class UpdateLLMaintenance_PropertyNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_PropertyNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(PropertyNameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_isRequestNameSort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isRequestNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(isRequestNameSort: isSort);
  }
}

class UpdateLLMaintenance_RequestNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_RequestNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(RequestNameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_isCategorySort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isCategorySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(isCategorySort: isSort);
  }
}

class UpdateLLMaintenance_CategorySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_CategorySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(CategorySortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_isPrioritySort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isPrioritySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(isPrioritySort: isSort);
  }
}

class UpdateLLMaintenance_PrioritySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_PrioritySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(PrioritySortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_isDateCreatedSort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isDateCreatedSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(isDateCreatedSort: isSort);
  }
}

class UpdateLLMaintenance_DateCreatedSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_DateCreatedSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(DateCreatedSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_isCreatedBySort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isCreatedBySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(isCreatedBySort: isSort);
  }
}

class UpdateLLMaintenance_CreatedBySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_CreatedBySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(CreatedBySortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_isStatusSort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(isStatusSort: isSort);
  }
}

class UpdateLLMaintenance_StatusSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_StatusSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(StatusSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_isEditRightsSort implements Action {
  final bool isSort;

  UpdateLLMaintenance_isEditRightsSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(isEditRightsSort: isSort);
  }
}

class UpdateLLMaintenance_EditRightsSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLMaintenance_EditRightsSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordMaintenanceState(EditRightsSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLMaintenance_SearchText implements Action {
  final String SearchText;

  UpdateLLMaintenance_SearchText(this.SearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordMaintenanceState(SearchText: SearchText);
  }
}

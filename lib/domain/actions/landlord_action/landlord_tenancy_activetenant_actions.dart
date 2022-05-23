import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLActiveTenantToggle implements Action {
  final int index;

  UpdateLLActiveTenantToggle(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordActiveTenantState(selecttoggle: index);
  }
}

class UpdateLLActiveTenantisNameSort implements Action {
  final bool isSort;

  UpdateLLActiveTenantisNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordActiveTenantState(isNameSort: isSort);
  }
}

class UpdateLLActiveTenantisLeasStartDateSort implements Action {
  final bool isSort;

  UpdateLLActiveTenantisLeasStartDateSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordActiveTenantState(isLeasStartDateSort: isSort);
  }
}

class UpdateLLActiveTenantisLeaseDurationSort implements Action {
  final bool isSort;

  UpdateLLActiveTenantisLeaseDurationSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordActiveTenantState(isLeaseDurationSort: isSort);
  }
}

class UpdateLLActiveTenantisPropertySort implements Action {
  final bool isSort;

  UpdateLLActiveTenantisPropertySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordActiveTenantState(isPropertySort: isSort);
  }
}

class UpdateLLActiveTenantisAppStatusSort implements Action {
  final bool isSort;

  UpdateLLActiveTenantisAppStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordActiveTenantState(isAppStatusSort: isSort);
  }
}

class UpdateLLActiveTenantisRatingSort implements Action {
  final bool isSort;

  UpdateLLActiveTenantisRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordActiveTenantState(isRatingSort: isSort);
  }
}

class UpdateLLActiveTenantisLeaseStatusSort implements Action {
  final bool isLeaseStatusSort;

  UpdateLLActiveTenantisLeaseStatusSort(this.isLeaseStatusSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordActiveTenantState(isLeaseStatusSort: isLeaseStatusSort);
  }
}

class UpdateLLActiveTenantleadlist implements Action {
  final List<TenancyApplication> leaseleadlist;

  UpdateLLActiveTenantleadlist(this.leaseleadlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordActiveTenantState(activetenantleadlist: leaseleadlist);
  }
}

class UpdateLLActiveTenantfilterleadlist implements Action {
  final List<TenancyApplication> filterleaseleadlist;

  UpdateLLActiveTenantfilterleadlist(this.filterleaseleadlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordActiveTenantState(
        filteractivetenantleadlist: filterleaseleadlist);
  }
}

class UpdateLLActiveTenantPropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateLLActiveTenantPropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordActiveTenantState(propertylist: propertylist);
  }
}

class UpdateLLActiveTenantPropertyItem implements Action {
  final PropertyData? propertyitem;

  UpdateLLActiveTenantPropertyItem(this.propertyitem);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordActiveTenantState(propertyValue: propertyitem);
  }
}

class UpdateLLActiveTenantisloding implements Action {
  final bool isloding;

  UpdateLLActiveTenantisloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordActiveTenantState(isloding: isloding);
  }
}

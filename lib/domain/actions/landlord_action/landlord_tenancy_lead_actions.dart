import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLTALeadToggle implements Action {
  final int index;

  UpdateLLTALeadToggle(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(selecttoggle: index);
  }
}

class UpdateLLTALeadisNameSort implements Action {
  final bool isSort;

  UpdateLLTALeadisNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isNameSort: isSort);
  }
}

class UpdateLLTALeadisDatecreateSort implements Action {
  final bool isSort;

  UpdateLLTALeadisDatecreateSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isDatecreateSort: isSort);
  }
}

class UpdateLLTALeadisEmailSort implements Action {
  final bool isSort;

  UpdateLLTALeadisEmailSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isemailSort: isSort);
  }
}

class UpdateLLTALeadisPhoneSort implements Action {
  final bool isSort;

  UpdateLLTALeadisPhoneSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isphoneSort: isSort);
  }
}

class UpdateLLTALeadisPropertySort implements Action {
  final bool isSort;

  UpdateLLTALeadisPropertySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isPropertySort: isSort);
  }
}

class UpdateLLTALeadisAppStatusSort implements Action {
  final bool isSort;

  UpdateLLTALeadisAppStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isAppStatusSort: isSort);
  }
}

class UpdateLLTALeadisRatingSort implements Action {
  final bool isSort;

  UpdateLLTALeadisRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isRatingSort: isSort);
  }
}

class UpdateLLTALeadisOneItemSelect implements Action {
  final bool isOneItemSelect;

  UpdateLLTALeadisOneItemSelect(this.isOneItemSelect);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyLeadState(isOneItemSelect: isOneItemSelect);
  }
}

class UpdateLLTALeadleadList implements Action {
  final List<TenancyApplication> applicationlead;

  UpdateLLTALeadleadList(this.applicationlead);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyLeadState(applicationlead: applicationlead);
  }
}

class UpdateLLTLeadFilterleadList implements Action {
  final List<TenancyApplication> applicationlead;

  UpdateLLTLeadFilterleadList(this.applicationlead);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyLeadState(filterapplicationlead: applicationlead);
  }
}

class UpdateLLTALeadPropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateLLTALeadPropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyLeadState(propertylist: propertylist);
  }
}

class UpdateLLTALeadPropertyItem implements Action {
  final PropertyData? propertyitem;

  UpdateLLTALeadPropertyItem(this.propertyitem);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyLeadState(propertyValue: propertyitem);
  }
}

class UpdateLLTALeadisloding implements Action {
  final bool isloding;

  UpdateLLTALeadisloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyLeadState(isloding: isloding);
  }
}

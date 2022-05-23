import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLTAApplicantToggle implements Action {
  final int index;

  UpdateLLTAApplicantToggle(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyApplicantState(selecttoggle: index);
  }
}

class UpdateLLTAApplicantisNameSort implements Action {
  final bool isSort;

  UpdateLLTAApplicantisNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyApplicantState(isNameSort: isSort);
  }
}

class UpdateLLTAApplicantisDateReceiveSort implements Action {
  final bool isSort;

  UpdateLLTAApplicantisDateReceiveSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(isDateReceiveSort: isSort);
  }
}

class UpdateLLTAApplicantisDateSentSort implements Action {
  final bool isSort;

  UpdateLLTAApplicantisDateSentSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(isDateSentSort: isSort);
  }
}

class UpdateLLTAApplicantisPropertySort implements Action {
  final bool isSort;

  UpdateLLTAApplicantisPropertySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(isPropertySort: isSort);
  }
}

class UpdateLLTAApplicantisAppStatusSort implements Action {
  final bool isSort;

  UpdateLLTAApplicantisAppStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(isAppStatusSort: isSort);
  }
}

class UpdateLLTAApplicantisRatingSort implements Action {
  final bool isSort;

  UpdateLLTAApplicantisRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(isRatingSort: isSort);
  }
}

class UpdateLLTAApplicantisOneItemSelect implements Action {
  final bool isOneItemSelect;

  UpdateLLTAApplicantisOneItemSelect(this.isOneItemSelect);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(isOneItemSelect: isOneItemSelect);
  }
}

class UpdateLLTAApplicantleadList implements Action {
  final List<TenancyApplication> applicationlead;

  UpdateLLTAApplicantleadList(this.applicationlead);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(applicationlead: applicationlead);
  }
}

class UpdateLLTAFilterApplicantleadList implements Action {
  final List<TenancyApplication> applicationlead;

  UpdateLLTAFilterApplicantleadList(this.applicationlead);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(filterapplicationlead: applicationlead);
  }
}

class UpdateLLTAApplicantPropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateLLTAApplicantPropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(propertylist: propertylist);
  }
}

class UpdateLLTAApplicantPropertyItem implements Action {
  final PropertyData? propertyitem;

  UpdateLLTAApplicantPropertyItem(this.propertyitem);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyApplicantState(propertyValue: propertyitem);
  }
}

class UpdateLLTAApplicantisloding implements Action {
  final bool isloding;

  UpdateLLTAApplicantisloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyApplicantState(isloding: isloding);
  }
}

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminLL_property_isPropNameSort implements Action {
  final bool isPropNameSort;

  UpdateAdminLL_property_isPropNameSort(this.isPropNameSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropNameSort: isPropNameSort);
  }
}

class UpdateAdminLL_property_isPropUnitSort implements Action {
  final bool isPropUnitSort;

  UpdateAdminLL_property_isPropUnitSort(this.isPropUnitSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropUnitSort: isPropUnitSort);
  }
}

class UpdateAdminLL_property_isPropCitySort implements Action {
  final bool isPropCitySort;

  UpdateAdminLL_property_isPropCitySort(this.isPropCitySort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropCitySort: isPropCitySort);
  }
}

class UpdateAdminLL_property_isPropCountrySort implements Action {
  final bool isPropCountrySort;

  UpdateAdminLL_property_isPropCountrySort(this.isPropCountrySort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropCountrySort: isPropCountrySort);
  }
}

class UpdateAdminLL_property_isPropTypeSort implements Action {
  final bool isPropTypeSort;

  UpdateAdminLL_property_isPropTypeSort(this.isPropTypeSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropTypeSort: isPropTypeSort);
  }
}

class UpdateAdminLL_property_isPropVacancySort implements Action {
  final bool isPropVacancySort;

  UpdateAdminLL_property_isPropVacancySort(this.isPropVacancySort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropVacancySort: isPropVacancySort);
  }
}

class UpdateAdminLL_property_isPropTenantNameSort implements Action {
  final bool isPropTenantNameSort;

  UpdateAdminLL_property_isPropTenantNameSort(this.isPropTenantNameSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropTenantNameSort: isPropTenantNameSort);
  }
}

class UpdateAdminLL_property_isPropStatusSort implements Action {
  final bool isPropStatusSort;

  UpdateAdminLL_property_isPropStatusSort(this.isPropStatusSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropStatusSort: isPropStatusSort);
  }
}

class UpdateAdminLL_property_isPropActInActSort implements Action {
  final bool isPropActInActSort;

  UpdateAdminLL_property_isPropActInActSort(this.isPropActInActSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(isPropActInActSort: isPropActInActSort);
  }
}

class UpdateAdminLL_PropertyDatalist implements Action {
  final List<PropertyData> PropertyDatalist;

  UpdateAdminLL_PropertyDatalist(this.PropertyDatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(PropertyDatalist: PropertyDatalist);
  }
}

class UpdateAdminLL_Property_isloding implements Action {
  final bool isloding;

  UpdateAdminLL_Property_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(isloding: isloding);
  }
}

class UpdateAdminLL_Property_pageNo implements Action {
  final int pageNo;

  UpdateAdminLL_Property_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(pageNo: pageNo);
  }
}

class UpdateAdminLL_Property_totalpage implements Action {
  final int totalpage;

  UpdateAdminLL_Property_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(totalpage: totalpage);
  }
}

class UpdateAdminLL_Property_totalRecord implements Action {
  final int totalRecord;

  UpdateAdminLL_Property_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(totalRecord: totalRecord);
  }
}

class UpdateAdminLL_PropNameSortAcsDes implements Action {
  final int PropNameSortAcsDes;

  UpdateAdminLL_PropNameSortAcsDes(this.PropNameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(PropNameSortAcsDes: PropNameSortAcsDes);
  }
}

class UpdateAdminLL_PropUnitSortAcsDes implements Action {
  final int PropUnitSortAcsDes;

  UpdateAdminLL_PropUnitSortAcsDes(this.PropUnitSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(PropUnitSortAcsDes: PropUnitSortAcsDes);
  }
}

class UpdateAdminLL_PropCitySortAcsDes implements Action {
  final int PropCitySortAcsDes;

  UpdateAdminLL_PropCitySortAcsDes(this.PropCitySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(PropCitySortAcsDes: PropCitySortAcsDes);
  }
}

class UpdateAdminLL_PropCountrySortAcsDes implements Action {
  final int PropCountrySortAcsDes;

  UpdateAdminLL_PropCountrySortAcsDes(this.PropCountrySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(
        PropCountrySortAcsDes: PropCountrySortAcsDes);
  }
}

class UpdateAdminLL_PropTypeSortAcsDes implements Action {
  final int PropTypeSortAcsDes;

  UpdateAdminLL_PropTypeSortAcsDes(this.PropTypeSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(PropTypeSortAcsDes: PropTypeSortAcsDes);
  }
}

class UpdateAdminLL_PropVacancySortAcsDes implements Action {
  final int PropVacancySortAcsDes;

  UpdateAdminLL_PropVacancySortAcsDes(this.PropVacancySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(
        PropVacancySortAcsDes: PropVacancySortAcsDes);
  }
}

class UpdateAdminLL_PropTenantNameSortAcsDes implements Action {
  final int PropTenantNameSortAcsDes;

  UpdateAdminLL_PropTenantNameSortAcsDes(this.PropTenantNameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(
        PropTenantNameSortAcsDes: PropTenantNameSortAcsDes);
  }
}

class UpdateAdminLL_PropStatusSortAcsDes implements Action {
  final int PropStatusSortAcsDes;

  UpdateAdminLL_PropStatusSortAcsDes(this.PropStatusSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordPropertyState(PropStatusSortAcsDes: PropStatusSortAcsDes);
  }
}

class UpdateAdminLL_PropActInActSortAcsDes implements Action {
  final int PropActInActSortAcsDes;

  UpdateAdminLL_PropActInActSortAcsDes(this.PropActInActSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(
        PropActInActSortAcsDes: PropActInActSortAcsDes);
  }
}

class UpdateAdminLL_LandlordPropertySearchText implements Action {
  final String LandlordPropertySearchText;

  UpdateAdminLL_LandlordPropertySearchText(this.LandlordPropertySearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordPropertyState(
        LandlordPropertySearchText: LandlordPropertySearchText);
  }
}

import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/propertylist.dart';

import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/domain/actions/action.dart';

class UpdatePropertyListNameSort implements Action {
  final bool isSort;

  UpdatePropertyListNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isPropertyNameSort: isSort);
  }
}

class UpdatePropertyListUnitSort implements Action {
  final bool isSort;

  UpdatePropertyListUnitSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isPropertyUnitSort: isSort);
  }
}

class UpdatePropertyListCitySort implements Action {
  final bool isSort;

  UpdatePropertyListCitySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isCitySort: isSort);
  }
}

class UpdatePropertyListCountrySort implements Action {
  final bool isSort;

  UpdatePropertyListCountrySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isCountrySort: isSort);
  }
}

class UpdatePropertyListPropertyTypeSort implements Action {
  final bool isSort;

  UpdatePropertyListPropertyTypeSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isPropertyTypeSort: isSort);
  }
}

class UpdatePropertyListVacancySort implements Action {
  final bool isSort;

  UpdatePropertyListVacancySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isvacancySort: isSort);
  }
}

class UpdatePropertyListActiveInactiveSort implements Action {
  final bool isSort;

  UpdatePropertyListActiveInactiveSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isActiveInactiveSort: isSort);
  }
}

class UpdatePropertyListisPublishedSort implements Action {
  final bool isSort;

  UpdatePropertyListisPublishedSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isPublishedSort: isSort);
  }
}

class UpdatePropertyList implements Action {
  final List<PropertyDataList> plist;

  UpdatePropertyList(this.plist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(propertylist: plist);
  }
}

class UpdatePropertyStatus_UnitsHeld implements Action {
  final int status_UnitsHeld;

  UpdatePropertyStatus_UnitsHeld(this.status_UnitsHeld);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(status_UnitsHeld: status_UnitsHeld);
  }
}

class UpdatePropertyStatus_UnitsRented implements Action {
  final int status_UnitsRented;

  UpdatePropertyStatus_UnitsRented(this.status_UnitsRented);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(status_UnitsRented: status_UnitsRented);
  }
}

class UpdatePropertyStatus_VacantUnits implements Action {
  final int status_VacantUnits;

  UpdatePropertyStatus_VacantUnits(this.status_VacantUnits);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(status_VacantUnits: status_VacantUnits);
  }
}

class UpdatePropertyListNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdatePropertyListNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(NameSortAcsDes: NameSortAcsDes);
  }
}

class UpdatePropertyListUnitSortAcsDes implements Action {
  final int UnitSortAcsDes;

  UpdatePropertyListUnitSortAcsDes(this.UnitSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(UnitSortAcsDes: UnitSortAcsDes);
  }
}

class UpdatePropertyListCitySortAcsDes implements Action {
  final int CitySortAcsDes;

  UpdatePropertyListCitySortAcsDes(this.CitySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(CitySortAcsDes: CitySortAcsDes);
  }
}

class UpdatePropertyListCountrySortAcsDes implements Action {
  final int CountrySortAcsDes;

  UpdatePropertyListCountrySortAcsDes(this.CountrySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(CountrySortAcsDes: CountrySortAcsDes);
  }
}

class UpdatePropertyListPropertyTypeSortAcsDes implements Action {
  final int PropertyTypeSortAcsDes;

  UpdatePropertyListPropertyTypeSortAcsDes(this.PropertyTypeSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(PropertyTypeSortAcsDes: PropertyTypeSortAcsDes);
  }
}

class UpdatePropertyListVacancySortAcsDes implements Action {
  final int VacancySortAcsDes;

  UpdatePropertyListVacancySortAcsDes(this.VacancySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(VacancySortAcsDes: VacancySortAcsDes);
  }
}

class UpdatePropertyListActiveSortAcsDes implements Action {
  final int ActiveSortAcsDes;

  UpdatePropertyListActiveSortAcsDes(this.ActiveSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(ActiveSortAcsDes: ActiveSortAcsDes);
  }
}

class UpdatePropertyListPublishedSortAcsDes implements Action {
  final int PublishedSortAcsDes;

  UpdatePropertyListPublishedSortAcsDes(this.PublishedSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(PublishedSortAcsDes: PublishedSortAcsDes);
  }
}

class UpdatePropertyListIsloding implements Action {
  final bool isloding;

  UpdatePropertyListIsloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(isloding: isloding);
  }
}

class UpdatePropertyListPropertySearchText implements Action {
  final String PropertySearchText;

  UpdatePropertyListPropertySearchText(this.PropertySearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyListState(PropertySearchText: PropertySearchText);
  }
}

class UpdatePropertyListPageNo implements Action {
  final int pageNo;

  UpdatePropertyListPageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(pageNo: pageNo);
  }
}

class UpdatePropertyListTotalpage implements Action {
  final int totalpage;

  UpdatePropertyListTotalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(totalpage: totalpage);
  }
}

class UpdatePropertyListTotalRecord implements Action {
  final int totalRecord;

  UpdatePropertyListTotalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyListState(totalRecord: totalRecord);
  }
}

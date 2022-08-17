import 'package:silverhome/domain/entities/event_typesdata.dart';
import 'package:silverhome/domain/entities/eventtypeslist.dart';

import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/domain/actions/action.dart';

class UpdateEventTypesListNameSort implements Action {
  final bool isSort;

  UpdateEventTypesListNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isEventTypesNameSort: isSort);
  }
}

class UpdateEventTypesListUnitSort implements Action {
  final bool isSort;

  UpdateEventTypesListUnitSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isEventTypesUnitSort: isSort);
  }
}

class UpdateEventTypesListCitySort implements Action {
  final bool isSort;

  UpdateEventTypesListCitySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isCitySort: isSort);
  }
}

class UpdateEventTypesListCountrySort implements Action {
  final bool isSort;

  UpdateEventTypesListCountrySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isCountrySort: isSort);
  }
}

class UpdateEventTypesListEventTypesTypeSort implements Action {
  final bool isSort;

  UpdateEventTypesListEventTypesTypeSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isEventTypesTypeSort: isSort);
  }
}

class UpdateEventTypesListVacancySort implements Action {
  final bool isSort;

  UpdateEventTypesListVacancySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isvacancySort: isSort);
  }
}

class UpdateEventTypesListActiveInactiveSort implements Action {
  final bool isSort;

  UpdateEventTypesListActiveInactiveSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isActiveInactiveSort: isSort);
  }
}

class UpdateEventTypesListisPublishedSort implements Action {
  final bool isSort;

  UpdateEventTypesListisPublishedSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isPublishedSort: isSort);
  }
}

class UpdateEventTypesList implements Action {
  final List<EventTypesDataList> plist;

  UpdateEventTypesList(this.plist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(eventtypeslist: plist);
  }
}

class UpdateEventTypesStatus_UnitsHeld implements Action {
  final int status_UnitsHeld;

  UpdateEventTypesStatus_UnitsHeld(this.status_UnitsHeld);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(status_UnitsHeld: status_UnitsHeld);
  }
}

class UpdateEventTypesStatus_UnitsRented implements Action {
  final int status_UnitsRented;

  UpdateEventTypesStatus_UnitsRented(this.status_UnitsRented);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(status_UnitsRented: status_UnitsRented);
  }
}

class UpdateEventTypesStatus_VacantUnits implements Action {
  final int status_VacantUnits;

  UpdateEventTypesStatus_VacantUnits(this.status_VacantUnits);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(status_VacantUnits: status_VacantUnits);
  }
}

class UpdateEventTypesListNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateEventTypesListNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(NameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateEventTypesListUnitSortAcsDes implements Action {
  final int UnitSortAcsDes;

  UpdateEventTypesListUnitSortAcsDes(this.UnitSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(UnitSortAcsDes: UnitSortAcsDes);
  }
}

class UpdateEventTypesListCitySortAcsDes implements Action {
  final int CitySortAcsDes;

  UpdateEventTypesListCitySortAcsDes(this.CitySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(CitySortAcsDes: CitySortAcsDes);
  }
}

class UpdateEventTypesListCountrySortAcsDes implements Action {
  final int CountrySortAcsDes;

  UpdateEventTypesListCountrySortAcsDes(this.CountrySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(CountrySortAcsDes: CountrySortAcsDes);
  }
}

class UpdateEventTypesListEventTypesTypeSortAcsDes implements Action {
  final int EventTypesTypeSortAcsDes;

  UpdateEventTypesListEventTypesTypeSortAcsDes(this.EventTypesTypeSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(
        EventTypesTypeSortAcsDes: EventTypesTypeSortAcsDes);
  }
}

class UpdateEventTypesListVacancySortAcsDes implements Action {
  final int VacancySortAcsDes;

  UpdateEventTypesListVacancySortAcsDes(this.VacancySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(VacancySortAcsDes: VacancySortAcsDes);
  }
}

class UpdateEventTypesListActiveSortAcsDes implements Action {
  final int ActiveSortAcsDes;

  UpdateEventTypesListActiveSortAcsDes(this.ActiveSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(ActiveSortAcsDes: ActiveSortAcsDes);
  }
}

class UpdateEventTypesListPublishedSortAcsDes implements Action {
  final int PublishedSortAcsDes;

  UpdateEventTypesListPublishedSortAcsDes(this.PublishedSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(PublishedSortAcsDes: PublishedSortAcsDes);
  }
}

class UpdateEventTypesListIsloding implements Action {
  final bool isloding;

  UpdateEventTypesListIsloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(isloding: isloding);
  }
}

class UpdateEventTypesListEventTypesSearchText implements Action {
  final String EventTypesSearchText;

  UpdateEventTypesListEventTypesSearchText(this.EventTypesSearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesListState(EventTypesSearchText: EventTypesSearchText);
  }
}

class UpdateEventTypesListPageNo implements Action {
  final int pageNo;

  UpdateEventTypesListPageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(pageNo: pageNo);
  }
}

class UpdateEventTypesListTotalpage implements Action {
  final int totalpage;

  UpdateEventTypesListTotalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(totalpage: totalpage);
  }
}

class UpdateEventTypesListTotalRecord implements Action {
  final int totalRecord;

  UpdateEventTypesListTotalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesListState(totalRecord: totalRecord);
  }
}

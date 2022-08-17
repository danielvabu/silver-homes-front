import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/eventtypeslist.dart';

part 'eventtypes_list_state.freezed.dart';

@freezed
abstract class EventTypesListState with _$EventTypesListState {
  const factory EventTypesListState({
    required int status_UnitsHeld,
    required int status_UnitsRented,
    required int status_VacantUnits,
    required bool isEventTypesNameSort,
    required int NameSortAcsDes,
    required bool isEventTypesUnitSort,
    required int UnitSortAcsDes,
    required bool isCitySort,
    required int CitySortAcsDes,
    required bool isCountrySort,
    required int CountrySortAcsDes,
    required bool isEventTypesTypeSort,
    required int EventTypesTypeSortAcsDes,
    required bool isvacancySort,
    required int VacancySortAcsDes,
    required bool isActiveInactiveSort,
    required int ActiveSortAcsDes,
    required bool isPublishedSort,
    required int PublishedSortAcsDes,
    required String EventTypesSearchText,
    required List<EventTypesDataList> eventtypeslist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _EventTypesListState;

  factory EventTypesListState.initial() => EventTypesListState(
        status_UnitsHeld: 0,
        status_UnitsRented: 0,
        status_VacantUnits: 0,
        isEventTypesNameSort: false,
        NameSortAcsDes: 0,
        isEventTypesUnitSort: false,
        UnitSortAcsDes: 0,
        isCitySort: false,
        CitySortAcsDes: 0,
        isCountrySort: false,
        CountrySortAcsDes: 0,
        isEventTypesTypeSort: false,
        EventTypesTypeSortAcsDes: 0,
        isvacancySort: false,
        VacancySortAcsDes: 0,
        isActiveInactiveSort: false,
        ActiveSortAcsDes: 0,
        isPublishedSort: false,
        PublishedSortAcsDes: 0,
        EventTypesSearchText: "",
        eventtypeslist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}

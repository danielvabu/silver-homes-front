import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/eventtypeslist.dart';
import 'package:silverhome/domain/entities/slots.dart';

part 'slots_list_state.freezed.dart';

@freezed
abstract class SlotsListState with _$SlotsListState {
  const factory SlotsListState({
    required int status_UnitsHeld,
    required int status_UnitsRented,
    required int status_VacantUnits,
    required bool isSlotsNameSort,
    required int NameSortAcsDes,
    required bool isSlotsUnitSort,
    required int UnitSortAcsDes,
    required bool isCitySort,
    required int CitySortAcsDes,
    required bool isCountrySort,
    required int CountrySortAcsDes,
    required bool isSlotsTypeSort,
    required int SlotsTypeSortAcsDes,
    required bool isvacancySort,
    required int VacancySortAcsDes,
    required bool isActiveInactiveSort,
    required int ActiveSortAcsDes,
    required bool isPublishedSort,
    required int PublishedSortAcsDes,
    required String SlotsSearchText,
    required List<Slots> eventtypeslist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _SlotsListState;

  factory SlotsListState.initial() => SlotsListState(
        status_UnitsHeld: 0,
        status_UnitsRented: 0,
        status_VacantUnits: 0,
        isSlotsNameSort: false,
        NameSortAcsDes: 0,
        isSlotsUnitSort: false,
        UnitSortAcsDes: 0,
        isCitySort: false,
        CitySortAcsDes: 0,
        isCountrySort: false,
        CountrySortAcsDes: 0,
        isSlotsTypeSort: false,
        SlotsTypeSortAcsDes: 0,
        isvacancySort: false,
        VacancySortAcsDes: 0,
        isActiveInactiveSort: false,
        ActiveSortAcsDes: 0,
        isPublishedSort: false,
        PublishedSortAcsDes: 0,
        SlotsSearchText: "",
        eventtypeslist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}

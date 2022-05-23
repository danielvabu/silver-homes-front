import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertylist.dart';

part 'property_list_state.freezed.dart';

@freezed
abstract class PropertyListState with _$PropertyListState {
  const factory PropertyListState({
    required int status_UnitsHeld,
    required int status_UnitsRented,
    required int status_VacantUnits,
    required bool isPropertyNameSort,
    required int NameSortAcsDes,
    required bool isPropertyUnitSort,
    required int UnitSortAcsDes,
    required bool isCitySort,
    required int CitySortAcsDes,
    required bool isCountrySort,
    required int CountrySortAcsDes,
    required bool isPropertyTypeSort,
    required int PropertyTypeSortAcsDes,
    required bool isvacancySort,
    required int VacancySortAcsDes,
    required bool isActiveInactiveSort,
    required int ActiveSortAcsDes,
    required bool isPublishedSort,
    required int PublishedSortAcsDes,
    required String PropertySearchText,
    required List<PropertyDataList> propertylist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _PropertyListState;

  factory PropertyListState.initial() => PropertyListState(
        status_UnitsHeld: 0,
        status_UnitsRented: 0,
        status_VacantUnits: 0,
        isPropertyNameSort: false,
        NameSortAcsDes: 0,
        isPropertyUnitSort: false,
        UnitSortAcsDes: 0,
        isCitySort: false,
        CitySortAcsDes: 0,
        isCountrySort: false,
        CountrySortAcsDes: 0,
        isPropertyTypeSort: false,
        PropertyTypeSortAcsDes: 0,
        isvacancySort: false,
        VacancySortAcsDes: 0,
        isActiveInactiveSort: false,
        ActiveSortAcsDes: 0,
        isPublishedSort: false,
        PublishedSortAcsDes: 0,
        PropertySearchText: "",
        propertylist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}

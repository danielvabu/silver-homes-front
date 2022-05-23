import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';

part 'admin_landlord_property_state.freezed.dart';

@freezed
abstract class AdminLandlordPropertyState with _$AdminLandlordPropertyState {
  const factory AdminLandlordPropertyState({
    required bool isPropNameSort,
    required int PropNameSortAcsDes,
    required bool isPropUnitSort,
    required int PropUnitSortAcsDes,
    required bool isPropCitySort,
    required int PropCitySortAcsDes,
    required bool isPropCountrySort,
    required int PropCountrySortAcsDes,
    required bool isPropTypeSort,
    required int PropTypeSortAcsDes,
    required bool isPropVacancySort,
    required int PropVacancySortAcsDes,
    required bool isPropTenantNameSort,
    required int PropTenantNameSortAcsDes,
    required bool isPropStatusSort,
    required int PropStatusSortAcsDes,
    required bool isPropActInActSort,
    required int PropActInActSortAcsDes,
    required String LandlordPropertySearchText,
    required List<PropertyData> PropertyDatalist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _AdminLandlordPropertyState;

  factory AdminLandlordPropertyState.initial() => AdminLandlordPropertyState(
        isPropNameSort: false,
        PropNameSortAcsDes: 1,
        isPropUnitSort: false,
        PropUnitSortAcsDes: 0,
        isPropCitySort: false,
        PropCitySortAcsDes: 0,
        isPropCountrySort: false,
        PropCountrySortAcsDes: 0,
        isPropTypeSort: false,
        PropTypeSortAcsDes: 0,
        isPropVacancySort: false,
        PropVacancySortAcsDes: 0,
        isPropTenantNameSort: false,
        PropTenantNameSortAcsDes: 0,
        isPropStatusSort: false,
        PropStatusSortAcsDes: 0,
        isPropActInActSort: false,
        PropActInActSortAcsDes: 0,
        LandlordPropertySearchText: "",
        PropertyDatalist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}

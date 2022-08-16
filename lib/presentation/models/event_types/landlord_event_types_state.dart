import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/event_typesdata.dart';

part 'landlord_event_types_state.freezed.dart';

@freezed
abstract class LandlordEventTypesState with _$LandlordEventTypesState {
  const factory LandlordEventTypesState({
    required int status_TotalEventTypes,
    required bool isCompanyNameSort,
    required int CompanyNameSortAcsDes,
    required bool isCitySort,
    required int CitySortAcsDes,
    required bool isContactNameSort,
    required int ContactNameSortAcsDes,
    required bool isEmaiSort,
    required int EmailSortAcsDes,
    required bool isPhoneSort,
    required int PhoneSortAcsDes,
    required bool isCategorySort,
    required int CategorySortAcsDes,
    required bool isRatingSort,
    required int RatingSortAcsDes,
    required String SearchText,
    required List<EventTypesData> eventtypesdatalist,
    required bool isloding,
    required int pageNo,
    required int totalpage,
    required int totalRecord,
  }) = _LandlordEventTypesState;

  factory LandlordEventTypesState.initial() => LandlordEventTypesState(
        status_TotalEventTypes: 0,
        isCompanyNameSort: false,
        CompanyNameSortAcsDes: 0,
        isCitySort: false,
        CitySortAcsDes: 0,
        isContactNameSort: false,
        ContactNameSortAcsDes: 0,
        isEmaiSort: false,
        EmailSortAcsDes: 0,
        isPhoneSort: false,
        PhoneSortAcsDes: 0,
        isCategorySort: false,
        CategorySortAcsDes: 0,
        isRatingSort: false,
        RatingSortAcsDes: 0,
        SearchText: "",
        eventtypesdatalist: List.empty(),
        isloding: false,
        pageNo: 1,
        totalpage: 0,
        totalRecord: 0,
      );
}

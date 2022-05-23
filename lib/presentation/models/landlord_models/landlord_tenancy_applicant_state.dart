import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'landlord_tenancy_applicant_state.freezed.dart';

@freezed
abstract class LandLordTenancyApplicantState
    with _$LandLordTenancyApplicantState {
  const factory LandLordTenancyApplicantState({
    required int selecttoggle,
    required bool isNameSort,
    required bool isPropertySort,
    required bool isRatingSort,
    required bool isDateSentSort,
    required bool isDateReceiveSort,
    required bool isAppStatusSort,
    required bool isOneItemSelect,
    PropertyData? propertyValue,
    required List<TenancyApplication> applicationlead,
    required List<TenancyApplication> filterapplicationlead,
    required List<PropertyData> propertylist,
    required bool isloding,
  }) = _LandLordTenancyApplicantState;

  factory LandLordTenancyApplicantState.initial() =>
      LandLordTenancyApplicantState(
        selecttoggle: 0,
        isNameSort: false,
        isPropertySort: false,
        isRatingSort: false,
        isDateSentSort: false,
        isDateReceiveSort: false,
        isAppStatusSort: false,
        isOneItemSelect: false,
        applicationlead: List.empty(),
        filterapplicationlead: List.empty(),
        propertylist: List.empty(),
        propertyValue: null,
        isloding: false,
      );
}

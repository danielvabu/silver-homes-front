import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'landlord_tenancy_lead_state.freezed.dart';

@freezed
abstract class LandLordTenancyLeadState with _$LandLordTenancyLeadState {
  const factory LandLordTenancyLeadState({
    required int selecttoggle,
    required bool isNameSort,
    required bool isPropertySort,
    required bool isRatingSort,
    required bool isemailSort,
    required bool isphoneSort,
    required bool isDatecreateSort,
    required bool isAppStatusSort,
    required bool isOneItemSelect,
    PropertyData? propertyValue,
    required List<TenancyApplication> applicationlead,
    required List<TenancyApplication> filterapplicationlead,
    required List<PropertyData> propertylist,
    required bool isloding,
  }) = _LandLordTenancyLeadState;

  factory LandLordTenancyLeadState.initial() => LandLordTenancyLeadState(
        selecttoggle: 0,
        isNameSort: false,
        isPropertySort: false,
        isRatingSort: false,
        isemailSort: false,
        isphoneSort: false,
        isDatecreateSort: false,
        isAppStatusSort: false,
        isOneItemSelect: false,
        applicationlead: List.empty(),
        filterapplicationlead: List.empty(),
        propertylist: List.empty(),
        propertyValue: null,
        isloding: false,
      );
}

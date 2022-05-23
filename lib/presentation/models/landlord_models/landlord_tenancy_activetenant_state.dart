import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'landlord_tenancy_activetenant_state.freezed.dart';

@freezed
abstract class LandLordActiveTenantState with _$LandLordActiveTenantState {
  const factory LandLordActiveTenantState({
    required int selecttoggle,
    required bool isNameSort,
    required bool isPropertySort,
    required bool isRatingSort,
    required bool isLeasStartDateSort,
    required bool isLeaseDurationSort,
    required bool isAppStatusSort,
    required bool isLeaseStatusSort,
    PropertyData? propertyValue,
    required List<TenancyApplication> activetenantleadlist,
    required List<TenancyApplication> filteractivetenantleadlist,
    required List<PropertyData> propertylist,
    required bool isloding,
  }) = _LandLordActiveTenantState;

  factory LandLordActiveTenantState.initial() => LandLordActiveTenantState(
        selecttoggle: 0,
        isNameSort: false,
        isPropertySort: false,
        isRatingSort: false,
        isLeasStartDateSort: false,
        isLeaseDurationSort: false,
        isAppStatusSort: false,
        isLeaseStatusSort: false,
        activetenantleadlist: List.empty(),
        filteractivetenantleadlist: List.empty(),
        propertylist: List.empty(),
        propertyValue: null,
        isloding: false,
      );
}

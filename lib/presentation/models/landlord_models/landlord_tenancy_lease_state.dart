import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'landlord_tenancy_lease_state.freezed.dart';

@freezed
abstract class LandLordTenancyLeaseState with _$LandLordTenancyLeaseState {
  const factory LandLordTenancyLeaseState({
    required int selecttoggle,
    required bool isNameSort,
    required bool isPropertySort,
    required bool isRatingSort,
    required bool isDateSentSort,
    required bool isDateReceiveSort,
    required bool isAppStatusSort,
    required bool isLeaseStatusSort,
    PropertyData? propertyValue,
    required List<TenancyApplication> leaseleadlist,
    required List<TenancyApplication> filterleaseleadlist,
    required List<PropertyData> propertylist,
    required bool isloding,
  }) = _LandLordTenancyLeaseState;

  factory LandLordTenancyLeaseState.initial() => LandLordTenancyLeaseState(
        selecttoggle: 0,
        isNameSort: false,
        isPropertySort: false,
        isRatingSort: false,
        isDateSentSort: false,
        isDateReceiveSort: false,
        isAppStatusSort: false,
        isLeaseStatusSort: false,
        leaseleadlist: List.empty(),
        filterleaseleadlist: List.empty(),
        propertylist: List.empty(),
        propertyValue: null,
        isloding: false,
      );
}

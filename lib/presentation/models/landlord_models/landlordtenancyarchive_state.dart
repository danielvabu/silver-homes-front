import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'landlordtenancyarchive_state.freezed.dart';

@freezed
abstract class LandLordTenancyArchiveState with _$LandLordTenancyArchiveState {
  const factory LandLordTenancyArchiveState({
    required int selecttoggle,
    required bool isNameSort,
    required bool isPropertySort,
    required bool isRatingSort,
    required bool isDateSentSort,
    required bool isDateReceiveSort,
    required bool isAppStatusSort,
    required bool isOneItemSelect,
    PropertyData? propertyValue,
    required List<TenancyApplication> archiveleadlist,
    required List<TenancyApplication> filterarchiveleadlist,
    required List<PropertyData> propertylist,
    required bool isloding,
  }) = _LandLordTenancyArchiveState;

  factory LandLordTenancyArchiveState.initial() => LandLordTenancyArchiveState(
        selecttoggle: 0,
        isNameSort: false,
        isPropertySort: false,
        isRatingSort: false,
        isDateSentSort: false,
        isDateReceiveSort: false,
        isAppStatusSort: false,
        isOneItemSelect: false,
        archiveleadlist: List.empty(),
        filterarchiveleadlist: List.empty(),
        propertylist: List.empty(),
        propertyValue: null,
        isloding: false,
      );
}

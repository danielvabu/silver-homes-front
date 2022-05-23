import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'referencecheck_state.freezed.dart';

@freezed
abstract class ReferenceCheckState with _$ReferenceCheckState {
  const factory ReferenceCheckState({
    required int selecttoggle,
    required bool isNameSort,
    required bool isPropertySort,
    required bool isRatingSort,
    required bool isDateSentSort,
    required bool isDateReceiveSort,
    required bool isAppStatusSort,
    required bool isReferenceSort,
    PropertyData? propertyValue,
    required List<TenancyApplication> ReferenceCheckslist,
    required List<TenancyApplication> filterReferenceCheckslist,
    required List<PropertyData> propertylist,
    required bool isloding,
  }) = _ReferenceCheckState;

  factory ReferenceCheckState.initial() => ReferenceCheckState(
        selecttoggle: 0,
        isNameSort: false,
        isPropertySort: false,
        isRatingSort: false,
        isDateSentSort: false,
        isDateReceiveSort: false,
        isAppStatusSort: false,
        isReferenceSort: false,
        ReferenceCheckslist: List.empty(),
        filterReferenceCheckslist: List.empty(),
        propertylist: List.empty(),
        propertyValue: null,
        isloding: false,
      );
}

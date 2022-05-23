import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';

part 'varification_document_state.freezed.dart';

@freezed
abstract class VarificationDocumentState with _$VarificationDocumentState {
  const factory VarificationDocumentState({
    required int selecttoggle,
    required bool isNameSort,
    required bool isPropertySort,
    required bool isRatingSort,
    required bool isDateSentSort,
    required bool isDateReceiveSort,
    required bool isAppStatusSort,
    required bool isDocStatusSort,
    PropertyData? propertyValue,
    required List<TenancyApplication> varificationdoclist,
    required List<TenancyApplication> filtervarificationdoclist,
    required List<PropertyData> propertylist,
    required bool isloding,
  }) = _VarificationDocumentState;

  factory VarificationDocumentState.initial() => VarificationDocumentState(
        selecttoggle: 0,
        isNameSort: false,
        isPropertySort: false,
        isRatingSort: false,
        isDateSentSort: false,
        isDateReceiveSort: false,
        isAppStatusSort: false,
        isDocStatusSort: false,
        varificationdoclist: List.empty(),
        filtervarificationdoclist: List.empty(),
        propertylist: List.empty(),
        propertyValue: null,
        isloding: false,
      );
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reference_questionnaire_details_state.freezed.dart';

@freezed
abstract class ReferenceQuestionnaireDetailsState
    with _$ReferenceQuestionnaireDetailsState {
  const factory ReferenceQuestionnaireDetailsState({
    required int lenth_tenancy,
    required double CleanlinessRating,
    required double CommunicationRating,
    required double RespectfulnessRating,
    required double PaymentPunctualityRating,
    required bool yesNo,
    required String ReasonDeparture,
    required String OtherComments,
    required String PropertyName,
    required String ApplicantName,
    required String ReferenceName,
    required String ReferenceRelationShip,
    required String ReferenceEmail,
    required String ReferencePhone,
  }) = _ReferenceQuestionnaireDetailsState;

  factory ReferenceQuestionnaireDetailsState.initial() =>
      ReferenceQuestionnaireDetailsState(
        lenth_tenancy: 1,
        CleanlinessRating: 0,
        CommunicationRating: 0,
        RespectfulnessRating: 0,
        PaymentPunctualityRating: 0,
        yesNo: false,
        ReasonDeparture: "",
        OtherComments: "",
        ApplicantName: "",
        PropertyName: "",
        ReferenceName: "",
        ReferenceRelationShip: "",
        ReferenceEmail: "",
        ReferencePhone: "",
      );
}

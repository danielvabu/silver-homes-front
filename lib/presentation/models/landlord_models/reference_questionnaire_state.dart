import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'reference_questionnaire_state.freezed.dart';

@freezed
abstract class ReferenceQuestionnaireState with _$ReferenceQuestionnaireState {
  const factory ReferenceQuestionnaireState({
    required int lenth_tenancy,
    required double CleanlinessRating,
    required double CommunicationRating,
    required double RespectfulnessRating,
    required double PaymentPunctualityRating,
    bool? yesNo,
    required String ReasonDeparture,
    required String OtherComments,
    required String ApplicantName,
    required String ApplicantId,
    required String ReferenceName,
    required String ReferenceId,
    required String ApplicationId,
    required bool isUpdate,
    required String CompanyName,
    required String HomePagelink,
    required String CustomerFeatureListingURL,
    MediaInfo? CompanyLogo,
  }) = _ReferenceQuestionnaireState;

  factory ReferenceQuestionnaireState.initial() => ReferenceQuestionnaireState(
        lenth_tenancy: 0,
        CleanlinessRating: 0,
        CommunicationRating: 0,
        RespectfulnessRating: 0,
        PaymentPunctualityRating: 0,
        yesNo: null,
        ReasonDeparture: "",
        OtherComments: "",
        ApplicantName: "",
        ApplicantId: "",
        ReferenceName: "",
        ReferenceId: "",
        ApplicationId: "",
        isUpdate: false,
        CompanyName: "",
        HomePagelink: "",
        CustomerFeatureListingURL: "",
        CompanyLogo: null,
      );
}

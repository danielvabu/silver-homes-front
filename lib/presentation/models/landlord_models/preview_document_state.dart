import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'preview_document_state.freezed.dart';

@freezed
abstract class PreviewDocumentState with _$PreviewDocumentState {
  const factory PreviewDocumentState({
    required String MID_Doc1,
    MediaInfo? MediaDoc1,
    required String MID_Doc2,
    MediaInfo? MediaDoc2,
    required String MID_Doc3,
    MediaInfo? MediaDoc3,
    required String MID_Doc4,
    MediaInfo? MediaDoc4,
    required String Prop_ID,
    required String ApplicantID,
    required String ApplicantionID,
    required String applicationName,
    required double Rating,
    required String RatingReview,
    required SystemEnumDetails? ApplicationStatus,
    required SystemEnumDetails? DocReviewStatus,
  }) = _PreviewDocumentState;

  factory PreviewDocumentState.initial() => PreviewDocumentState(
        MID_Doc1: "",
        MediaDoc1: null,
        MID_Doc2: "",
        MediaDoc2: null,
        MID_Doc3: "",
        MediaDoc3: null,
        MID_Doc4: "",
        MediaDoc4: null,
        Prop_ID: "",
        ApplicantID: "",
        ApplicantionID: "",
        applicationName: "",
        Rating: 0,
        RatingReview: "",
        ApplicationStatus: null,
        DocReviewStatus: null,
      );
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'preview_lease_state.freezed.dart';

@freezed
abstract class PreviewLeaseState with _$PreviewLeaseState {
  const factory PreviewLeaseState({
    required String MID_Doc1,
    MediaInfo? MediaDoc1,
    required String ApplicantID,
    required String ApplicantionID,
    required String applicationName,
    required String AgreementReceiveDate,
  }) = _PreviewLeaseState;

  factory PreviewLeaseState.initial() => PreviewLeaseState(
        MID_Doc1: "",
        MediaDoc1: null,
        ApplicantID: "",
        ApplicantionID: "",
        applicationName: "",
        AgreementReceiveDate: "",
      );
}

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdatePLApplicantID implements Action {
  final String ApplicantID;

  UpdatePLApplicantID(this.ApplicantID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewLeaseState(ApplicantID: ApplicantID);
  }
}

class UpdatePLApplicantionID implements Action {
  final String ApplicantionID;

  UpdatePLApplicantionID(this.ApplicantionID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewLeaseState(ApplicantionID: ApplicantionID);
  }
}

class UpdatePLApplicationName implements Action {
  final String applicationName;

  UpdatePLApplicationName(this.applicationName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .previewLeaseState(applicationName: applicationName);
  }
}

class UpdatePLAgreementReceiveDate implements Action {
  final String AgreementReceiveDate;

  UpdatePLAgreementReceiveDate(this.AgreementReceiveDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .previewLeaseState(AgreementReceiveDate: AgreementReceiveDate);
  }
}

class UpdatePLMIDDoc1 implements Action {
  final String MID_Doc1;

  UpdatePLMIDDoc1(this.MID_Doc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewLeaseState(MID_Doc1: MID_Doc1);
  }
}

class UpdatePLMediaInfo1 implements Action {
  final MediaInfo? MediaDoc1;

  UpdatePLMediaInfo1(this.MediaDoc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewLeaseState(MediaDoc1: MediaDoc1);
  }
}

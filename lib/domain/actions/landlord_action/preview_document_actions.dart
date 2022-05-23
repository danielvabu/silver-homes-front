import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdatePDProp_ID implements Action {
  final String Prop_ID;

  UpdatePDProp_ID(this.Prop_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(Prop_ID: Prop_ID);
  }
}

class UpdatePDApplicantID implements Action {
  final String ApplicantID;

  UpdatePDApplicantID(this.ApplicantID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(ApplicantID: ApplicantID);
  }
}

class UpdatePDApplicantionID implements Action {
  final String ApplicantionID;

  UpdatePDApplicantionID(this.ApplicantionID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .previewDocumentState(ApplicantionID: ApplicantionID);
  }
}

class UpdatePDApplicationName implements Action {
  final String applicationName;

  UpdatePDApplicationName(this.applicationName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .previewDocumentState(applicationName: applicationName);
  }
}

class UpdatePDRatingReview implements Action {
  final String RatingReview;

  UpdatePDRatingReview(this.RatingReview);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(RatingReview: RatingReview);
  }
}

class UpdatePDRating implements Action {
  final double Rating;

  UpdatePDRating(this.Rating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(Rating: Rating);
  }
}

class UpdatePDApplicationStatus implements Action {
  final SystemEnumDetails? ApplicationStatus;

  UpdatePDApplicationStatus(this.ApplicationStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .previewDocumentState(ApplicationStatus: ApplicationStatus);
  }
}

class UpdatePDDocReviewStatus implements Action {
  final SystemEnumDetails? DocReviewStatus;

  UpdatePDDocReviewStatus(this.DocReviewStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .previewDocumentState(DocReviewStatus: DocReviewStatus);
  }
}

class UpdatePDMIDDoc1 implements Action {
  final String MID_Doc1;

  UpdatePDMIDDoc1(this.MID_Doc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MID_Doc1: MID_Doc1);
  }
}

class UpdatePDMIDDoc2 implements Action {
  final String MID_Doc2;

  UpdatePDMIDDoc2(this.MID_Doc2);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MID_Doc2: MID_Doc2);
  }
}

class UpdatePDMIDDoc3 implements Action {
  final String MID_Doc3;

  UpdatePDMIDDoc3(this.MID_Doc3);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MID_Doc3: MID_Doc3);
  }
}

class UpdatePDMIDDoc4 implements Action {
  final String MID_Doc4;

  UpdatePDMIDDoc4(this.MID_Doc4);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MID_Doc4: MID_Doc4);
  }
}

class UpdatePDMediaInfo1 implements Action {
  final MediaInfo? MediaDoc1;

  UpdatePDMediaInfo1(this.MediaDoc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MediaDoc1: MediaDoc1);
  }
}

class UpdatePDMediaInfo2 implements Action {
  final MediaInfo? MediaDoc2;

  UpdatePDMediaInfo2(this.MediaDoc2);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MediaDoc2: MediaDoc2);
  }
}

class UpdatePDMediaInfo3 implements Action {
  final MediaInfo? MediaDoc3;

  UpdatePDMediaInfo3(this.MediaDoc3);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MediaDoc3: MediaDoc3);
  }
}

class UpdatePDMediaInfo4 implements Action {
  final MediaInfo? MediaDoc4;

  UpdatePDMediaInfo4(this.MediaDoc4);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.previewDocumentState(MediaDoc4: MediaDoc4);
  }
}

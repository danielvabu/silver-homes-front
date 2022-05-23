import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateRQDetailsLenthTenancy implements Action {
  final int lenth_tenancy;

  UpdateRQDetailsLenthTenancy(this.lenth_tenancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(lenth_tenancy: lenth_tenancy);
  }
}

class UpdateRQDetailsCleanlinessRating implements Action {
  final double CleanlinessRating;

  UpdateRQDetailsCleanlinessRating(this.CleanlinessRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireDetailsState(
        CleanlinessRating: CleanlinessRating);
  }
}

class UpdateRQDetailsCommunicationRating implements Action {
  final double CommunicationRating;

  UpdateRQDetailsCommunicationRating(this.CommunicationRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireDetailsState(
        CommunicationRating: CommunicationRating);
  }
}

class UpdateRQDetailsRespectfulnessRating implements Action {
  final double RespectfulnessRating;

  UpdateRQDetailsRespectfulnessRating(this.RespectfulnessRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireDetailsState(
        RespectfulnessRating: RespectfulnessRating);
  }
}

class UpdateRQDetailsPaymentPunctualityRating implements Action {
  final double PaymentPunctualityRating;

  UpdateRQDetailsPaymentPunctualityRating(this.PaymentPunctualityRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireDetailsState(
        PaymentPunctualityRating: PaymentPunctualityRating);
  }
}

class UpdateRQDetailsYesNo implements Action {
  final bool yesNo;

  UpdateRQDetailsYesNo(this.yesNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireDetailsState(yesNo: yesNo);
  }
}

class UpdateRQDetailsReasonDeparture implements Action {
  final String ReasonDeparture;

  UpdateRQDetailsReasonDeparture(this.ReasonDeparture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(ReasonDeparture: ReasonDeparture);
  }
}

class UpdateRQDetailsOtherComments implements Action {
  final String OtherComments;

  UpdateRQDetailsOtherComments(this.OtherComments);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(OtherComments: OtherComments);
  }
}

class UpdateRQDetailsApplicantName implements Action {
  final String ApplicantName;

  UpdateRQDetailsApplicantName(this.ApplicantName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(ApplicantName: ApplicantName);
  }
}

class UpdateRQDetailsPropertyName implements Action {
  final String PropertyName;

  UpdateRQDetailsPropertyName(this.PropertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(PropertyName: PropertyName);
  }
}

class UpdateRQDetailsReferenceName implements Action {
  final String ReferenceName;

  UpdateRQDetailsReferenceName(this.ReferenceName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(ReferenceName: ReferenceName);
  }
}

class UpdateRQDetailsReferenceRelationShip implements Action {
  final String ReferenceRelationShip;

  UpdateRQDetailsReferenceRelationShip(this.ReferenceRelationShip);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireDetailsState(
        ReferenceRelationShip: ReferenceRelationShip);
  }
}

class UpdateRQDetailsReferenceEmail implements Action {
  final String ReferenceEmail;

  UpdateRQDetailsReferenceEmail(this.ReferenceEmail);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(ReferenceEmail: ReferenceEmail);
  }
}

class UpdateRQDetailsReferencePhone implements Action {
  final String ReferencePhone;

  UpdateRQDetailsReferencePhone(this.ReferencePhone);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireDetailsState(ReferencePhone: ReferencePhone);
  }
}

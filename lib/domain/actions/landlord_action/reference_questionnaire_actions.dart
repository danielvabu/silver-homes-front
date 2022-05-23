import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateRQLenthTenancy implements Action {
  final int lenth_tenancy;

  UpdateRQLenthTenancy(this.lenth_tenancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(lenth_tenancy: lenth_tenancy);
  }
}

class UpdateRQCleanlinessRating implements Action {
  final double CleanlinessRating;

  UpdateRQCleanlinessRating(this.CleanlinessRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(CleanlinessRating: CleanlinessRating);
  }
}

class UpdateRQCommunicationRating implements Action {
  final double CommunicationRating;

  UpdateRQCommunicationRating(this.CommunicationRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(CommunicationRating: CommunicationRating);
  }
}

class UpdateRQRespectfulnessRating implements Action {
  final double RespectfulnessRating;

  UpdateRQRespectfulnessRating(this.RespectfulnessRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireState(
        RespectfulnessRating: RespectfulnessRating);
  }
}

class UpdateRQPaymentPunctualityRating implements Action {
  final double PaymentPunctualityRating;

  UpdateRQPaymentPunctualityRating(this.PaymentPunctualityRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireState(
        PaymentPunctualityRating: PaymentPunctualityRating);
  }
}

class UpdateRQYesNo implements Action {
  final bool? yesNo;

  UpdateRQYesNo(this.yesNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireState(yesNo: yesNo);
  }
}

class UpdateRQReasonDeparture implements Action {
  final String ReasonDeparture;

  UpdateRQReasonDeparture(this.ReasonDeparture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(ReasonDeparture: ReasonDeparture);
  }
}

class UpdateRQOtherComments implements Action {
  final String OtherComments;

  UpdateRQOtherComments(this.OtherComments);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(OtherComments: OtherComments);
  }
}

class UpdateRQApplicantName implements Action {
  final String ApplicantName;

  UpdateRQApplicantName(this.ApplicantName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(ApplicantName: ApplicantName);
  }
}

class UpdateRQApplicantId implements Action {
  final String ApplicantId;

  UpdateRQApplicantId(this.ApplicantId);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(ApplicantId: ApplicantId);
  }
}

class UpdateRQReferenceName implements Action {
  final String ReferenceName;

  UpdateRQReferenceName(this.ReferenceName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(ReferenceName: ReferenceName);
  }
}

class UpdateRQReferenceId implements Action {
  final String ReferenceId;

  UpdateRQReferenceId(this.ReferenceId);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(ReferenceId: ReferenceId);
  }
}

class UpdateRQApplicationId implements Action {
  final String ApplicationId;

  UpdateRQApplicationId(this.ApplicationId);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(ApplicationId: ApplicationId);
  }
}

class UpdateRQisUpdate implements Action {
  final bool isUpdate;

  UpdateRQisUpdate(this.isUpdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireState(isUpdate: isUpdate);
  }
}

class UpdateRQCompanyName implements Action {
  final String CompanyName;

  UpdateRQCompanyName(this.CompanyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(CompanyName: CompanyName);
  }
}

class UpdateRQHomePagelink implements Action {
  final String HomePagelink;

  UpdateRQHomePagelink(this.HomePagelink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(HomePagelink: HomePagelink);
  }
}

class UpdateRQCustomerFeatureListingURL implements Action {
  final String CustomerFeatureListingURL;

  UpdateRQCustomerFeatureListingURL(this.CustomerFeatureListingURL);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceQuestionnaireState(
        CustomerFeatureListingURL: CustomerFeatureListingURL);
  }
}

class UpdateRQCompanyLogo implements Action {
  final MediaInfo? CompanyLogo;

  UpdateRQCompanyLogo(this.CompanyLogo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceQuestionnaireState(CompanyLogo: CompanyLogo);
  }
}

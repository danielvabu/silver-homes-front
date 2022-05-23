import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTLAPropertyAddress implements Action {
  final String propertyAddress;

  UpdateTLAPropertyAddress(this.propertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(propertyAddress: propertyAddress);
  }
}

class UpdateTLAProp_ID implements Action {
  final String Prop_ID;

  UpdateTLAProp_ID(this.Prop_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(Prop_ID: Prop_ID);
  }
}

class UpdateTLAOwner_ID implements Action {
  final String Owner_ID;

  UpdateTLAOwner_ID(this.Owner_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(Owner_ID: Owner_ID);
  }
}

class UpdateTLAApplication_ID implements Action {
  final String Application_ID;

  UpdateTLAApplication_ID(this.Application_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(Application_ID: Application_ID);
  }
}

class UpdateTLAIsbuttonActive implements Action {
  final bool isbuttonActive;

  UpdateTLAIsbuttonActive(this.isbuttonActive);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(isbuttonActive: isbuttonActive);
  }
}

class UpdateTLADocsFileExtension implements Action {
  final String docs_fileextension;

  UpdateTLADocsFileExtension(this.docs_fileextension);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(docs_fileextension: docs_fileextension);
  }
}

class UpdateTLADocsFileName implements Action {
  final String docs_filename;

  UpdateTLADocsFileName(this.docs_filename);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(docs_filename: docs_filename);
  }
}

class UpdateTLAUint8ListDocsFile implements Action {
  final Uint8List? docs_file;

  UpdateTLAUint8ListDocsFile(this.docs_file);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(docs_file: docs_file);
  }
}

class UpdateTLAApplicantID implements Action {
  final String ApplicantID;

  UpdateTLAApplicantID(this.ApplicantID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(ApplicantID: ApplicantID);
  }
}

class UpdateTLAMIDDoc1 implements Action {
  final String MID_Doc1;

  UpdateTLAMIDDoc1(this.MID_Doc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(MID_Doc1: MID_Doc1);
  }
}

class UpdateTLAMIDDoc2 implements Action {
  final String MID_Doc2;

  UpdateTLAMIDDoc2(this.MID_Doc2);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(MID_Doc2: MID_Doc2);
  }
}

class UpdateTLAMediaInfo1 implements Action {
  final MediaInfo? MediaDoc1;

  UpdateTLAMediaInfo1(this.MediaDoc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(MediaDoc1: MediaDoc1);
  }
}

class UpdateTLAMediaInfo2 implements Action {
  final MediaInfo? MediaDoc2;

  UpdateTLAMediaInfo2(this.MediaDoc2);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(MediaDoc2: MediaDoc2);
  }
}

class UpdateTLAIsDocAvailable implements Action {
  final bool IsDocAvailable;

  UpdateTLAIsDocAvailable(this.IsDocAvailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(IsDocAvailable: IsDocAvailable);
  }
}

class UpdateTLACompanyName implements Action {
  final String CompanyName;

  UpdateTLACompanyName(this.CompanyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(CompanyName: CompanyName);
  }
}

class UpdateTLAHomePagelink implements Action {
  final String HomePagelink;

  UpdateTLAHomePagelink(this.HomePagelink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(HomePagelink: HomePagelink);
  }
}

class UpdateTLACustomerFeatureListingURL implements Action {
  final String CustomerFeatureListingURL;

  UpdateTLACustomerFeatureListingURL(this.CustomerFeatureListingURL);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyLeaseAgreementState(
        CustomerFeatureListingURL: CustomerFeatureListingURL);
  }
}

class UpdateTLACompanyLogo implements Action {
  final MediaInfo? CompanyLogo;

  UpdateTLACompanyLogo(this.CompanyLogo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyLeaseAgreementState(CompanyLogo: CompanyLogo);
  }
}

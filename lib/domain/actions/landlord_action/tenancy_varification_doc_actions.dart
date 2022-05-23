import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTVDPropertyAddress implements Action {
  final String propertyAddress;

  UpdateTVDPropertyAddress(this.propertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(propertyAddress: propertyAddress);
  }
}

class UpdateTVDNotapplicableDoc3 implements Action {
  final bool notapplicable_doc3;

  UpdateTVDNotapplicableDoc3(this.notapplicable_doc3);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyVarificationDocumentState(
        notapplicable_doc3: notapplicable_doc3);
  }
}

class UpdateTVDNotapplicableDoc4 implements Action {
  final bool notapplicable_doc4;

  UpdateTVDNotapplicableDoc4(this.notapplicable_doc4);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyVarificationDocumentState(
        notapplicable_doc4: notapplicable_doc4);
  }
}

class UpdateTVDIsbuttonActive implements Action {
  final bool isbuttonActive;

  UpdateTVDIsbuttonActive(this.isbuttonActive);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(isbuttonActive: isbuttonActive);
  }
}

class UpdateTVDDocs1FileExtension implements Action {
  final String docs1_fileextension;

  UpdateTVDDocs1FileExtension(this.docs1_fileextension);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyVarificationDocumentState(
        docs1_fileextension: docs1_fileextension);
  }
}

class UpdateTVDDocs1FileName implements Action {
  final String docs1_filename;

  UpdateTVDDocs1FileName(this.docs1_filename);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs1_filename: docs1_filename);
  }
}

class UpdateTVDDocs2FileExtension implements Action {
  final String docs2_fileextension;

  UpdateTVDDocs2FileExtension(this.docs2_fileextension);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyVarificationDocumentState(
        docs2_fileextension: docs2_fileextension);
  }
}

class UpdateTVDDocs2FileName implements Action {
  final String docs2_filename;

  UpdateTVDDocs2FileName(this.docs2_filename);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs2_filename: docs2_filename);
  }
}

class UpdateTVDDocs3FileExtension implements Action {
  final String docs3_fileextension;

  UpdateTVDDocs3FileExtension(this.docs3_fileextension);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyVarificationDocumentState(
        docs3_fileextension: docs3_fileextension);
  }
}

class UpdateTVDDocs3FileName implements Action {
  final String docs3_filename;

  UpdateTVDDocs3FileName(this.docs3_filename);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs3_filename: docs3_filename);
  }
}

class UpdateTVDDocs4FileExtension implements Action {
  final String docs4_fileextension;

  UpdateTVDDocs4FileExtension(this.docs4_fileextension);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyVarificationDocumentState(
        docs4_fileextension: docs4_fileextension);
  }
}

class UpdateTVDDocs4FileName implements Action {
  final String docs4_filename;

  UpdateTVDDocs4FileName(this.docs4_filename);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs4_filename: docs4_filename);
  }
}

class UpdateTVDUint8ListDocs1File implements Action {
  final Uint8List? docs1_file;

  UpdateTVDUint8ListDocs1File(this.docs1_file);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs1_file: docs1_file);
  }
}

class UpdateTVDUint8ListDocs2File implements Action {
  final Uint8List? docs2_file;

  UpdateTVDUint8ListDocs2File(this.docs2_file);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs2_file: docs2_file);
  }
}

class UpdateTVDUint8ListDocs3File implements Action {
  final Uint8List? docs3_file;

  UpdateTVDUint8ListDocs3File(this.docs3_file);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs3_file: docs3_file);
  }
}

class UpdateTVDUint8ListDocs4File implements Action {
  final Uint8List? docs4_file;

  UpdateTVDUint8ListDocs4File(this.docs4_file);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(docs4_file: docs4_file);
  }
}

class UpdateTVDApplicantID implements Action {
  final String ApplicantID;

  UpdateTVDApplicantID(this.ApplicantID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(ApplicantID: ApplicantID);
  }
}

class UpdateTVDMIDDoc1 implements Action {
  final String MID_Doc1;

  UpdateTVDMIDDoc1(this.MID_Doc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MID_Doc1: MID_Doc1);
  }
}

class UpdateTVDMIDDoc2 implements Action {
  final String MID_Doc2;

  UpdateTVDMIDDoc2(this.MID_Doc2);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MID_Doc2: MID_Doc2);
  }
}

class UpdateTVDMIDDoc3 implements Action {
  final String MID_Doc3;

  UpdateTVDMIDDoc3(this.MID_Doc3);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MID_Doc3: MID_Doc3);
  }
}

class UpdateTVDMIDDoc4 implements Action {
  final String MID_Doc4;

  UpdateTVDMIDDoc4(this.MID_Doc4);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MID_Doc4: MID_Doc4);
  }
}

class UpdateTVDMediaInfo1 implements Action {
  final MediaInfo? MediaDoc1;

  UpdateTVDMediaInfo1(this.MediaDoc1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MediaDoc1: MediaDoc1);
  }
}

class UpdateTVDMediaInfo2 implements Action {
  final MediaInfo? MediaDoc2;

  UpdateTVDMediaInfo2(this.MediaDoc2);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MediaDoc2: MediaDoc2);
  }
}

class UpdateTVDMediaInfo3 implements Action {
  final MediaInfo? MediaDoc3;

  UpdateTVDMediaInfo3(this.MediaDoc3);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MediaDoc3: MediaDoc3);
  }
}

class UpdateTVDMediaInfo4 implements Action {
  final MediaInfo? MediaDoc4;

  UpdateTVDMediaInfo4(this.MediaDoc4);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(MediaDoc4: MediaDoc4);
  }
}

class UpdateTVDIsDocAvailable implements Action {
  final bool IsDocAvailable;

  UpdateTVDIsDocAvailable(this.IsDocAvailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(IsDocAvailable: IsDocAvailable);
  }
}

class UpdateTVDCompanyName implements Action {
  final String CompanyName;

  UpdateTVDCompanyName(this.CompanyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(CompanyName: CompanyName);
  }
}

class UpdateTVDHomePagelink implements Action {
  final String HomePagelink;

  UpdateTVDHomePagelink(this.HomePagelink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(HomePagelink: HomePagelink);
  }
}

class UpdateTVDCustomerFeatureListingURL implements Action {
  final String CustomerFeatureListingURL;

  UpdateTVDCustomerFeatureListingURL(this.CustomerFeatureListingURL);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyVarificationDocumentState(
        CustomerFeatureListingURL: CustomerFeatureListingURL);
  }
}

class UpdateTVDCompanyLogo implements Action {
  final MediaInfo? CompanyLogo;

  UpdateTVDCompanyLogo(this.CompanyLogo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyVarificationDocumentState(CompanyLogo: CompanyLogo);
  }
}

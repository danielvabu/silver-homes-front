import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tenancy_lease_agreement_state.freezed.dart';

@freezed
abstract class TenancyLeaseAgreementState with _$TenancyLeaseAgreementState {
  factory TenancyLeaseAgreementState({
    required String propertyAddress,
    required String Prop_ID,
    required String Owner_ID,
    required String ApplicantID,
    required String Application_ID,
    required bool isbuttonActive,
    required bool IsDocAvailable,
    required String docs_fileextension,
    required String docs_filename,
    Uint8List? docs_file,
    required String MID_Doc1,
    MediaInfo? MediaDoc1,
    required String MID_Doc2,
    MediaInfo? MediaDoc2,
    required String CompanyName,
    required String HomePagelink,
    required String CustomerFeatureListingURL,
    MediaInfo? CompanyLogo,
  }) = _TenancyLeaseAgreementState;

  factory TenancyLeaseAgreementState.initial() => TenancyLeaseAgreementState(
        propertyAddress: "",
        Prop_ID: "",
        Owner_ID: "",
        ApplicantID: "",
        Application_ID: "",
        isbuttonActive: false,
        IsDocAvailable: false,
        docs_fileextension: "",
        docs_filename: "",
        docs_file: null,
        MID_Doc1: "",
        MediaDoc1: null,
        MID_Doc2: "",
        MediaDoc2: null,
        CompanyName: "",
        HomePagelink: "",
        CustomerFeatureListingURL: "",
        CompanyLogo: null,
      );
}

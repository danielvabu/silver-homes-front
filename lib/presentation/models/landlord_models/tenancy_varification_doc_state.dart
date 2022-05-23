import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tenancy_varification_doc_state.freezed.dart';

@freezed
abstract class TenancyVarificationDocumentState
    with _$TenancyVarificationDocumentState {
  factory TenancyVarificationDocumentState({
    required bool notapplicable_doc3,
    required bool notapplicable_doc4,
    required bool isbuttonActive,
    required String docs1_fileextension,
    required String docs1_filename,
    required String docs2_fileextension,
    required String docs2_filename,
    required String docs3_fileextension,
    required String docs3_filename,
    required String docs4_fileextension,
    required String docs4_filename,
    required String propertyAddress,
    required String ApplicantID,
    Uint8List? docs1_file,
    Uint8List? docs2_file,
    Uint8List? docs3_file,
    Uint8List? docs4_file,
    required bool IsDocAvailable,
    required String MID_Doc1,
    MediaInfo? MediaDoc1,
    required String MID_Doc2,
    MediaInfo? MediaDoc2,
    required String MID_Doc3,
    MediaInfo? MediaDoc3,
    required String MID_Doc4,
    MediaInfo? MediaDoc4,
    required String CompanyName,
    required String HomePagelink,
    required String CustomerFeatureListingURL,
    MediaInfo? CompanyLogo,
  }) = _TenancyVarificationDocumentState;

  factory TenancyVarificationDocumentState.initial() =>
      TenancyVarificationDocumentState(
        notapplicable_doc3: false,
        notapplicable_doc4: false,
        isbuttonActive: false,
        docs1_fileextension: "",
        docs1_filename: "",
        docs2_fileextension: "",
        docs2_filename: "",
        docs3_fileextension: "",
        docs3_filename: "",
        docs4_fileextension: "",
        docs4_filename: "",
        IsDocAvailable: false,
        propertyAddress: "",
        ApplicantID: "",
        docs1_file: null,
        docs2_file: null,
        docs3_file: null,
        docs4_file: null,
        MID_Doc1: "",
        MediaDoc1: null,
        MID_Doc2: "",
        MediaDoc2: null,
        MID_Doc3: "",
        MediaDoc3: null,
        MID_Doc4: "",
        MediaDoc4: null,
        CompanyName: "",
        HomePagelink: "",
        CustomerFeatureListingURL: "",
        CompanyLogo: null,
      );
}

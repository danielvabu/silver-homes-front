import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'landlord_profile_state.freezed.dart';

@freezed
abstract class LandlordProfileState with _$LandlordProfileState {
  const factory LandlordProfileState({
    required String id,
    required String companyname,
    required String homepagelink,
    required String CustomerFeatureListingURL,
    required String CustomerFeatureListingURL_update,
    required String PersonID,
    required String firstname,
    required String lastname,
    required String email,
    required String phonenumber,
    required String countrycode,
    required String dialcode,
    MediaInfo? companylogo,
    Uint8List? companyimage,
  }) = _LandlordProfileState;

  factory LandlordProfileState.initial() => LandlordProfileState(
        id: "",
        companyname: "",
        homepagelink: "",
        CustomerFeatureListingURL: "",
        CustomerFeatureListingURL_update: "",
        PersonID: "",
        firstname: "",
        lastname: "",
        email: "",
        phonenumber: "",
        countrycode: "CA",
        dialcode: "+1",
        companylogo: null,
        companyimage: null,
      );
}

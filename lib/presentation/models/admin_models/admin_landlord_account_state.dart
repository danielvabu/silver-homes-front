import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'admin_landlord_account_state.freezed.dart';

@freezed
abstract class AdminLandlordAccountState with _$AdminLandlordAccountState {
  const factory AdminLandlordAccountState({
    required int OwnerId,
    required String companyname,
    required String homepagelink,
    MediaInfo? companylogo,
    required String firstname,
    required String lastname,
    required String email,
    required String phoneno,
    required String dialcode,
    required String countrycode,
    required String CustomerFeatureListingURL,
    required String CustomerFeatureListingURL_update,
    required bool isloading,
  }) = _AdminLandlordAccountState;

  factory AdminLandlordAccountState.initial() => AdminLandlordAccountState(
        OwnerId: 0,
        companyname: "",
        homepagelink: "",
        companylogo: null,
        firstname: "",
        lastname: "",
        email: "",
        phoneno: "",
        dialcode: "+1",
        countrycode: "CA",
        CustomerFeatureListingURL: "",
        CustomerFeatureListingURL_update: "",
        isloading: true,
      );
}

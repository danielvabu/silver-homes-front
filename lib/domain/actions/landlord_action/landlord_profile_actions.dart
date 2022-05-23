import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateLandlordProfileID implements Action {
  final String id;

  UpdateLandlordProfileID(this.id);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(id: id);
  }
}

class UpdateLandlordProfileCompanyname implements Action {
  final String companyname;

  UpdateLandlordProfileCompanyname(this.companyname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(companyname: companyname);
  }
}

class UpdateLandlordProfileHomepagelink implements Action {
  final String homepagelink;

  UpdateLandlordProfileHomepagelink(this.homepagelink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(homepagelink: homepagelink);
  }
}

class UpdateLandlordProfileCustomerFeatureListingURL implements Action {
  final String CustomerFeatureListingURL;

  UpdateLandlordProfileCustomerFeatureListingURL(
      this.CustomerFeatureListingURL);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .profileState(CustomerFeatureListingURL: CustomerFeatureListingURL);
  }
}

class UpdateLandlordProfileCustomerFeatureListingURL_update implements Action {
  final String CustomerFeatureListingURL_update;

  UpdateLandlordProfileCustomerFeatureListingURL_update(
      this.CustomerFeatureListingURL_update);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(
        CustomerFeatureListingURL_update: CustomerFeatureListingURL_update);
  }
}

class UpdateLandlordProfileFirstname implements Action {
  final String firstname;

  UpdateLandlordProfileFirstname(this.firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(firstname: firstname);
  }
}

class UpdateLandlordProfileLastname implements Action {
  final String lastname;

  UpdateLandlordProfileLastname(this.lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(lastname: lastname);
  }
}

class UpdateLandlordProfileEmail implements Action {
  final String email;

  UpdateLandlordProfileEmail(this.email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(email: email);
  }
}

class UpdateLandlordProfilePhonenumber implements Action {
  final String phonenumber;

  UpdateLandlordProfilePhonenumber(this.phonenumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(phonenumber: phonenumber);
  }
}

class UpdateLandlordProfileCountrycode implements Action {
  final String countrycode;

  UpdateLandlordProfileCountrycode(this.countrycode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(countrycode: countrycode);
  }
}

class UpdateLandlordProfileDialcode implements Action {
  final String dialcode;

  UpdateLandlordProfileDialcode(this.dialcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(dialcode: dialcode);
  }
}

class UpdateLandlordProfileCompanylogo implements Action {
  final MediaInfo? companylogo;

  UpdateLandlordProfileCompanylogo(this.companylogo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(companylogo: companylogo);
  }
}

class UpdateLandlordProfileUint8List implements Action {
  final Uint8List? companyimage;

  UpdateLandlordProfileUint8List(this.companyimage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(companyimage: companyimage);
  }
}

class UpdateLandlordProfilePersonID implements Action {
  final String PersonID;

  UpdateLandlordProfilePersonID(this.PersonID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.profileState(PersonID: PersonID);
  }
}

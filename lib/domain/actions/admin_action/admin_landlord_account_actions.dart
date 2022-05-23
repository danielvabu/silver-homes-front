import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateLandlordAccount_isloading implements Action {
  final bool isloading;

  UpdateLandlordAccount_isloading(this.isloading);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(isloading: isloading);
  }
}

class UpdateLandlordAccount_OwnerId implements Action {
  final int OwnerId;

  UpdateLandlordAccount_OwnerId(this.OwnerId);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(OwnerId: OwnerId);
  }
}

class UpdateLandlordAccount_Companylogo implements Action {
  final MediaInfo? companylogo;

  UpdateLandlordAccount_Companylogo(this.companylogo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordAccountState(companylogo: companylogo);
  }
}

class UpdateLandlordAccount_CustomerFeatureListingURL implements Action {
  final String CustomerFeatureListingURL;

  UpdateLandlordAccount_CustomerFeatureListingURL(
      this.CustomerFeatureListingURL);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(
        CustomerFeatureListingURL: CustomerFeatureListingURL);
  }
}

class UpdateLandlordAccount_CustomerFeatureListingURL_Update implements Action {
  final String CustomerFeatureListingURL_update;

  UpdateLandlordAccount_CustomerFeatureListingURL_Update(
      this.CustomerFeatureListingURL_update);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(
        CustomerFeatureListingURL_update: CustomerFeatureListingURL_update);
  }
}

class UpdateLandlordAccount_Companyname implements Action {
  final String companyname;

  UpdateLandlordAccount_Companyname(this.companyname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordAccountState(companyname: companyname);
  }
}

class UpdateLandlordAccount_Homepagelink implements Action {
  final String homepagelink;

  UpdateLandlordAccount_Homepagelink(this.homepagelink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordAccountState(homepagelink: homepagelink);
  }
}

class UpdateLandlordAccount_firstname implements Action {
  final String firstname;

  UpdateLandlordAccount_firstname(this.firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(firstname: firstname);
  }
}

class UpdateLandlordAccount_lastname implements Action {
  final String lastname;

  UpdateLandlordAccount_lastname(this.lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(lastname: lastname);
  }
}

class UpdateLandlordAccount_email implements Action {
  final String email;

  UpdateLandlordAccount_email(this.email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(email: email);
  }
}

class UpdateLandlordAccount_phoneno implements Action {
  final String phoneno;

  UpdateLandlordAccount_phoneno(this.phoneno);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(phoneno: phoneno);
  }
}

class UpdateLandlordAccount_dialcode implements Action {
  final String dialcode;

  UpdateLandlordAccount_dialcode(this.dialcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordAccountState(dialcode: dialcode);
  }
}

class UpdateLandlordAccount_countrycode implements Action {
  final String countrycode;

  UpdateLandlordAccount_countrycode(this.countrycode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordAccountState(countrycode: countrycode);
  }
}

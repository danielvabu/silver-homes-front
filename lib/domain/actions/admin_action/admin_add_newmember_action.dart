import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminTM_AM_OwnerId implements Action {
  final String OwnerId;

  UpdateAdminTM_AM_OwnerId(this.OwnerId);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(OwnerId: OwnerId);
  }
}

class UpdateAdminTM_AM_Persionid implements Action {
  final String Persionid;

  UpdateAdminTM_AM_Persionid(this.Persionid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(Persionid: Persionid);
  }
}

class UpdateAdminTM_AM_firstname implements Action {
  final String firstname;

  UpdateAdminTM_AM_firstname(this.firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(firstname: firstname);
  }
}

class UpdateAdminTM_AM_lastname implements Action {
  final String lastname;

  UpdateAdminTM_AM_lastname(this.lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(lastname: lastname);
  }
}

class UpdateAdminTM_AM_email implements Action {
  final String email;

  UpdateAdminTM_AM_email(this.email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(email: email);
  }
}

class UpdateAdminTM_AM_phone implements Action {
  final String phone;

  UpdateAdminTM_AM_phone(this.phone);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(phone: phone);
  }
}

class UpdateAdminTM_AM_dialcode implements Action {
  final String dialcode;

  UpdateAdminTM_AM_dialcode(this.dialcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(dialcode: dialcode);
  }
}

class UpdateAdminTM_AM_countrycode implements Action {
  final String countrycode;

  UpdateAdminTM_AM_countrycode(this.countrycode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(countrycode: countrycode);
  }
}

class UpdateAdminTM_AM_error_firstname implements Action {
  final bool error_firstname;

  UpdateAdminTM_AM_error_firstname(this.error_firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminAddNewMemberState(error_firstname: error_firstname);
  }
}

class UpdateAdminTM_AM_error_lastname implements Action {
  final bool error_lastname;

  UpdateAdminTM_AM_error_lastname(this.error_lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminAddNewMemberState(error_lastname: error_lastname);
  }
}

class UpdateAdminTM_AM_error_email implements Action {
  final bool error_email;

  UpdateAdminTM_AM_error_email(this.error_email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(error_email: error_email);
  }
}

class UpdateAdminTM_AM_error_Message implements Action {
  final String error_message;

  UpdateAdminTM_AM_error_Message(this.error_message);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminAddNewMemberState(error_message: error_message);
  }
}

class UpdateAdminTM_AM_error_phone implements Action {
  final bool error_phone;

  UpdateAdminTM_AM_error_phone(this.error_phone);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminAddNewMemberState(error_phone: error_phone);
  }
}

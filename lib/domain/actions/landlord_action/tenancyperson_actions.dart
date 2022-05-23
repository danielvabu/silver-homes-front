import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateTFPersonFirstname implements Action {
  final String Firstname;

  UpdateTFPersonFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(perFirstname: Firstname);
  }
}

class UpdateTFPersonLastname implements Action {
  final String Lastname;

  UpdateTFPersonLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(perLastname: Lastname);
  }
}

class UpdateTFPersonDateofBirth implements Action {
  final DateTime? dateofbirth;

  UpdateTFPersonDateofBirth(this.dateofbirth);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(dateofbirth: dateofbirth);
  }
}

class UpdateTFPersonEmail implements Action {
  final String Email;

  UpdateTFPersonEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(perEmail: Email);
  }
}

class UpdateTFPersonPhoneNumber implements Action {
  final String PhoneNumber;

  UpdateTFPersonPhoneNumber(this.PhoneNumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(perPhoneNumber: PhoneNumber);
  }
}

class UpdateTFPersonCountryCode implements Action {
  final String CountryCode;

  UpdateTFPersonCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(perCountryCode: CountryCode);
  }
}

class UpdateTFPersonDialCode implements Action {
  final String DialCode;

  UpdateTFPersonDialCode(this.DialCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(perDialCode: DialCode);
  }
}

class UpdateTFPersonStory implements Action {
  final String Story;

  UpdateTFPersonStory(this.Story);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(perStory: Story);
  }
}

class UpdateTFPersonIsUpdate implements Action {
  final bool isUpdate;

  UpdateTFPersonIsUpdate(this.isUpdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(isUpdate: isUpdate);
  }
}

class UpdateTFPersonPersonID implements Action {
  final String PersonID;

  UpdateTFPersonPersonID(this.PersonID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(Person_ID: PersonID);
  }
}

class UpdateTFPersonError_perFirstname implements Action {
  final bool error_perFirstname;

  UpdateTFPersonError_perFirstname(this.error_perFirstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfPersonalState(error_perFirstname: error_perFirstname);
  }
}

class UpdateTFPersonError_perLastname implements Action {
  final bool error_perLastname;

  UpdateTFPersonError_perLastname(this.error_perLastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfPersonalState(error_perLastname: error_perLastname);
  }
}

class UpdateTFPersonError_dateofbirth implements Action {
  final bool error_dateofbirth;

  UpdateTFPersonError_dateofbirth(this.error_dateofbirth);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfPersonalState(error_dateofbirth: error_dateofbirth);
  }
}

class UpdateTFPersonError_perEmail implements Action {
  final bool error_perEmail;

  UpdateTFPersonError_perEmail(this.error_perEmail);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(error_perEmail: error_perEmail);
  }
}

class UpdateTFPersonError_perPhoneNumber implements Action {
  final bool error_perPhoneNumber;

  UpdateTFPersonError_perPhoneNumber(this.error_perPhoneNumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfPersonalState(error_perPhoneNumber: error_perPhoneNumber);
  }
}

class FNLUpdateTFPersonFirstname implements Action {
  final String Firstname;

  FNLUpdateTFPersonFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLperFirstname: Firstname);
  }
}

class FNLUpdateTFPersonLastname implements Action {
  final String Lastname;

  FNLUpdateTFPersonLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLperLastname: Lastname);
  }
}

class FNLUpdateTFPersonDateofBirth implements Action {
  final DateTime? dateofbirth;

  FNLUpdateTFPersonDateofBirth(this.dateofbirth);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLdateofbirth: dateofbirth);
  }
}

class FNLUpdateTFPersonEmail implements Action {
  final String Email;

  FNLUpdateTFPersonEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLperEmail: Email);
  }
}

class FNLUpdateTFPersonPhoneNumber implements Action {
  final String PhoneNumber;

  FNLUpdateTFPersonPhoneNumber(this.PhoneNumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLperPhoneNumber: PhoneNumber);
  }
}

class FNLUpdateTFPersonCountryCode implements Action {
  final String CountryCode;

  FNLUpdateTFPersonCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLperCountryCode: CountryCode);
  }
}

class FNLUpdateTFPersonDialCode implements Action {
  final String DialCode;

  FNLUpdateTFPersonDialCode(this.DialCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLperDialCode: DialCode);
  }
}

class FNLUpdateTFPersonStory implements Action {
  final String Story;

  FNLUpdateTFPersonStory(this.Story);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfPersonalState(FNLperStory: Story);
  }
}

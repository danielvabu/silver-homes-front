import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateTFCurrenttenantStartDate implements Action {
  final DateTime? StartDate;

  UpdateTFCurrenttenantStartDate(this.StartDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(ct_startdate: StartDate);
  }
}

class UpdateTFCurrenttenantEndDate implements Action {
  final DateTime? EndDate;

  UpdateTFCurrenttenantEndDate(this.EndDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(ct_enddate: EndDate);
  }
}

class UpdateTFCurrenttenantSuiteUnit implements Action {
  final String SuiteUnit;

  UpdateTFCurrenttenantSuiteUnit(this.SuiteUnit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(suiteunit: SuiteUnit);
  }
}

class UpdateTFCurrenttenantAddress implements Action {
  final String Address;

  UpdateTFCurrenttenantAddress(this.Address);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(ct_address: Address);
  }
}

class UpdateTFCurrenttenantCity implements Action {
  final String City;

  UpdateTFCurrenttenantCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(ct_city: City);
  }
}

class UpdateTFCurrenttenantProvince implements Action {
  final String Province;

  UpdateTFCurrenttenantProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(ct_province: Province);
  }
}

class UpdateTFCurrenttenantPostalcode implements Action {
  final String Postalcode;

  UpdateTFCurrenttenantPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(ct_postalcode: Postalcode);
  }
}

class UpdateTFCurrenttenantFirstname implements Action {
  final String Firstname;

  UpdateTFCurrenttenantFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(cl_firstname: Firstname);
  }
}

class UpdateTFCurrenttenantLastname implements Action {
  final String Lastname;

  UpdateTFCurrenttenantLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(cl_lastname: Lastname);
  }
}

class UpdateTFCurrenttenantEmail implements Action {
  final String Email;

  UpdateTFCurrenttenantEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(cl_email: Email);
  }
}

class UpdateTFCurrenttenantPhonenumber implements Action {
  final String Phonenumber;

  UpdateTFCurrenttenantPhonenumber(this.Phonenumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(cl_phonenumber: Phonenumber);
  }
}

class UpdateTFCurrenttenantCode implements Action {
  final String Code;

  UpdateTFCurrenttenantCode(this.Code);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(cl_code: Code);
  }
}

class UpdateTFCurrenttenantDailCode implements Action {
  final String DailCode;

  UpdateTFCurrenttenantDailCode(this.DailCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(cl_dailcode: DailCode);
  }
}

class UpdateTFCurrenttenantisReference implements Action {
  final bool isReference;

  UpdateTFCurrenttenantisReference(this.isReference);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(cl_isReference: isReference);
  }
}

class UpdateTFCurrenttenantIsUpdate implements Action {
  final bool IsUpdate;

  UpdateTFCurrenttenantIsUpdate(this.IsUpdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(isUpdate: IsUpdate);
  }
}

class UpdateTFCurrenttenantCurrentTenancyID implements Action {
  final String CurrentTenancyID;

  UpdateTFCurrenttenantCurrentTenancyID(this.CurrentTenancyID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(CurrentTenancyID: CurrentTenancyID);
  }
}

class UpdateTFCurrenttenantCurrentLandLordID implements Action {
  final String CurrentLandLordID;

  UpdateTFCurrenttenantCurrentLandLordID(this.CurrentLandLordID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(CurrentLandLordID: CurrentLandLordID);
  }
}

class UpdateTFCurrenttenantError_startdate implements Action {
  final bool error_startdate;

  UpdateTFCurrenttenantError_startdate(this.error_startdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_startdate: error_startdate);
  }
}

class UpdateTFCurrenttenantError_enddate implements Action {
  final bool error_enddate;

  UpdateTFCurrenttenantError_enddate(this.error_enddate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_enddate: error_enddate);
  }
}

class UpdateTFCurrenttenantError_address implements Action {
  final bool error_address;

  UpdateTFCurrenttenantError_address(this.error_address);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_address: error_address);
  }
}

class UpdateTFCurrenttenantError_city implements Action {
  final bool error_city;

  UpdateTFCurrenttenantError_city(this.error_city);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(error_city: error_city);
  }
}

class UpdateTFCurrenttenantError_province implements Action {
  final bool error_province;

  UpdateTFCurrenttenantError_province(this.error_province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_province: error_province);
  }
}

class UpdateTFCurrenttenantError_postalcode implements Action {
  final bool error_postalcode;

  UpdateTFCurrenttenantError_postalcode(this.error_postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_postalcode: error_postalcode);
  }
}

class UpdateTFCurrenttenantError_firstname implements Action {
  final bool error_firstname;

  UpdateTFCurrenttenantError_firstname(this.error_firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_firstname: error_firstname);
  }
}

class UpdateTFCurrenttenantError_lastname implements Action {
  final bool error_lastname;

  UpdateTFCurrenttenantError_lastname(this.error_lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_lastname: error_lastname);
  }
}

class UpdateTFCurrenttenantError_email implements Action {
  final bool error_email;

  UpdateTFCurrenttenantError_email(this.error_email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(error_email: error_email);
  }
}

class UpdateTFCurrenttenantError_phonenumber implements Action {
  final bool error_phonenumber;

  UpdateTFCurrenttenantError_phonenumber(this.error_phonenumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(error_phonenumber: error_phonenumber);
  }
}

class FNLUpdateTFCurrenttenantStartDate implements Action {
  final DateTime? StartDate;

  FNLUpdateTFCurrenttenantStartDate(this.StartDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLct_startdate: StartDate);
  }
}

class FNLUpdateTFCurrenttenantEndDate implements Action {
  final DateTime? EndDate;

  FNLUpdateTFCurrenttenantEndDate(this.EndDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLct_enddate: EndDate);
  }
}

class FNLUpdateTFCurrenttenantSuiteUnit implements Action {
  final String SuiteUnit;

  FNLUpdateTFCurrenttenantSuiteUnit(this.SuiteUnit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLsuiteunit: SuiteUnit);
  }
}

class FNLUpdateTFCurrenttenantAddress implements Action {
  final String Address;

  FNLUpdateTFCurrenttenantAddress(this.Address);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLct_address: Address);
  }
}

class FNLUpdateTFCurrenttenantCity implements Action {
  final String City;

  FNLUpdateTFCurrenttenantCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLct_city: City);
  }
}

class FNLUpdateTFCurrenttenantProvince implements Action {
  final String Province;

  FNLUpdateTFCurrenttenantProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLct_province: Province);
  }
}

class FNLUpdateTFCurrenttenantPostalcode implements Action {
  final String Postalcode;

  FNLUpdateTFCurrenttenantPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(FNLct_postalcode: Postalcode);
  }
}

class FNLUpdateTFCurrenttenantFirstname implements Action {
  final String Firstname;

  FNLUpdateTFCurrenttenantFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLcl_firstname: Firstname);
  }
}

class FNLUpdateTFCurrenttenantLastname implements Action {
  final String Lastname;

  FNLUpdateTFCurrenttenantLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLcl_lastname: Lastname);
  }
}

class FNLUpdateTFCurrenttenantEmail implements Action {
  final String Email;

  FNLUpdateTFCurrenttenantEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLcl_email: Email);
  }
}

class FNLUpdateTFCurrenttenantPhonenumber implements Action {
  final String Phonenumber;

  FNLUpdateTFCurrenttenantPhonenumber(this.Phonenumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(FNLcl_phonenumber: Phonenumber);
  }
}

class FNLUpdateTFCurrenttenantCode implements Action {
  final String Code;

  FNLUpdateTFCurrenttenantCode(this.Code);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLcl_code: Code);
  }
}

class FNLUpdateTFCurrenttenantDailCode implements Action {
  final String DailCode;

  FNLUpdateTFCurrenttenantDailCode(this.DailCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfCurrentTenancyState(FNLcl_dailcode: DailCode);
  }
}

class FNLUpdateTFCurrenttenantisReference implements Action {
  final bool isReference;

  FNLUpdateTFCurrenttenantisReference(this.isReference);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfCurrentTenancyState(FNLcl_isReference: isReference);
  }
}

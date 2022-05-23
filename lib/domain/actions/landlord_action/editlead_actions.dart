import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateEditLeadProperty implements Action {
  final PropertyData? property;

  UpdateEditLeadProperty(this.property);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(propertyValue: property);
  }
}

class UpdateEditLeadPropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateEditLeadPropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(propertylist: propertylist);
  }
}

class UpdateEditLeadApplicantionId implements Action {
  final String? applicationid;

  UpdateEditLeadApplicantionId(this.applicationid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(applicationid: applicationid);
  }
}

class UpdateEditLeadApplicantid implements Action {
  final String? applicantid;

  UpdateEditLeadApplicantid(this.applicantid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(applicantid: applicantid);
  }
}

class UpdateEditLeadPersionId implements Action {
  final String? persionid;

  UpdateEditLeadPersionId(this.persionid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(PersionId: persionid);
  }
}

class UpdateEditLeadFirstname implements Action {
  final String? firstname;

  UpdateEditLeadFirstname(this.firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(firstname: firstname);
  }
}

class UpdateEditLeadLastname implements Action {
  final String? lastname;

  UpdateEditLeadLastname(this.lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(lastname: lastname);
  }
}

class UpdateEditLeadEmail implements Action {
  final String? email;

  UpdateEditLeadEmail(this.email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(Email: email);
  }
}

class UpdateEditLead_Occupant implements Action {
  final String? Lead_occupant;

  UpdateEditLead_Occupant(this.Lead_occupant);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(Lead_occupant: Lead_occupant);
  }
}

class UpdateEditLead_Children implements Action {
  final String? Lead_children;

  UpdateEditLead_Children(this.Lead_children);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(Lead_children: Lead_children);
  }
}

class UpdateEditLeadPhoneNumber implements Action {
  final String? phoneNumber;

  UpdateEditLeadPhoneNumber(this.phoneNumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(phoneNumber: phoneNumber);
  }
}

class UpdateEditLeadCountryCode implements Action {
  final String? CountryCode;

  UpdateEditLeadCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(CountryCode: CountryCode);
  }
}

class UpdateEditLeadCountryDialCode implements Action {
  final String? CountrydialCode;

  UpdateEditLeadCountryDialCode(this.CountrydialCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(CountrydialCode: CountrydialCode);
  }
}

class UpdateEditLeadNotes implements Action {
  final String? PrivateNotes;

  UpdateEditLeadNotes(this.PrivateNotes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editLeadState(PrivateNotes: PrivateNotes);
  }
}

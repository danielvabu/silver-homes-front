import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTFEmploymentothersourceincome implements Action {
  final String othersourceincome;

  UpdateTFEmploymentothersourceincome(this.othersourceincome);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(othersourceincome: othersourceincome);
  }
}

class UpdateTFEmploymentlinkedprofile implements Action {
  final String linkedprofile;

  UpdateTFEmploymentlinkedprofile(this.linkedprofile);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(linkedprofile: linkedprofile);
  }
}

class UpdateTFEmploymentanualincomestatuslist implements Action {
  final List<SystemEnumDetails> annualincomestatuslist;

  UpdateTFEmploymentanualincomestatuslist(this.annualincomestatuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(anualincomelist: annualincomestatuslist);
  }
}

class UpdateTFEmploymentanualincomestatus implements Action {
  final SystemEnumDetails? annualincomevalue;

  UpdateTFEmploymentanualincomestatus(this.annualincomevalue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(anualincomestatus: annualincomevalue);
  }
}

class UpdateTFEmploymentlistoccupation implements Action {
  final List<TenancyEmploymentInformation> listoccupation1;

  UpdateTFEmploymentlistoccupation(this.listoccupation1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(listoccupation: listoccupation1);
  }
}

class UpdateTFEmploymentempstatuslist implements Action {
  final List<SystemEnumDetails> empstatuslist;

  UpdateTFEmploymentempstatuslist(this.empstatuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(empstatuslist: empstatuslist);
  }
}

class UpdateTFEmploymentempstatus implements Action {
  final SystemEnumDetails? empstatus;

  UpdateTFEmploymentempstatus(this.empstatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(empstatus: empstatus);
  }
}

class UpdateTFEmploymentIsUpdate implements Action {
  final bool isUpdate;

  UpdateTFEmploymentIsUpdate(this.isUpdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(isUpdate: isUpdate);
  }
}

class UpdateTFEmploymentEmploymentID implements Action {
  final String EmploymentID;

  UpdateTFEmploymentEmploymentID(this.EmploymentID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(EmploymentID: EmploymentID);
  }
}

class UpdateTFEmploymentError_linkedprofile implements Action {
  final bool error_linkedprofile;

  UpdateTFEmploymentError_linkedprofile(this.error_linkedprofile);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(error_linkedprofile: error_linkedprofile);
  }
}

class UpdateTFEmploymentError_empstatus implements Action {
  final bool error_empstatus;

  UpdateTFEmploymentError_empstatus(this.error_empstatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(error_empstatus: error_empstatus);
  }
}

class UpdateTFEmploymentError_anualincomestatus implements Action {
  final bool error_anualincomestatus;

  UpdateTFEmploymentError_anualincomestatus(this.error_anualincomestatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(error_anualincomestatus: error_anualincomestatus);
  }
}

class FNLUpdateTFEmploymentothersourceincome implements Action {
  final String othersourceincome;

  FNLUpdateTFEmploymentothersourceincome(this.othersourceincome);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(FNLothersourceincome: othersourceincome);
  }
}

class FNLUpdateTFEmploymentlinkedprofile implements Action {
  final String linkedprofile;

  FNLUpdateTFEmploymentlinkedprofile(this.linkedprofile);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(FNLlinkedprofile: linkedprofile);
  }
}

class FNLUpdateTFEmploymentanualincomestatuslist implements Action {
  final List<SystemEnumDetails> annualincomestatuslist;

  FNLUpdateTFEmploymentanualincomestatuslist(this.annualincomestatuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(FNLanualincomelist: annualincomestatuslist);
  }
}

class FNLUpdateTFEmploymentanualincomestatus implements Action {
  final SystemEnumDetails? annualincomevalue;

  FNLUpdateTFEmploymentanualincomestatus(this.annualincomevalue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(FNLanualincomestatus: annualincomevalue);
  }
}

class FNLUpdateTFEmploymentlistoccupation implements Action {
  final List<TenancyEmploymentInformation> listoccupation1;

  FNLUpdateTFEmploymentlistoccupation(this.listoccupation1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfEmploymentState(FNLlistoccupation: listoccupation1);
  }
}

class FNLUpdateTFEmploymentempstatuslist implements Action {
  final List<SystemEnumDetails> empstatuslist;

  FNLUpdateTFEmploymentempstatuslist(this.empstatuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(FNLempstatuslist: empstatuslist);
  }
}

class FNLUpdateTFEmploymentempstatus implements Action {
  final SystemEnumDetails? empstatus;

  FNLUpdateTFEmploymentempstatus(this.empstatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfEmploymentState(FNLempstatus: empstatus);
  }
}

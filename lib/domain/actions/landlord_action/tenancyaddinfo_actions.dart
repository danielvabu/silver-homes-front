import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTFAdditionalInfoPetslist implements Action {
  final List<Pets> petslist1;

  UpdateTFAdditionalInfoPetslist(this.petslist1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(petslist: petslist1);
  }
}

class UpdateTFAdditionalInfoIspets implements Action {
  final bool ispet;

  UpdateTFAdditionalInfoIspets(this.ispet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(isPets: ispet);
  }
}

class UpdateTFAdditionalInfoVehicallist implements Action {
  final List<Vehical> vehicallist;

  UpdateTFAdditionalInfoVehicallist(this.vehicallist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(vehicallist: vehicallist);
  }
}

class UpdateTFAdditionalInfoisVehical implements Action {
  final bool isVehical;

  UpdateTFAdditionalInfoisVehical(this.isVehical);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(isVehical: isVehical);
  }
}

class UpdateTFAdditionalInfoisSmoking implements Action {
  final bool isSmoking;

  UpdateTFAdditionalInfoisSmoking(this.isSmoking);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(isSmoking: isSmoking);
  }
}

class UpdateTFAdditionalInfoComment implements Action {
  final String Comment;

  UpdateTFAdditionalInfoComment(this.Comment);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(Comment: Comment);
  }
}

class UpdateTFAdditionalInfoTenancyStartDate implements Action {
  final DateTime? tenancystartdate;

  UpdateTFAdditionalInfoTenancyStartDate(this.tenancystartdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(tenancystartdate: tenancystartdate);
  }
}

class UpdateTFAdditionalInfoLenthOfTenancy implements Action {
  final SystemEnumDetails? lenthoftenancy;

  UpdateTFAdditionalInfoLenthOfTenancy(this.lenthoftenancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(lenthoftenancy: lenthoftenancy);
  }
}

class UpdateTFAdditionalInfoLenthOfTenancyList implements Action {
  final List<SystemEnumDetails> lenthoftenancylist;

  UpdateTFAdditionalInfoLenthOfTenancyList(this.lenthoftenancylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(lenthoftenancylist: lenthoftenancylist);
  }
}

class UpdateTFAdditionalInfoPeriodlist implements Action {
  final List<SystemEnumDetails> Periodlist;

  UpdateTFAdditionalInfoPeriodlist(this.Periodlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(Periodlist: Periodlist);
  }
}

class UpdateTFAdditionalInfoPeriodValue implements Action {
  final SystemEnumDetails? PeriodValue;

  UpdateTFAdditionalInfoPeriodValue(this.PeriodValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(PeriodValue: PeriodValue);
  }
}

class UpdateTFAdditionalInfolenthoftenancynumber implements Action {
  final String lenthoftenancynumber;

  UpdateTFAdditionalInfolenthoftenancynumber(this.lenthoftenancynumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(lenthoftenancynumber: lenthoftenancynumber);
  }
}

class UpdateTFAdditionalInfoIsUpdate implements Action {
  final bool isupdate;

  UpdateTFAdditionalInfoIsUpdate(this.isupdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(isUpdate: isupdate);
  }
}

class UpdateTFAdditionalInfoError_tenancystartdate implements Action {
  final bool error_tenancystartdate;

  UpdateTFAdditionalInfoError_tenancystartdate(this.error_tenancystartdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(error_tenancystartdate: error_tenancystartdate);
  }
}

class UpdateTFAdditionalInfoError_PeriodValue implements Action {
  final bool error_PeriodValue;

  UpdateTFAdditionalInfoError_PeriodValue(this.error_PeriodValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(error_PeriodValue: error_PeriodValue);
  }
}

class UpdateTFAdditionalInfoError_lenthoftenancynumber implements Action {
  final bool error_lenthoftenancynumber;

  UpdateTFAdditionalInfoError_lenthoftenancynumber(
      this.error_lenthoftenancynumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(
        error_lenthoftenancynumber: error_lenthoftenancynumber);
  }
}

class FNLUpdateTFAdditionalInfoPetslist implements Action {
  final List<Pets> petslist1;

  FNLUpdateTFAdditionalInfoPetslist(this.petslist1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLpetslist: petslist1);
  }
}

class FNLUpdateTFAdditionalInfoIspets implements Action {
  final bool ispet;

  FNLUpdateTFAdditionalInfoIspets(this.ispet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLisPets: ispet);
  }
}

class FNLUpdateTFAdditionalInfoVehicallist implements Action {
  final List<Vehical> vehicallist;

  FNLUpdateTFAdditionalInfoVehicallist(this.vehicallist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLvehicallist: vehicallist);
  }
}

class FNLUpdateTFAdditionalInfoisVehical implements Action {
  final bool isVehical;

  FNLUpdateTFAdditionalInfoisVehical(this.isVehical);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLisVehical: isVehical);
  }
}

class FNLUpdateTFAdditionalInfoisSmoking implements Action {
  final bool isSmoking;

  FNLUpdateTFAdditionalInfoisSmoking(this.isSmoking);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLisSmoking: isSmoking);
  }
}

class FNLUpdateTFAdditionalInfoComment implements Action {
  final String Comment;

  FNLUpdateTFAdditionalInfoComment(this.Comment);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLComment: Comment);
  }
}

class FNLUpdateTFAdditionalInfoTenancyStartDate implements Action {
  final DateTime? tenancystartdate;

  FNLUpdateTFAdditionalInfoTenancyStartDate(this.tenancystartdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(FNLtenancystartdate: tenancystartdate);
  }
}

class FNLUpdateTFAdditionalInfoLenthOfTenancy implements Action {
  final SystemEnumDetails? lenthoftenancy;

  FNLUpdateTFAdditionalInfoLenthOfTenancy(this.lenthoftenancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(FNLlenthoftenancy: lenthoftenancy);
  }
}

class FNLUpdateTFAdditionalInfoLenthOfTenancyList implements Action {
  final List<SystemEnumDetails> lenthoftenancylist;

  FNLUpdateTFAdditionalInfoLenthOfTenancyList(this.lenthoftenancylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(FNLlenthoftenancylist: lenthoftenancylist);
  }
}

class FNLUpdateTFAdditionalInfoPeriodlist implements Action {
  final List<SystemEnumDetails> Periodlist;

  FNLUpdateTFAdditionalInfoPeriodlist(this.Periodlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLPeriodlist: Periodlist);
  }
}

class FNLUpdateTFAdditionalInfoPeriodValue implements Action {
  final SystemEnumDetails? PeriodValue;

  FNLUpdateTFAdditionalInfoPeriodValue(this.PeriodValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalInfoState(FNLPeriodValue: PeriodValue);
  }
}

class FNLUpdateTFAdditionalInfolenthoftenancynumber implements Action {
  final String lenthoftenancynumber;

  FNLUpdateTFAdditionalInfolenthoftenancynumber(this.lenthoftenancynumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalInfoState(FNLlenthoftenancynumber: lenthoftenancynumber);
  }
}

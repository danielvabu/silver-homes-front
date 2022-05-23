import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminTeam_isIDSort implements Action {
  final bool isIDSort;

  UpdateAdminTeam_isIDSort(this.isIDSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(isIDSort: isIDSort);
  }
}

class UpdateAdminTeam_isNameSort implements Action {
  final bool isNameSort;

  UpdateAdminTeam_isNameSort(this.isNameSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(isNameSort: isNameSort);
  }
}

class UpdateAdminTeam_isEmailSort implements Action {
  final bool isEmailSort;

  UpdateAdminTeam_isEmailSort(this.isEmailSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(isEmailSort: isEmailSort);
  }
}

class UpdateAdminTeam_isPhoneSort implements Action {
  final bool isPhoneSort;

  UpdateAdminTeam_isPhoneSort(this.isPhoneSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(isPhoneSort: isPhoneSort);
  }
}

class UpdateAdminTeam_isActiveSort implements Action {
  final bool isActiveSort;

  UpdateAdminTeam_isActiveSort(this.isActiveSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(isActiveSort: isActiveSort);
  }
}

class UpdateAdminTeam_datalist implements Action {
  final List<LandLordData> teamdatalist;

  UpdateAdminTeam_datalist(this.teamdatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(teamdatalist: teamdatalist);
  }
}

class UpdateAdminTeam_isloding implements Action {
  final bool isloding;

  UpdateAdminTeam_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(isloding: isloding);
  }
}

class UpdateAdminTeam_pageNo implements Action {
  final int pageNo;

  UpdateAdminTeam_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(pageNo: pageNo);
  }
}

class UpdateAdminTeam_totalpage implements Action {
  final int totalpage;

  UpdateAdminTeam_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(totalpage: totalpage);
  }
}

class UpdateAdminTeam_totalRecord implements Action {
  final int totalRecord;

  UpdateAdminTeam_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(totalRecord: totalRecord);
  }
}

class UpdateAdminTeam_IDSortAcsDes implements Action {
  final int IDSortAcsDes;

  UpdateAdminTeam_IDSortAcsDes(this.IDSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(IDSortAcsDes: IDSortAcsDes);
  }
}

class UpdateAdminTeam_NameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateAdminTeam_NameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(NameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateAdminTeam_EmailSortAcsDes implements Action {
  final int EmailSortAcsDes;

  UpdateAdminTeam_EmailSortAcsDes(this.EmailSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(EmailSortAcsDes: EmailSortAcsDes);
  }
}

class UpdateAdminTeam_PhoneSortAcsDes implements Action {
  final int PhoneSortAcsDes;

  UpdateAdminTeam_PhoneSortAcsDes(this.PhoneSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(PhoneSortAcsDes: PhoneSortAcsDes);
  }
}

class UpdateAdminTeam_ActiveSortAcsDes implements Action {
  final int ActiveSortAcsDes;

  UpdateAdminTeam_ActiveSortAcsDes(this.ActiveSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminTeamState(ActiveSortAcsDes: ActiveSortAcsDes);
  }
}

class UpdateAdminTeam_SearchText implements Action {
  final String AdminTeamSearchText;

  UpdateAdminTeam_SearchText(this.AdminTeamSearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminTeamState(AdminTeamSearchText: AdminTeamSearchText);
  }
}

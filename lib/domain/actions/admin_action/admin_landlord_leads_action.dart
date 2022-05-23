import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/leadtenantdata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminLL_isLeadIDSort implements Action {
  final bool isLeadIDSort;

  UpdateAdminLL_isLeadIDSort(this.isLeadIDSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(isLeadIDSort: isLeadIDSort);
  }
}

class UpdateAdminLL_isLeadApplicantSort implements Action {
  final bool isLeadApplicantSort;

  UpdateAdminLL_isLeadApplicantSort(this.isLeadApplicantSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(isLeadApplicantSort: isLeadApplicantSort);
  }
}

class UpdateAdminLL_isLeadEmailSort implements Action {
  final bool isLeadEmailSort;

  UpdateAdminLL_isLeadEmailSort(this.isLeadEmailSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(isLeadEmailSort: isLeadEmailSort);
  }
}

class UpdateAdminLL_isLeadPhoneNoSort implements Action {
  final bool isLeadPhoneNoSort;

  UpdateAdminLL_isLeadPhoneNoSort(this.isLeadPhoneNoSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(isLeadPhoneNoSort: isLeadPhoneNoSort);
  }
}

class UpdateAdminLL_isLeadRatingSort implements Action {
  final bool isLeadRatingSort;

  UpdateAdminLL_isLeadRatingSort(this.isLeadRatingSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(isLeadRatingSort: isLeadRatingSort);
  }
}

class UpdateAdminLL_isLeadStatusSort implements Action {
  final bool isLeadStatusSort;

  UpdateAdminLL_isLeadStatusSort(this.isLeadStatusSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(isLeadStatusSort: isLeadStatusSort);
  }
}

class UpdateAdminLL_isLeadLLnameSort implements Action {
  final bool isLeadLLnameSort;

  UpdateAdminLL_isLeadLLnameSort(this.isLeadLLnameSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(isLeadLLnameSort: isLeadLLnameSort);
  }
}

class UpdateAdminLL_isLeadPropertyNameSort implements Action {
  final bool isLeadPropertyNameSort;

  UpdateAdminLL_isLeadPropertyNameSort(this.isLeadPropertyNameSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsState(
        isLeadPropertyNameSort: isLeadPropertyNameSort);
  }
}

class UpdateAdminLL_leadstenantDatalist implements Action {
  final List<LeadTenantData> leadstenantDatalist;

  UpdateAdminLL_leadstenantDatalist(this.leadstenantDatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(leadstenantDatalist: leadstenantDatalist);
  }
}

class UpdateAdminLL_Leads_isloding implements Action {
  final bool isloding;

  UpdateAdminLL_Leads_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsState(isloding: isloding);
  }
}

class UpdateAdminLL_Leads_pageNo implements Action {
  final int pageNo;

  UpdateAdminLL_Leads_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsState(pageNo: pageNo);
  }
}

class UpdateAdminLL_Leads_totalpage implements Action {
  final int totalpage;

  UpdateAdminLL_Leads_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsState(totalpage: totalpage);
  }
}

class UpdateAdminLL_Leads_totalRecord implements Action {
  final int totalRecord;

  UpdateAdminLL_Leads_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsState(totalRecord: totalRecord);
  }
}

class UpdateAdminLL_LeadIDSortAcsDes implements Action {
  final int LeadIDSortAcsDes;

  UpdateAdminLL_LeadIDSortAcsDes(this.LeadIDSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(LeadIDSortAcsDes: LeadIDSortAcsDes);
  }
}

class UpdateAdminLL_LeadApplicantSortAcsDes implements Action {
  final int LeadApplicantSortAcsDes;

  UpdateAdminLL_LeadApplicantSortAcsDes(this.LeadApplicantSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsState(
        LeadApplicantSortAcsDes: LeadApplicantSortAcsDes);
  }
}

class UpdateAdminLL_LeadEmailSortAcsDes implements Action {
  final int LeadEmailSortAcsDes;

  UpdateAdminLL_LeadEmailSortAcsDes(this.LeadEmailSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(LeadEmailSortAcsDes: LeadEmailSortAcsDes);
  }
}

class UpdateAdminLL_LeadPhoneNoSortAcsDes implements Action {
  final int LeadPhoneNoSortAcsDes;

  UpdateAdminLL_LeadPhoneNoSortAcsDes(this.LeadPhoneNoSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(LeadPhoneNoSortAcsDes: LeadPhoneNoSortAcsDes);
  }
}

class UpdateAdminLL_LeadRatingSortAcsDes implements Action {
  final int LeadRatingSortAcsDes;

  UpdateAdminLL_LeadRatingSortAcsDes(this.LeadRatingSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(LeadRatingSortAcsDes: LeadRatingSortAcsDes);
  }
}

class UpdateAdminLL_LeadStatusSortAcsDes implements Action {
  final int LeadStatusSortAcsDes;

  UpdateAdminLL_LeadStatusSortAcsDes(this.LeadStatusSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(LeadStatusSortAcsDes: LeadStatusSortAcsDes);
  }
}

class UpdateAdminLL_LeadLLnameSortAcsDes implements Action {
  final int LeadLLnameSortAcsDes;

  UpdateAdminLL_LeadLLnameSortAcsDes(this.LeadLLnameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(LeadLLnameSortAcsDes: LeadLLnameSortAcsDes);
  }
}

class UpdateAdminLL_LeadPropertyNameSortAcsDes implements Action {
  final int LeadPropertyNameSortAcsDes;

  UpdateAdminLL_LeadPropertyNameSortAcsDes(this.LeadPropertyNameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsState(
        LeadPropertyNameSortAcsDes: LeadPropertyNameSortAcsDes);
  }
}

class UpdateAdminLL_leadstenantSearchText implements Action {
  final String leadstenantSearchText;

  UpdateAdminLL_leadstenantSearchText(this.leadstenantSearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsState(leadstenantSearchText: leadstenantSearchText);
  }
}

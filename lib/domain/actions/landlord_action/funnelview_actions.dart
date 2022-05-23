import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateFunnelLeadCount implements Action {
  final int count;

  UpdateFunnelLeadCount(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(lead_count: count);
  }
}

class UpdateFunnelApplicantCount implements Action {
  final int count;

  UpdateFunnelApplicantCount(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(applicant_count: count);
  }
}

class UpdateFunnelDocumentVarifyCount implements Action {
  final int count;

  UpdateFunnelDocumentVarifyCount(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(documentvarify_count: count);
  }
}

class UpdateFunnelReferenceCheckCount implements Action {
  final int count;

  UpdateFunnelReferenceCheckCount(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(referencecheck_count: count);
  }
}

class UpdateFunnelLeaseCount implements Action {
  final int count;

  UpdateFunnelLeaseCount(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(leasesent_count: count);
  }
}

class UpdateFunnelActiveTenantCount implements Action {
  final int count;

  UpdateFunnelActiveTenantCount(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(activetenent_count: count);
  }
}

class UpdateFunnelAllListData implements Action {
  final List<TenancyApplication> alllistdata;

  UpdateFunnelAllListData(this.alllistdata);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(alllistdata: alllistdata);
  }
}

class UpdateFunnelLeadList implements Action {
  final List<TenancyApplication> list;

  UpdateFunnelLeadList(this.list);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(leadlist: list);
  }
}

class UpdateFunnelApplicantList implements Action {
  final List<TenancyApplication> list;

  UpdateFunnelApplicantList(this.list);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(applicantlist: list);
  }
}

class UpdateFunnelDocumentVarifyList implements Action {
  final List<TenancyApplication> list;

  UpdateFunnelDocumentVarifyList(this.list);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(documentvarifylist: list);
  }
}

class UpdateFunnelReferenceList implements Action {
  final List<TenancyApplication> list;

  UpdateFunnelReferenceList(this.list);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(referencechecklist: list);
  }
}

class UpdateFunnelLeassentList implements Action {
  final List<TenancyApplication> list;

  UpdateFunnelLeassentList(this.list);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(leasesentlist: list);
  }
}

class UpdateFunnelActiveTenantList implements Action {
  final List<TenancyApplication> list;

  UpdateFunnelActiveTenantList(this.list);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.funnelViewState(activetenantlist: list);
  }
}

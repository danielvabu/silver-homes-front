import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLandlordApplicationTab implements Action {
  final int index;

  UpdateLandlordApplicationTab(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordApplicationState(selecttab: index);
  }
}

class UpdateLandlordApplication_Lead_Count implements Action {
  final int lead_count;

  UpdateLandlordApplication_Lead_Count(this.lead_count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordApplicationState(leads_cout: lead_count);
  }
}

class UpdateLandlordApplications_count implements Action {
  final int applications_count;

  UpdateLandlordApplications_count(this.applications_count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordApplicationState(applications_count: applications_count);
  }
}

class UpdateLandlordApplication_verification_documents_count implements Action {
  final int varfy_documents_count;

  UpdateLandlordApplication_verification_documents_count(
      this.varfy_documents_count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordApplicationState(varfy_documents_count: varfy_documents_count);
  }
}

class UpdateLandlordApplication_references_check_count implements Action {
  final int references_check_count;

  UpdateLandlordApplication_references_check_count(this.references_check_count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordApplicationState(
        references_check_count: references_check_count);
  }
}

class UpdateLandlordApplication_leases_count implements Action {
  final int leases_count;

  UpdateLandlordApplication_leases_count(this.leases_count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordApplicationState(leases_count: leases_count);
  }
}

class UpdateLandlordApplication_Active_Tenants_Count implements Action {
  final int active_tenants_count;

  UpdateLandlordApplication_Active_Tenants_Count(this.active_tenants_count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordApplicationState(active_tenants_count: active_tenants_count);
  }
}

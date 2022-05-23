import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/admin_class/db_tenant_owner_data.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminDB_totalProperty_cout implements Action {
  final int totalProperty_cout;

  UpdateAdminDB_totalProperty_cout(this.totalProperty_cout);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminDashbordState(totalProperty_cout: totalProperty_cout);
  }
}

class UpdateAdminDB_totalProperty_owner_cout implements Action {
  final int totalProperty_owner_cout;

  UpdateAdminDB_totalProperty_owner_cout(this.totalProperty_owner_cout);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminDashbordState(totalProperty_owner_cout: totalProperty_owner_cout);
  }
}

class UpdateAdminDB_totalTenant_cout implements Action {
  final int totalTenant_cout;

  UpdateAdminDB_totalTenant_cout(this.totalTenant_cout);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminDashbordState(totalTenant_cout: totalTenant_cout);
  }
}

class UpdateAdminDB_totallease_signed_count implements Action {
  final int totallease_signed_count;

  UpdateAdminDB_totallease_signed_count(this.totallease_signed_count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminDashbordState(totallease_signed_count: totallease_signed_count);
  }
}

class UpdateAdminDB_newJoineeOwnerList implements Action {
  final List<DbTenantOwnerData> newJoineeOwnerList;

  UpdateAdminDB_newJoineeOwnerList(this.newJoineeOwnerList);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminDashbordState(newJoineeOwnerList: newJoineeOwnerList);
  }
}

class UpdateAdminDB_todayTenantInviteList implements Action {
  final List<DbTenantOwnerData> todayTenantInviteList;

  UpdateAdminDB_todayTenantInviteList(this.todayTenantInviteList);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminDashbordState(todayTenantInviteList: todayTenantInviteList);
  }
}

import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdatePortalPage implements Action {
  final int index;
  final String title;

  UpdatePortalPage(this.index, this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .portalState(index: index, title: title, subindex: 0);
  }
}

class UpdateAddEditProperty implements Action {
  UpdateAddEditProperty();

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .portalState(index: 1, title: GlobleString.NAV_Properties, subindex: 1);
  }
}

class UpdateDetailsProperty implements Action {
  UpdateDetailsProperty();

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .portalState(index: 1, title: GlobleString.NAV_Properties, subindex: 2);
  }
}

class UpdateTenancyDetails implements Action {
  final List<TenancyApplication> listdataviewlist;

  UpdateTenancyDetails(this.listdataviewlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.portalState(
        index: 4,
        title: GlobleString.NAV_Tenants,
        subindex: 1,
        listdataviewlist: listdataviewlist);
  }
}

class UpdateisMenuDialogshow implements Action {
  final bool isMenuDialogshow;

  UpdateisMenuDialogshow(this.isMenuDialogshow);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.portalState(isMenuDialogshow: isMenuDialogshow);
  }
}

class UpdateNotificationCount implements Action {
  final int notificationcount;

  UpdateNotificationCount(this.notificationcount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.portalState(notificationCount: notificationcount);
  }
}

class UpdateTenantTabIndex implements Action {
  final int tabIndex;

  UpdateTenantTabIndex(this.tabIndex);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.portalState(tenantTabIndex: tabIndex);
  }
}

class UpdatePortalPageisLoading implements Action {
  final bool isLoading;

  UpdatePortalPageisLoading(this.isLoading);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.portalState(isLoading: isLoading);
  }
}

class UpdateMantenaceRequest implements Action {
  UpdateMantenaceRequest();

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.portalState(
        index: 5, title: GlobleString.NAV_Maintenance_requests, subindex: 1);
  }
}

class UpdateMantenaceVendor implements Action {
  UpdateMantenaceVendor();

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .portalState(index: 5, title: GlobleString.NAV_Vendors, subindex: 2);
  }
}

class UpdateMantenaceExpand implements Action {
  final bool isExpand;
  UpdateMantenaceExpand(this.isExpand);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.portalState(isMaintenanceExpand: isExpand);
  }
}

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateTenantPortalPage implements Action {
  final int index;
  final String title;

  UpdateTenantPortalPage(this.index, this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantPortalState(index: index, title: title, subindex: 0);
  }
}

class UpdateTenantPortalPage_notificationCount implements Action {
  final int notificationCount;

  UpdateTenantPortalPage_notificationCount(this.notificationCount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantPortalState(notificationCount: notificationCount);
  }
}

class UpdateTenantisMenuDialogshow implements Action {
  final bool isMenuDialogshow;

  UpdateTenantisMenuDialogshow(this.isMenuDialogshow);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantPortalState(isMenuDialogshow: isMenuDialogshow);
  }
}

class UpdateTenantPortalPage_isLoading implements Action {
  final bool isloading;

  UpdateTenantPortalPage_isLoading(this.isloading);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantPortalState(isLoading: isloading);
  }
}

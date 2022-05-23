import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminPortalPage implements Action {
  final int index;
  final String title;

  UpdateAdminPortalPage(this.index, this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPortalState(index: index, title: title, subindex: 0);
  }
}

class UpdateAdminPortalLeadTenancyDetails implements Action {
  final String title;

  UpdateAdminPortalLeadTenancyDetails(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPortalState(index: 2, title: title, subindex: 1);
  }
}

class UpdateAdminPortalLandlordDetails implements Action {
  final String title;

  UpdateAdminPortalLandlordDetails(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPortalState(index: 1, title: title, subindex: 1);
  }
}

class UpdateAdminPortalLandlordPropertyDetails implements Action {
  final String title;

  UpdateAdminPortalLandlordPropertyDetails(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPortalState(index: 1, title: title, subindex: 2);
  }
}

class UpdateAdminPortalLandlordTenancyDetails implements Action {
  final String title;

  UpdateAdminPortalLandlordTenancyDetails(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPortalState(index: 1, title: title, subindex: 3);
  }
}

class UpdateisMenuDialogshow implements Action {
  final bool isMenuDialogshow;

  UpdateisMenuDialogshow(this.isMenuDialogshow);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPortalState(isMenuDialogshow: isMenuDialogshow);
  }
}

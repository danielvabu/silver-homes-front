import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminSettingisLoading implements Action {
  final bool isloading;

  UpdateAdminSettingisLoading(this.isloading);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminSettingState(isloading: isloading);
  }
}

class UpdateAdminSettingID implements Action {
  final int ID;

  UpdateAdminSettingID(this.ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminSettingState(ID: ID);
  }
}

class UpdateAdminSettingisMaintenance implements Action {
  final bool isMaintenance;

  UpdateAdminSettingisMaintenance(this.isMaintenance);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminSettingState(isMaintenance: isMaintenance);
  }
}

class UpdateAdminSettingTitle implements Action {
  final String title;

  UpdateAdminSettingTitle(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminSettingState(title: title);
  }
}

class UpdateAdminSettingInstruction implements Action {
  final String instruction;

  UpdateAdminSettingInstruction(this.instruction);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminSettingState(instruction: instruction);
  }
}

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTMR_mid implements Action {
  final String mid;

  UpdateTMR_mid(this.mid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantAddMaintenanceState(mid: mid);
  }
}

class UpdateTMR_Type_User implements Action {
  final int Type_User;

  UpdateTMR_Type_User(this.Type_User);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantAddMaintenanceState(Type_User: Type_User);
  }
}

class UpdateTMR_IsLock implements Action {
  final bool IsLock;

  UpdateTMR_IsLock(this.IsLock);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantAddMaintenanceState(IsLock: IsLock);
  }
}

class UpdateTMR_requestName implements Action {
  final String requestName;

  UpdateTMR_requestName(this.requestName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantAddMaintenanceState(requestName: requestName);
  }
}

class UpdateTMR_priority implements Action {
  final int priority;

  UpdateTMR_priority(this.priority);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantAddMaintenanceState(priority: priority);
  }
}

class UpdateTMR_description implements Action {
  final String description;

  UpdateTMR_description(this.description);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantAddMaintenanceState(description: description);
  }
}

class UpdateTMR_fileobjectlist implements Action {
  final List<FileObject> fileobjectlist;

  UpdateTMR_fileobjectlist(this.fileobjectlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantAddMaintenanceState(fileobjectlist: fileobjectlist);
  }
}

class UpdateTMR_MaintenanceCategorylist implements Action {
  final List<SystemEnumDetails> MaintenanceCategorylist;

  UpdateTMR_MaintenanceCategorylist(this.MaintenanceCategorylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantAddMaintenanceState(
        MaintenanceCategorylist: MaintenanceCategorylist);
  }
}

class UpdateTMR_selectStatus implements Action {
  final SystemEnumDetails? selectStatus;

  UpdateTMR_selectStatus(this.selectStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantAddMaintenanceState(selectStatus: selectStatus);
  }
}

class UpdateTMR_selectCategory implements Action {
  final SystemEnumDetails? selectCategory;

  UpdateTMR_selectCategory(this.selectCategory);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantAddMaintenanceState(selectCategory: selectCategory);
  }
}

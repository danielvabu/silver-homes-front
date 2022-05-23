import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateArchiveToggle implements Action {
  final int index;

  UpdateArchiveToggle(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyArchiveState(selecttoggle: index);
  }
}

class UpdateArchiveisNameSort implements Action {
  final bool isSort;

  UpdateArchiveisNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyArchiveState(isNameSort: isSort);
  }
}

class UpdateArchiveisDateReceiveSort implements Action {
  final bool isSort;

  UpdateArchiveisDateReceiveSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(isDateReceiveSort: isSort);
  }
}

class UpdateArchiveisDateSentSort implements Action {
  final bool isSort;

  UpdateArchiveisDateSentSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(isDateSentSort: isSort);
  }
}

class UpdateArchiveisPropertySort implements Action {
  final bool isSort;

  UpdateArchiveisPropertySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(isPropertySort: isSort);
  }
}

class UpdateArchiveisAppStatusSort implements Action {
  final bool isSort;

  UpdateArchiveisAppStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(isAppStatusSort: isSort);
  }
}

class UpdateArchiveisRatingSort implements Action {
  final bool isSort;

  UpdateArchiveisRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyArchiveState(isRatingSort: isSort);
  }
}

class UpdateArchiveisOneItemSelect implements Action {
  final bool isOneItemSelect;

  UpdateArchiveisOneItemSelect(this.isOneItemSelect);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(isOneItemSelect: isOneItemSelect);
  }
}

class UpdateArchiveleadList implements Action {
  final List<TenancyApplication> archiveleadlist;

  UpdateArchiveleadList(this.archiveleadlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(archiveleadlist: archiveleadlist);
  }
}

class UpdateArchiveFilterArchiveleadlist implements Action {
  final List<TenancyApplication> filterarchiveleadlist;

  UpdateArchiveFilterArchiveleadlist(this.filterarchiveleadlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyArchiveState(
        filterarchiveleadlist: filterarchiveleadlist);
  }
}

class UpdateArchivePropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateArchivePropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(propertylist: propertylist);
  }
}

class UpdateArchivePropertyItem implements Action {
  final PropertyData? propertyitem;

  UpdateArchivePropertyItem(this.propertyitem);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landLordTenancyArchiveState(propertyValue: propertyitem);
  }
}

class UpdateArchiveisloding implements Action {
  final bool isloding;

  UpdateArchiveisloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landLordTenancyArchiveState(isloding: isloding);
  }
}

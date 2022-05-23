import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLRCToggle implements Action {
  final int index;

  UpdateLLRCToggle(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(selecttoggle: index);
  }
}

class UpdateLLRCisNameSort implements Action {
  final bool isSort;

  UpdateLLRCisNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(isNameSort: isSort);
  }
}

class UpdateLLRCisDateReceiveSort implements Action {
  final bool isSort;

  UpdateLLRCisDateReceiveSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(isDateReceiveSort: isSort);
  }
}

class UpdateLLRCisDateSentSort implements Action {
  final bool isSort;

  UpdateLLRCisDateSentSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(isDateSentSort: isSort);
  }
}

class UpdateLLRCisPropertySort implements Action {
  final bool isSort;

  UpdateLLRCisPropertySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(isPropertySort: isSort);
  }
}

class UpdateLLRCisAppStatusSort implements Action {
  final bool isSort;

  UpdateLLRCisAppStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(isAppStatusSort: isSort);
  }
}

class UpdateLLRCisRatingSort implements Action {
  final bool isSort;

  UpdateLLRCisRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(isRatingSort: isSort);
  }
}

class UpdateLLRCisReferenceSort implements Action {
  final bool isReferenceSort;

  UpdateLLRCisReferenceSort(this.isReferenceSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceCheckState(isReferenceSort: isReferenceSort);
  }
}

class UpdateLLRCReferenceCheckslist implements Action {
  final List<TenancyApplication> ReferenceCheckslist;

  UpdateLLRCReferenceCheckslist(this.ReferenceCheckslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceCheckState(ReferenceCheckslist: ReferenceCheckslist);
  }
}

class UpdateLLRCfilterReferenceCheckslist implements Action {
  final List<TenancyApplication> filterReferenceCheckslist;

  UpdateLLRCfilterReferenceCheckslist(this.filterReferenceCheckslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(
        filterReferenceCheckslist: filterReferenceCheckslist);
  }
}

class UpdateLLRCPropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateLLRCPropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(propertylist: propertylist);
  }
}

class UpdateLLRCPropertyItem implements Action {
  final PropertyData? propertyitem;

  UpdateLLRCPropertyItem(this.propertyitem);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(propertyValue: propertyitem);
  }
}

class UpdateLLRCisloding implements Action {
  final bool isloding;

  UpdateLLRCisloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckState(isloding: isloding);
  }
}

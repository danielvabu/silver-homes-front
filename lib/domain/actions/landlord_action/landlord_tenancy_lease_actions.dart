import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLTLToggle implements Action {
  final int index;

  UpdateLLTLToggle(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordTenancyLeaseState(selecttoggle: index);
  }
}

class UpdateLLTLisNameSort implements Action {
  final bool isSort;

  UpdateLLTLisNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordTenancyLeaseState(isNameSort: isSort);
  }
}

class UpdateLLTLisDateReceiveSort implements Action {
  final bool isSort;

  UpdateLLTLisDateReceiveSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordTenancyLeaseState(isDateReceiveSort: isSort);
  }
}

class UpdateLLTLisDateSentSort implements Action {
  final bool isSort;

  UpdateLLTLisDateSentSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordTenancyLeaseState(isDateSentSort: isSort);
  }
}

class UpdateLLTLisPropertySort implements Action {
  final bool isSort;

  UpdateLLTLisPropertySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordTenancyLeaseState(isPropertySort: isSort);
  }
}

class UpdateLLTLisAppStatusSort implements Action {
  final bool isSort;

  UpdateLLTLisAppStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordTenancyLeaseState(isAppStatusSort: isSort);
  }
}

class UpdateLLTLisRatingSort implements Action {
  final bool isSort;

  UpdateLLTLisRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordTenancyLeaseState(isRatingSort: isSort);
  }
}

class UpdateLLTLisLeaseStatusSort implements Action {
  final bool isLeaseStatusSort;

  UpdateLLTLisLeaseStatusSort(this.isLeaseStatusSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordTenancyLeaseState(isLeaseStatusSort: isLeaseStatusSort);
  }
}

class UpdateLLTLleaseleadlist implements Action {
  final List<TenancyApplication> leaseleadlist;

  UpdateLLTLleaseleadlist(this.leaseleadlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordTenancyLeaseState(leaseleadlist: leaseleadlist);
  }
}

class UpdateLLTLfilterleaseleadlist implements Action {
  final List<TenancyApplication> filterleaseleadlist;

  UpdateLLTLfilterleaseleadlist(this.filterleaseleadlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordTenancyLeaseState(filterleaseleadlist: filterleaseleadlist);
  }
}

class UpdateLLTLleasePropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateLLTLleasePropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordTenancyLeaseState(propertylist: propertylist);
  }
}

class UpdateLLTLleasePropertyItem implements Action {
  final PropertyData? propertyitem;

  UpdateLLTLleasePropertyItem(this.propertyitem);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordTenancyLeaseState(propertyValue: propertyitem);
  }
}

class UpdateLLTLleaseisloding implements Action {
  final bool isloding;

  UpdateLLTLleaseisloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordTenancyLeaseState(isloding: isloding);
  }
}

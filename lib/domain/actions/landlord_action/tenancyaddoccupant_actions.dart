import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateTFAddOccupantlist implements Action {
  final List<TenancyAdditionalOccupant> occupantlist;

  UpdateTFAddOccupantlist(this.occupantlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalOccupantState(occupantlist: occupantlist);
  }
}

class UpdateTFAddLiveServerOccupantlist implements Action {
  final List<TenancyAdditionalOccupant> liveoccupantlist;

  UpdateTFAddLiveServerOccupantlist(this.liveoccupantlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalOccupantState(liveserveroccupantlist: liveoccupantlist);
  }
}

class UpdateTFAddOccupantNotApplicable implements Action {
  final bool notapplicable;

  UpdateTFAddOccupantNotApplicable(this.notapplicable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalOccupantState(notapplicable: notapplicable);
  }
}

class UpdateTFAddOccupantIsUpdate implements Action {
  final bool isupdate;

  UpdateTFAddOccupantIsUpdate(this.isupdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalOccupantState(isUpdate: isupdate);
  }
}

class FNLUpdateTFAddOccupantlist implements Action {
  final List<TenancyAdditionalOccupant> occupantlist;

  FNLUpdateTFAddOccupantlist(this.occupantlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalOccupantState(FNLoccupantlist: occupantlist);
  }
}

class FNLUpdateTFAddLiveServerOccupantlist implements Action {
  final List<TenancyAdditionalOccupant> liveoccupantlist;

  FNLUpdateTFAddLiveServerOccupantlist(this.liveoccupantlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalOccupantState(FNLliveserveroccupantlist: liveoccupantlist);
  }
}

class FNLUpdateTFAddOccupantNotApplicable implements Action {
  final bool notapplicable;

  FNLUpdateTFAddOccupantNotApplicable(this.notapplicable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalOccupantState(FNLnotapplicable: notapplicable);
  }
}

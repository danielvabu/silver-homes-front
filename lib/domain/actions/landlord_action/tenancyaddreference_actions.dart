import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateTFAdditionalReferencelist implements Action {
  final List<TenancyAdditionalReference> referencelist;

  UpdateTFAdditionalReferencelist(this.referencelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalReferenceState(referencelist: referencelist);
  }
}

class UpdateTFAdditionalLiveServerReferencelist implements Action {
  final List<TenancyAdditionalReference> LiveServerreferencelist;

  UpdateTFAdditionalLiveServerReferencelist(this.LiveServerreferencelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalReferenceState(
        LiveServerreferencelist: LiveServerreferencelist);
  }
}

class UpdateTFAdditionalReferenceisAutherize implements Action {
  final bool isAutherize;

  UpdateTFAdditionalReferenceisAutherize(this.isAutherize);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalReferenceState(isAutherize: isAutherize);
  }
}

class UpdateTFAdditionalReferenceisTermsCondition implements Action {
  final bool isTermsCondition;

  UpdateTFAdditionalReferenceisTermsCondition(this.isTermsCondition);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalReferenceState(isTermsCondition: isTermsCondition);
  }
}

class UpdateTFAdditionalReferenceisUpdate implements Action {
  final bool isupdate;

  UpdateTFAdditionalReferenceisUpdate(this.isupdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalReferenceState(isUpdate: isupdate);
  }
}

class FNLUpdateTFAdditionalReferencelist implements Action {
  final List<TenancyAdditionalReference> referencelist;

  FNLUpdateTFAdditionalReferencelist(this.referencelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalReferenceState(FNLreferencelist: referencelist);
  }
}

class FNLUpdateTFAdditionalLiveServerReferencelist implements Action {
  final List<TenancyAdditionalReference> LiveServerreferencelist;

  FNLUpdateTFAdditionalLiveServerReferencelist(this.LiveServerreferencelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tfAdditionalReferenceState(
        FNLLiveServerreferencelist: LiveServerreferencelist);
  }
}

class FNLUpdateTFAdditionalReferenceisAutherize implements Action {
  final bool isAutherize;

  FNLUpdateTFAdditionalReferenceisAutherize(this.isAutherize);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalReferenceState(FNLisAutherize: isAutherize);
  }
}

class FNLUpdateTFAdditionalReferenceisTermsCondition implements Action {
  final bool isTermsCondition;

  FNLUpdateTFAdditionalReferenceisTermsCondition(this.isTermsCondition);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tfAdditionalReferenceState(FNLisTermsCondition: isTermsCondition);
  }
}

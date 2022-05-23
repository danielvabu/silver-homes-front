import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTenantPersonal_perFirstname implements Action {
  final String perFirstname;

  UpdateTenantPersonal_perFirstname(this.perFirstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantPersonalState(perFirstname: perFirstname);
  }
}

class UpdateTenantPersonal_perLastname implements Action {
  final String perLastname;

  UpdateTenantPersonal_perLastname(this.perLastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantPersonalState(perLastname: perLastname);
  }
}

class UpdateTenantPersonal_perEmail implements Action {
  final String perEmail;

  UpdateTenantPersonal_perEmail(this.perEmail);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantPersonalState(perEmail: perEmail);
  }
}

class UpdateTenantPersonal_perPhoneNumber implements Action {
  final String perPhoneNumber;

  UpdateTenantPersonal_perPhoneNumber(this.perPhoneNumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantPersonalState(perPhoneNumber: perPhoneNumber);
  }
}

class UpdateTenantPersonal_perCountryCode implements Action {
  final String perCountryCode;

  UpdateTenantPersonal_perCountryCode(this.perCountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantPersonalState(perCountryCode: perCountryCode);
  }
}

class UpdateTenantPersonal_perDialCode implements Action {
  final String perDialCode;

  UpdateTenantPersonal_perDialCode(this.perDialCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantPersonalState(perDialCode: perDialCode);
  }
}

class UpdateTenantPersonal_propertyImage implements Action {
  final MediaInfo? propertyImage;

  UpdateTenantPersonal_propertyImage(this.propertyImage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantPersonalState(propertyImage: propertyImage);
  }
}

class UpdateTenantPersonal_appimage implements Action {
  final Uint8List? appimage;

  UpdateTenantPersonal_appimage(this.appimage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantPersonalState(appimage: appimage);
  }
}

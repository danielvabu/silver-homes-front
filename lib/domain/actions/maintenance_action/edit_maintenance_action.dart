import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/basic_tenant/addvendordata.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/log_activity.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateMER_mid implements Action {
  final String mid;

  UpdateMER_mid(this.mid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(mid: mid);
  }
}

class UpdateMER_Type_User implements Action {
  final int Type_User;

  UpdateMER_Type_User(this.Type_User);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(Type_User: Type_User);
  }
}

class UpdateMER_Applicant_ID implements Action {
  final String Applicant_ID;

  UpdateMER_Applicant_ID(this.Applicant_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(Applicant_ID: Applicant_ID);
  }
}

class UpdateMER_Date_Created implements Action {
  final String Date_Created;

  UpdateMER_Date_Created(this.Date_Created);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(Date_Created: Date_Created);
  }
}

class UpdateMER_IsLock implements Action {
  final bool IsLock;

  UpdateMER_IsLock(this.IsLock);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(IsLock: IsLock);
  }
}

class UpdateMER_requestName implements Action {
  final String requestName;

  UpdateMER_requestName(this.requestName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(requestName: requestName);
  }
}

class UpdateMER_priority implements Action {
  final int priority;

  UpdateMER_priority(this.priority);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(priority: priority);
  }
}

class UpdateMER_description implements Action {
  final String description;

  UpdateMER_description(this.description);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(description: description);
  }
}

class UpdateMER_fileobjectlist implements Action {
  final List<FileObject> fileobjectlist;

  UpdateMER_fileobjectlist(this.fileobjectlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(fileobjectlist: fileobjectlist);
  }
}

class UpdateMER_vendordatalist implements Action {
  final List<AddVendorData> vendordatalist;

  UpdateMER_vendordatalist(this.vendordatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(vendordatalist: vendordatalist);
  }
}

class UpdateMER_MaintenanceStatuslist implements Action {
  final List<SystemEnumDetails> MaintenanceStatuslist;

  UpdateMER_MaintenanceStatuslist(this.MaintenanceStatuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(MaintenanceStatuslist: MaintenanceStatuslist);
  }
}

class UpdateMER_MaintenanceCategorylist implements Action {
  final List<SystemEnumDetails> MaintenanceCategorylist;

  UpdateMER_MaintenanceCategorylist(this.MaintenanceCategorylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(MaintenanceCategorylist: MaintenanceCategorylist);
  }
}

class UpdateMER_PropertyDropDatalist implements Action {
  final List<PropertyDropData> PropertyDropDatalist;

  UpdateMER_PropertyDropDatalist(this.PropertyDropDatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(PropertyDropDatalist: PropertyDropDatalist);
  }
}

class UpdateMER_selectStatus implements Action {
  final SystemEnumDetails? selectStatus;

  UpdateMER_selectStatus(this.selectStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(selectStatus: selectStatus);
  }
}

class UpdateMER_selectCategory implements Action {
  final SystemEnumDetails? selectCategory;

  UpdateMER_selectCategory(this.selectCategory);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(selectCategory: selectCategory);
  }
}

class UpdateMER_selectproperty implements Action {
  final PropertyDropData? selectproperty;

  UpdateMER_selectproperty(this.selectproperty);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(selectproperty: selectproperty);
  }
}

class UpdateMER_countrydatalist implements Action {
  final List<CountryData> countrydatalist;

  UpdateMER_countrydatalist(this.countrydatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(countrydatalist: countrydatalist);
  }
}

class UpdateMER_statedatalist implements Action {
  final List<StateData> statedatalist;

  UpdateMER_statedatalist(this.statedatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(statedatalist: statedatalist);
  }
}

class UpdateMER_citydatalist implements Action {
  final List<CityData> citydatalist;

  UpdateMER_citydatalist(this.citydatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(citydatalist: citydatalist);
  }
}

class UpdateMER_selectedCity implements Action {
  final List<CityData>? selectedCity;

  UpdateMER_selectedCity(this.selectedCity);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(selectedCity: selectedCity);
  }
}

class UpdateMER_mainvendordatalist implements Action {
  final List<VendorData> mainvendordatalist;

  UpdateMER_mainvendordatalist(this.mainvendordatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(mainvendordatalist: mainvendordatalist);
  }
}

class UpdateMER_filterCategorylist implements Action {
  final List<SystemEnumDetails> filterCategorylist;

  UpdateMER_filterCategorylist(this.filterCategorylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(filterCategorylist: filterCategorylist);
  }
}

class UpdateMER_selectedCountry implements Action {
  final CountryData? selectedCountry;

  UpdateMER_selectedCountry(this.selectedCountry);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(selectedCountry: selectedCountry);
  }
}

class UpdateMER_selectedState implements Action {
  final StateData? selectedState;

  UpdateMER_selectedState(this.selectedState);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.editMaintenanceState(selectedState: selectedState);
  }
}

class UpdateMER_logActivitylist implements Action {
  final List<LogActivity> logActivitylist;

  UpdateMER_logActivitylist(this.logActivitylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(logActivitylist: logActivitylist);
  }
}

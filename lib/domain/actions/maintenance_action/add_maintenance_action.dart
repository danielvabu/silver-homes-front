import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/basic_tenant/addvendordata.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateMAR_requestName implements Action {
  final String requestName;

  UpdateMAR_requestName(this.requestName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(requestName: requestName);
  }
}

class UpdateMAR_priority implements Action {
  final int priority;

  UpdateMAR_priority(this.priority);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(priority: priority);
  }
}

class UpdateMAR_description implements Action {
  final String description;

  UpdateMAR_description(this.description);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(description: description);
  }
}

class UpdateMAR_fileobjectlist implements Action {
  final List<FileObject> fileobjectlist;

  UpdateMAR_fileobjectlist(this.fileobjectlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(fileobjectlist: fileobjectlist);
  }
}

class UpdateMAR_vendordatalist implements Action {
  final List<AddVendorData> vendordatalist;

  UpdateMAR_vendordatalist(this.vendordatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(vendordatalist: vendordatalist);
  }
}

class UpdateMAR_MaintenanceStatuslist implements Action {
  final List<SystemEnumDetails> MaintenanceStatuslist;

  UpdateMAR_MaintenanceStatuslist(this.MaintenanceStatuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(MaintenanceStatuslist: MaintenanceStatuslist);
  }
}

class UpdateMAR_MaintenanceCategorylist implements Action {
  final List<SystemEnumDetails> MaintenanceCategorylist;

  UpdateMAR_MaintenanceCategorylist(this.MaintenanceCategorylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(MaintenanceCategorylist: MaintenanceCategorylist);
  }
}

class UpdateMAR_PropertyDropDatalist implements Action {
  final List<PropertyDropData> PropertyDropDatalist;

  UpdateMAR_PropertyDropDatalist(this.PropertyDropDatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(PropertyDropDatalist: PropertyDropDatalist);
  }
}

class UpdateMAR_selectStatus implements Action {
  final SystemEnumDetails? selectStatus;

  UpdateMAR_selectStatus(this.selectStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(selectStatus: selectStatus);
  }
}

class UpdateMAR_selectCategory implements Action {
  final SystemEnumDetails? selectCategory;

  UpdateMAR_selectCategory(this.selectCategory);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(selectCategory: selectCategory);
  }
}

class UpdateMAR_selectproperty implements Action {
  final PropertyDropData? selectproperty;

  UpdateMAR_selectproperty(this.selectproperty);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(selectproperty: selectproperty);
  }
}

class UpdateMAR_countrydatalist implements Action {
  final List<CountryData> countrydatalist;

  UpdateMAR_countrydatalist(this.countrydatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(countrydatalist: countrydatalist);
  }
}

class UpdateMAR_statedatalist implements Action {
  final List<StateData> statedatalist;

  UpdateMAR_statedatalist(this.statedatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(statedatalist: statedatalist);
  }
}

class UpdateMAR_citydatalist implements Action {
  final List<CityData> citydatalist;

  UpdateMAR_citydatalist(this.citydatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(citydatalist: citydatalist);
  }
}

class UpdateMAR_selectedCity implements Action {
  final List<CityData>? selectedCity;

  UpdateMAR_selectedCity(this.selectedCity);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(selectedCity: selectedCity);
  }
}

class UpdateMAR_mainvendordatalist implements Action {
  final List<VendorData> mainvendordatalist;

  UpdateMAR_mainvendordatalist(this.mainvendordatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(mainvendordatalist: mainvendordatalist);
  }
}

class UpdateMAR_filterCategorylist implements Action {
  final List<SystemEnumDetails> filterCategorylist;

  UpdateMAR_filterCategorylist(this.filterCategorylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(filterCategorylist: filterCategorylist);
  }
}

class UpdateMAR_selectedCountry implements Action {
  final CountryData? selectedCountry;

  UpdateMAR_selectedCountry(this.selectedCountry);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .addMaintenanceState(selectedCountry: selectedCountry);
  }
}

class UpdateMAR_selectedState implements Action {
  final StateData? selectedState;

  UpdateMAR_selectedState(this.selectedState);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addMaintenanceState(selectedState: selectedState);
  }
}

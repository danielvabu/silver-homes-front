import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateFurnishinglist implements Action {
  final List<SystemEnumDetails> furnishinglist;

  UpdateFurnishinglist(this.furnishinglist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyState(furnishinglist: furnishinglist);
  }
}

class UpdateFurnishingValue implements Action {
  final SystemEnumDetails? furnishingValue;

  UpdateFurnishingValue(this.furnishingValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyState(furnishingValue: furnishingValue);
  }
}

class UpdateRestrictionlist implements Action {
  final List<SystemEnumDetails> restrictionlist;

  UpdateRestrictionlist(this.restrictionlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyState(restrictionlist: restrictionlist);
  }
}

class UpdateOtherPartialFurniture implements Action {
  final String Other_Partial_Furniture;

  UpdateOtherPartialFurniture(this.Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(Other_Partial_Furniture: Other_Partial_Furniture);
  }
}

class UpdatePropertyBedrooms implements Action {
  final String PropertyBedrooms;

  UpdatePropertyBedrooms(this.PropertyBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyState(PropertyBedrooms: PropertyBedrooms);
  }
}

class UpdatePropertyBathrooms implements Action {
  final String PropertyBathrooms;

  UpdatePropertyBathrooms(this.PropertyBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(PropertyBathrooms: PropertyBathrooms);
  }
}

class UpdatePropertySizeinsquarefeet implements Action {
  final String PropertySizeinsquarefeet;

  UpdatePropertySizeinsquarefeet(this.PropertySizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(PropertySizeinsquarefeet: PropertySizeinsquarefeet);
  }
}

class UpdatePropertyMaxoccupancy implements Action {
  final String PropertyMaxoccupancy;

  UpdatePropertyMaxoccupancy(this.PropertyMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(PropertyMaxoccupancy: PropertyMaxoccupancy);
  }
}

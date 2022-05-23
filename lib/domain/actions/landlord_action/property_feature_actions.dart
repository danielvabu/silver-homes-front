import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdatePropertyAmenitiesList implements Action {
  final List<PropertyAmenitiesUtility> propertyamenitieslist1;

  UpdatePropertyAmenitiesList(this.propertyamenitieslist1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(propertyamenitieslist: propertyamenitieslist1);
  }
}

class UpdatePropertyUtilitiesList implements Action {
  final List<PropertyAmenitiesUtility> propertyutilitieslist1;

  UpdatePropertyUtilitiesList(this.propertyutilitieslist1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(propertyutilitieslist: propertyutilitieslist1);
  }
}

class UpdateStorageAvailableList implements Action {
  final List<SystemEnumDetails> storageavailablelist;

  UpdateStorageAvailableList(this.storageavailablelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(storageavailablelist: storageavailablelist);
  }
}

class UpdateStorageAvailableValue implements Action {
  final SystemEnumDetails? storageavailableValue;

  UpdateStorageAvailableValue(this.storageavailableValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(storageavailableValue: storageavailableValue);
  }
}

class UpdateParkingstalls implements Action {
  final String Parkingstalls;

  UpdateParkingstalls(this.Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertyState(Parkingstalls: Parkingstalls);
  }
}

class UpdatePropertyImageList implements Action {
  final List<PropertyImageMediaInfo> propertyImagelist;

  UpdatePropertyImageList(this.propertyImagelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertyState(propertyImagelist: propertyImagelist);
  }
}

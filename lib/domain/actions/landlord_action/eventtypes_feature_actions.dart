import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

/*class UpdateEventTypesAmenitiesList implements Action {
  final List<EventTypesAmenitiesUtility> eventtypesamenitieslist1;
  UpdateEventTypesAmenitiesList(this.eventtypesamenitieslist1);
  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(eventtypesamenitieslist: eventtypesamenitieslist1);
  }
}
class UpdateEventTypesUtilitiesList implements Action {
  final List<EventTypesAmenitiesUtility> eventtypesutilitieslist1;
  UpdateEventTypesUtilitiesList(this.eventtypesutilitieslist1);
  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(eventtypesutilitieslist: eventtypesutilitieslist1);
  }
}
*/
class UpdateStorageAvailableList implements Action {
  final List<SystemEnumDetails> storageavailablelist;
  UpdateStorageAvailableList(this.storageavailablelist);
  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(storageavailablelist: storageavailablelist);
  }
}

class UpdateStorageAvailableValue implements Action {
  final SystemEnumDetails? storageavailableValue;

  UpdateStorageAvailableValue(this.storageavailableValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(storageavailableValue: storageavailableValue);
  }
}

class UpdateParkingstalls implements Action {
  final String Parkingstalls;

  UpdateParkingstalls(this.Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(Parkingstalls: Parkingstalls);
  }
}

/*class UpdateEventTypesImageList implements Action {
  final List<EventTypesImageMediaInfo> eventtypesImagelist;

  UpdateEventTypesImageList(this.eventtypesImagelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(eventtypesImagelist: eventtypesImagelist);
  }
}*/

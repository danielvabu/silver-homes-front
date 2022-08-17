import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateFurnishinglist implements Action {
  final List<SystemEnumDetails> furnishinglist;

  UpdateFurnishinglist(this.furnishinglist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(furnishinglist: furnishinglist);
  }
}

class UpdateFurnishingValue implements Action {
  final SystemEnumDetails? furnishingValue;

  UpdateFurnishingValue(this.furnishingValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(furnishingValue: furnishingValue);
  }
}

class UpdateRestrictionlist implements Action {
  final List<SystemEnumDetails> restrictionlist;

  UpdateRestrictionlist(this.restrictionlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(restrictionlist: restrictionlist);
  }
}

class UpdateOtherPartialFurniture implements Action {
  final String Other_Partial_Furniture;

  UpdateOtherPartialFurniture(this.Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(Other_Partial_Furniture: Other_Partial_Furniture);
  }
}

class UpdateEventTypesBedrooms implements Action {
  final String EventTypesBedrooms;

  UpdateEventTypesBedrooms(this.EventTypesBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(EventTypesBedrooms: EventTypesBedrooms);
  }
}

class UpdateEventTypesBathrooms implements Action {
  final String EventTypesBathrooms;

  UpdateEventTypesBathrooms(this.EventTypesBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(EventTypesBathrooms: EventTypesBathrooms);
  }
}

class UpdateEventTypesSizeinsquarefeet implements Action {
  final String EventTypesSizeinsquarefeet;

  UpdateEventTypesSizeinsquarefeet(this.EventTypesSizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(EventTypesSizeinsquarefeet: EventTypesSizeinsquarefeet);
  }
}

class UpdateEventTypesMaxoccupancy implements Action {
  final String EventTypesMaxoccupancy;

  UpdateEventTypesMaxoccupancy(this.EventTypesMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(EventTypesMaxoccupancy: EventTypesMaxoccupancy);
  }
}

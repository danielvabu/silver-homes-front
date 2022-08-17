import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateSummeryProperTytypeValue implements Action {
  final SystemEnumDetails? eventtypestypeValue;

  UpdateSummeryProperTytypeValue(this.eventtypestypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(eventtypestypeValue: eventtypestypeValue);
  }
}

class UpdateSummeryEventTypesTypeOtherValue implements Action {
  final String eventtypestypeOtherValue;

  UpdateSummeryEventTypesTypeOtherValue(this.eventtypestypeOtherValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(
        eventtypestypeOtherValue: eventtypestypeOtherValue);
  }
}

class UpdateSummeryRentalSpaceValue implements Action {
  final SystemEnumDetails? rentalspaceValue;

  UpdateSummeryRentalSpaceValue(this.rentalspaceValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(rentalspaceValue: rentalspaceValue);
  }
}

class UpdateSummeryRentPaymentFrequencyValue implements Action {
  final SystemEnumDetails? rentpaymentFrequencyValue;

  UpdateSummeryRentPaymentFrequencyValue(this.rentpaymentFrequencyValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(
        rentpaymentFrequencyValue: rentpaymentFrequencyValue);
  }
}

class UpdateSummeryLeaseTypeValue implements Action {
  final SystemEnumDetails? leasetypeValue;

  UpdateSummeryLeaseTypeValue(this.leasetypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(leasetypeValue: leasetypeValue);
  }
}

class UpdateSummeryMinimumLeasedurationValue implements Action {
  final SystemEnumDetails? minimumleasedurationValue;

  UpdateSummeryMinimumLeasedurationValue(this.minimumleasedurationValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(
        minimumleasedurationValue: minimumleasedurationValue);
  }
}

class UpdateSummeryMinimumleasedurationNumber implements Action {
  final String minimumleasedurationnumber;

  UpdateSummeryMinimumleasedurationNumber(this.minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(
        minimumleasedurationnumber: minimumleasedurationnumber);
  }
}

class UpdateSummeryDateofavailable implements Action {
  final DateTime? dateofavailable;

  UpdateSummeryDateofavailable(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(dateofavailable: dateofavailable);
  }
}

class UpdateSummeryEventTypesName implements Action {
  final String EventTypesName;

  UpdateSummeryEventTypesName(this.EventTypesName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(EventTypesName: EventTypesName);
  }
}

class UpdateSummeryEventTypesAddress implements Action {
  final String EventTypesAddress;

  UpdateSummeryEventTypesAddress(this.EventTypesAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(EventTypesAddress: EventTypesAddress);
  }
}

class UpdateSummeryEventTypesDescription implements Action {
  final String EventTypesDescription;

  UpdateSummeryEventTypesDescription(this.EventTypesDescription);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(EventTypesDescription: EventTypesDescription);
  }
}

class UpdateSummerySuiteunit implements Action {
  final String Suiteunit;

  UpdateSummerySuiteunit(this.Suiteunit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(Suiteunit: Suiteunit);
  }
}

class UpdateSummeryBuildingname implements Action {
  final String Buildingname;

  UpdateSummeryBuildingname(this.Buildingname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(Buildingname: Buildingname);
  }
}

class UpdateSummeryEventTypesCity implements Action {
  final String City;

  UpdateSummeryEventTypesCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(City: City);
  }
}

class UpdateSummeryEventTypesProvince implements Action {
  final String Province;

  UpdateSummeryEventTypesProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(Province: Province);
  }
}

class UpdateSummeryEventTypesCountryName implements Action {
  final String CountryName;

  UpdateSummeryEventTypesCountryName(this.CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(CountryName: CountryName);
  }
}

class UpdateSummeryEventTypesCountryCode implements Action {
  final String CountryCode;

  UpdateSummeryEventTypesCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(CountryCode: CountryCode);
  }
}

class UpdateSummeryEventTypesPostalcode implements Action {
  final String Postalcode;

  UpdateSummeryEventTypesPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(Postalcode: Postalcode);
  }
}

class UpdateSummeryEventTypesRentAmount implements Action {
  final String RentAmount;

  UpdateSummeryEventTypesRentAmount(this.RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(RentAmount: RentAmount);
  }
}

class UpdateSummeryEventTypesImage implements Action {
  final MediaInfo? eventtypesImage;

  UpdateSummeryEventTypesImage(this.eventtypesImage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(eventtypesImage: eventtypesImage);
  }
}

class UpdateSummeryEventTypesUint8List implements Action {
  final Uint8List? appimage;

  UpdateSummeryEventTypesUint8List(this.appimage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(appimage: appimage);
  }
}

class UpdateSummeryEventTypesDrafting implements Action {
  final int PropDrafting;

  UpdateSummeryEventTypesDrafting(this.PropDrafting);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(PropDrafting: PropDrafting);
  }
}

class UpdateSummeryEventTypesVacancy implements Action {
  final bool PropVacancy;

  UpdateSummeryEventTypesVacancy(this.PropVacancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(PropVacancy: PropVacancy);
  }
}

class UpdateSummeryFurnishingValue implements Action {
  final SystemEnumDetails? furnishingValue;

  UpdateSummeryFurnishingValue(this.furnishingValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(furnishingValue: furnishingValue);
  }
}

class UpdateSummeryRestrictionlist implements Action {
  final List<SystemEnumDetails> restrictionlist;

  UpdateSummeryRestrictionlist(this.restrictionlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(restrictionlist: restrictionlist);
  }
}

class UpdateSummeryOtherPartialFurniture implements Action {
  final String Other_Partial_Furniture;

  UpdateSummeryOtherPartialFurniture(this.Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(
        Other_Partial_Furniture: Other_Partial_Furniture);
  }
}

class UpdateSummeryEventTypesBedrooms implements Action {
  final String EventTypesBedrooms;

  UpdateSummeryEventTypesBedrooms(this.EventTypesBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(EventTypesBedrooms: EventTypesBedrooms);
  }
}

class UpdateSummeryEventTypesBathrooms implements Action {
  final String EventTypesBathrooms;

  UpdateSummeryEventTypesBathrooms(this.EventTypesBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(EventTypesBathrooms: EventTypesBathrooms);
  }
}

class UpdateSummeryEventTypesSizeinsquarefeet implements Action {
  final String EventTypesSizeinsquarefeet;

  UpdateSummeryEventTypesSizeinsquarefeet(this.EventTypesSizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(
        EventTypesSizeinsquarefeet: EventTypesSizeinsquarefeet);
  }
}

class UpdateSummeryEventTypesMaxoccupancy implements Action {
  final String EventTypesMaxoccupancy;

  UpdateSummeryEventTypesMaxoccupancy(this.EventTypesMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(EventTypesMaxoccupancy: EventTypesMaxoccupancy);
  }
}

/*class UpdateSummeryEventTypesAmenitiesList implements Action {
  List<EventTypesAmenitiesUtility> Summeryeventtypesamenitieslist;
  UpdateSummeryEventTypesAmenitiesList(this.Summeryeventtypesamenitieslist);
  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(Summeryeventtypesamenitieslist: Summeryeventtypesamenitieslist);
  }
}
class UpdateSummeryEventTypesUtilitiesList implements Action {
  List<EventTypesAmenitiesUtility> Summeryeventtypesutilitieslist;
  UpdateSummeryEventTypesUtilitiesList(this.Summeryeventtypesutilitieslist);
  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(Summeryeventtypesutilitieslist: Summeryeventtypesutilitieslist);
  }
}
*/
class UpdateSummeryStorageAvailableValue implements Action {
  final SystemEnumDetails? storageavailableValue;

  UpdateSummeryStorageAvailableValue(this.storageavailableValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(storageavailableValue: storageavailableValue);
  }
}

class UpdateSummeryParkingstalls implements Action {
  final String Parkingstalls;

  UpdateSummeryParkingstalls(this.Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesSummeryState(Parkingstalls: Parkingstalls);
  }
}

class UpdateSummeryAgreeTCPP implements Action {
  final bool agreeTCPP;

  UpdateSummeryAgreeTCPP(this.agreeTCPP);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(agree_TCPP: agreeTCPP);
  }
}

/*class UpdateSummeryEventTypesImageList implements Action {
  final List<EventTypesImageMediaInfo> eventtypesImagelist;
  UpdateSummeryEventTypesImageList(this.eventtypesImagelist);
  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesSummeryState(SummeryeventtypesImagelist: eventtypesImagelist);
  }
}
*/
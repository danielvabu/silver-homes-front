import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateSummeryProperTytypeValue implements Action {
  final SystemEnumDetails? propertytypeValue;

  UpdateSummeryProperTytypeValue(this.propertytypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(propertytypeValue: propertytypeValue);
  }
}

class UpdateSummeryPropertyTypeOtherValue implements Action {
  final String propertytypeOtherValue;

  UpdateSummeryPropertyTypeOtherValue(this.propertytypeOtherValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(propertytypeOtherValue: propertytypeOtherValue);
  }
}

class UpdateSummeryRentalSpaceValue implements Action {
  final SystemEnumDetails? rentalspaceValue;

  UpdateSummeryRentalSpaceValue(this.rentalspaceValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(rentalspaceValue: rentalspaceValue);
  }
}

class UpdateSummeryRentPaymentFrequencyValue implements Action {
  final SystemEnumDetails? rentpaymentFrequencyValue;

  UpdateSummeryRentPaymentFrequencyValue(this.rentpaymentFrequencyValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(
        rentpaymentFrequencyValue: rentpaymentFrequencyValue);
  }
}

class UpdateSummeryLeaseTypeValue implements Action {
  final SystemEnumDetails? leasetypeValue;

  UpdateSummeryLeaseTypeValue(this.leasetypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(leasetypeValue: leasetypeValue);
  }
}

class UpdateSummeryMinimumLeasedurationValue implements Action {
  final SystemEnumDetails? minimumleasedurationValue;

  UpdateSummeryMinimumLeasedurationValue(this.minimumleasedurationValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(
        minimumleasedurationValue: minimumleasedurationValue);
  }
}

class UpdateSummeryMinimumleasedurationNumber implements Action {
  final String minimumleasedurationnumber;

  UpdateSummeryMinimumleasedurationNumber(this.minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(
        minimumleasedurationnumber: minimumleasedurationnumber);
  }
}

class UpdateSummeryDateofavailable implements Action {
  final DateTime? dateofavailable;

  UpdateSummeryDateofavailable(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(dateofavailable: dateofavailable);
  }
}

class UpdateSummeryPropertyName implements Action {
  final String PropertyName;

  UpdateSummeryPropertyName(this.PropertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(PropertyName: PropertyName);
  }
}

class UpdateSummeryPropertyAddress implements Action {
  final String PropertyAddress;

  UpdateSummeryPropertyAddress(this.PropertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(PropertyAddress: PropertyAddress);
  }
}

class UpdateSummeryPropertyDescription implements Action {
  final String PropertyDescription;

  UpdateSummeryPropertyDescription(this.PropertyDescription);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(PropertyDescription: PropertyDescription);
  }
}

class UpdateSummerySuiteunit implements Action {
  final String Suiteunit;

  UpdateSummerySuiteunit(this.Suiteunit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(Suiteunit: Suiteunit);
  }
}

class UpdateSummeryBuildingname implements Action {
  final String Buildingname;

  UpdateSummeryBuildingname(this.Buildingname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(Buildingname: Buildingname);
  }
}

class UpdateSummeryPropertyCity implements Action {
  final String City;

  UpdateSummeryPropertyCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(City: City);
  }
}

class UpdateSummeryPropertyProvince implements Action {
  final String Province;

  UpdateSummeryPropertyProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(Province: Province);
  }
}

class UpdateSummeryPropertyCountryName implements Action {
  final String CountryName;

  UpdateSummeryPropertyCountryName(this.CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(CountryName: CountryName);
  }
}

class UpdateSummeryPropertyCountryCode implements Action {
  final String CountryCode;

  UpdateSummeryPropertyCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(CountryCode: CountryCode);
  }
}

class UpdateSummeryPropertyPostalcode implements Action {
  final String Postalcode;

  UpdateSummeryPropertyPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(Postalcode: Postalcode);
  }
}

class UpdateSummeryPropertyRentAmount implements Action {
  final String RentAmount;

  UpdateSummeryPropertyRentAmount(this.RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(RentAmount: RentAmount);
  }
}

class UpdateSummeryPropertyImage implements Action {
  final MediaInfo? propertyImage;

  UpdateSummeryPropertyImage(this.propertyImage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(propertyImage: propertyImage);
  }
}

class UpdateSummeryPropertyUint8List implements Action {
  final Uint8List? appimage;

  UpdateSummeryPropertyUint8List(this.appimage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(appimage: appimage);
  }
}

class UpdateSummeryPropertyDrafting implements Action {
  final int PropDrafting;

  UpdateSummeryPropertyDrafting(this.PropDrafting);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(PropDrafting: PropDrafting);
  }
}

class UpdateSummeryPropertyVacancy implements Action {
  final bool PropVacancy;

  UpdateSummeryPropertyVacancy(this.PropVacancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(PropVacancy: PropVacancy);
  }
}

class UpdateSummeryFurnishingValue implements Action {
  final SystemEnumDetails? furnishingValue;

  UpdateSummeryFurnishingValue(this.furnishingValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(furnishingValue: furnishingValue);
  }
}

class UpdateSummeryRestrictionlist implements Action {
  final List<SystemEnumDetails> restrictionlist;

  UpdateSummeryRestrictionlist(this.restrictionlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(restrictionlist: restrictionlist);
  }
}

class UpdateSummeryOtherPartialFurniture implements Action {
  final String Other_Partial_Furniture;

  UpdateSummeryOtherPartialFurniture(this.Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(Other_Partial_Furniture: Other_Partial_Furniture);
  }
}

class UpdateSummeryPropertyBedrooms implements Action {
  final String PropertyBedrooms;

  UpdateSummeryPropertyBedrooms(this.PropertyBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(PropertyBedrooms: PropertyBedrooms);
  }
}

class UpdateSummeryPropertyBathrooms implements Action {
  final String PropertyBathrooms;

  UpdateSummeryPropertyBathrooms(this.PropertyBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(PropertyBathrooms: PropertyBathrooms);
  }
}

class UpdateSummeryPropertySizeinsquarefeet implements Action {
  final String PropertySizeinsquarefeet;

  UpdateSummeryPropertySizeinsquarefeet(this.PropertySizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(
        PropertySizeinsquarefeet: PropertySizeinsquarefeet);
  }
}

class UpdateSummeryPropertyMaxoccupancy implements Action {
  final String PropertyMaxoccupancy;

  UpdateSummeryPropertyMaxoccupancy(this.PropertyMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(PropertyMaxoccupancy: PropertyMaxoccupancy);
  }
}

class UpdateSummeryPropertyAmenitiesList implements Action {
  List<PropertyAmenitiesUtility> Summerypropertyamenitieslist;

  UpdateSummeryPropertyAmenitiesList(this.Summerypropertyamenitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(
        Summerypropertyamenitieslist: Summerypropertyamenitieslist);
  }
}

class UpdateSummeryPropertyUtilitiesList implements Action {
  List<PropertyAmenitiesUtility> Summerypropertyutilitieslist;

  UpdateSummeryPropertyUtilitiesList(this.Summerypropertyutilitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(
        Summerypropertyutilitieslist: Summerypropertyutilitieslist);
  }
}

class UpdateSummeryStorageAvailableValue implements Action {
  final SystemEnumDetails? storageavailableValue;

  UpdateSummeryStorageAvailableValue(this.storageavailableValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(storageavailableValue: storageavailableValue);
  }
}

class UpdateSummeryParkingstalls implements Action {
  final String Parkingstalls;

  UpdateSummeryParkingstalls(this.Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(Parkingstalls: Parkingstalls);
  }
}

class UpdateSummeryAgreeTCPP implements Action {
  final bool agreeTCPP;

  UpdateSummeryAgreeTCPP(this.agreeTCPP);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.propertySummeryState(agree_TCPP: agreeTCPP);
  }
}

class UpdateSummeryPropertyImageList implements Action {
  final List<PropertyImageMediaInfo> propertyImagelist;

  UpdateSummeryPropertyImageList(this.propertyImagelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .propertySummeryState(SummerypropertyImagelist: propertyImagelist);
  }
}

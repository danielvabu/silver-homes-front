import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateAdminSummeryProperTytypeValue implements Action {
  final SystemEnumDetails? propertytypeValue;

  UpdateAdminSummeryProperTytypeValue(this.propertytypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(propertytypeValue: propertytypeValue);
  }
}

class UpdateAdminSummeryPropertyTypeOtherValue implements Action {
  final String propertytypeOtherValue;

  UpdateAdminSummeryPropertyTypeOtherValue(this.propertytypeOtherValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        propertytypeOtherValue: propertytypeOtherValue);
  }
}

class UpdateAdminSummeryRentalSpaceValue implements Action {
  final SystemEnumDetails? rentalspaceValue;

  UpdateAdminSummeryRentalSpaceValue(this.rentalspaceValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(rentalspaceValue: rentalspaceValue);
  }
}

class UpdateAdminSummeryRentPaymentFrequencyValue implements Action {
  final SystemEnumDetails? rentpaymentFrequencyValue;

  UpdateAdminSummeryRentPaymentFrequencyValue(this.rentpaymentFrequencyValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        rentpaymentFrequencyValue: rentpaymentFrequencyValue);
  }
}

class UpdateAdminSummeryLeaseTypeValue implements Action {
  final SystemEnumDetails? leasetypeValue;

  UpdateAdminSummeryLeaseTypeValue(this.leasetypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(leasetypeValue: leasetypeValue);
  }
}

class UpdateAdminSummeryMinimumLeasedurationValue implements Action {
  final SystemEnumDetails? minimumleasedurationValue;

  UpdateAdminSummeryMinimumLeasedurationValue(this.minimumleasedurationValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        minimumleasedurationValue: minimumleasedurationValue);
  }
}

class UpdateAdminSummeryMinimumleasedurationNumber implements Action {
  final String minimumleasedurationnumber;

  UpdateAdminSummeryMinimumleasedurationNumber(this.minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        minimumleasedurationnumber: minimumleasedurationnumber);
  }
}

class UpdateAdminSummeryDateofavailable implements Action {
  final DateTime? dateofavailable;

  UpdateAdminSummeryDateofavailable(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(dateofavailable: dateofavailable);
  }
}

class UpdateAdminSummeryPropertyName implements Action {
  final String propertyName;

  UpdateAdminSummeryPropertyName(this.propertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropertyName: propertyName);
  }
}

class UpdateAdminSummeryPropertyAddress implements Action {
  final String propertyAddress;

  UpdateAdminSummeryPropertyAddress(this.propertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropertyAddress: propertyAddress);
  }
}

class UpdateAdminSummeryPropertyDescription implements Action {
  final String propertyDescription;

  UpdateAdminSummeryPropertyDescription(this.propertyDescription);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropertyDescription: propertyDescription);
  }
}

class UpdateAdminSummerySuiteunit implements Action {
  final String suiteunit;

  UpdateAdminSummerySuiteunit(this.suiteunit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(Suiteunit: suiteunit);
  }
}

class UpdateAdminSummeryBuildingname implements Action {
  final String buildingname;

  UpdateAdminSummeryBuildingname(this.buildingname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(Buildingname: buildingname);
  }
}

class UpdateAdminSummeryPropertyCity implements Action {
  final String city;

  UpdateAdminSummeryPropertyCity(this.city);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(City: city);
  }
}

class UpdateAdminSummeryPropertyProvince implements Action {
  final String province;

  UpdateAdminSummeryPropertyProvince(this.province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(Province: province);
  }
}

class UpdateAdminSummeryPropertyCountryName implements Action {
  final String countryName;

  UpdateAdminSummeryPropertyCountryName(this.countryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(CountryName: countryName);
  }
}

class UpdateAdminSummeryPropertyCountryCode implements Action {
  final String countryCode;

  UpdateAdminSummeryPropertyCountryCode(this.countryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(CountryCode: countryCode);
  }
}

class UpdateAdminSummeryPropertyPostalcode implements Action {
  final String postalcode;

  UpdateAdminSummeryPropertyPostalcode(this.postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(Postalcode: postalcode);
  }
}

class UpdateAdminSummeryPropertyRentAmount implements Action {
  final String rentAmount;

  UpdateAdminSummeryPropertyRentAmount(this.rentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(RentAmount: rentAmount);
  }
}

class UpdateAdminSummeryPropertyImage implements Action {
  final MediaInfo? propertyImage;

  UpdateAdminSummeryPropertyImage(this.propertyImage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(propertyImage: propertyImage);
  }
}

class UpdateAdminSummeryPropertyUint8List implements Action {
  final Uint8List? appimage;

  UpdateAdminSummeryPropertyUint8List(this.appimage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(appimage: appimage);
  }
}

class UpdateAdminSummeryPropertyDrafting implements Action {
  final int propDrafting;

  UpdateAdminSummeryPropertyDrafting(this.propDrafting);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropDrafting: propDrafting);
  }
}

class UpdateAdminSummeryPropertyVacancy implements Action {
  final bool propVacancy;

  UpdateAdminSummeryPropertyVacancy(this.propVacancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropVacancy: propVacancy);
  }
}

class UpdateAdminSummeryFurnishingValue implements Action {
  final SystemEnumDetails? furnishingValue;

  UpdateAdminSummeryFurnishingValue(this.furnishingValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(furnishingValue: furnishingValue);
  }
}

class UpdateAdminSummeryRestrictionlist implements Action {
  final List<SystemEnumDetails> restrictionlist;

  UpdateAdminSummeryRestrictionlist(this.restrictionlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(restrictionlist: restrictionlist);
  }
}

class UpdateAdminSummeryOtherPartialFurniture implements Action {
  final String otherpartialfurniture;

  UpdateAdminSummeryOtherPartialFurniture(this.otherpartialfurniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        Other_Partial_Furniture: otherpartialfurniture);
  }
}

class UpdateAdminSummeryPropertyBedrooms implements Action {
  final String propertyBedrooms;

  UpdateAdminSummeryPropertyBedrooms(this.propertyBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropertyBedrooms: propertyBedrooms);
  }
}

class UpdateAdminSummeryPropertyBathrooms implements Action {
  final String propertyBathrooms;

  UpdateAdminSummeryPropertyBathrooms(this.propertyBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropertyBathrooms: propertyBathrooms);
  }
}

class UpdateAdminSummeryPropertySizeinsquarefeet implements Action {
  final String propertySizeinsquarefeet;

  UpdateAdminSummeryPropertySizeinsquarefeet(this.propertySizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        PropertySizeinsquarefeet: propertySizeinsquarefeet);
  }
}

class UpdateAdminSummeryPropertyMaxoccupancy implements Action {
  final String propertyMaxoccupancy;

  UpdateAdminSummeryPropertyMaxoccupancy(this.propertyMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(PropertyMaxoccupancy: propertyMaxoccupancy);
  }
}

class UpdateAdminSummeryPropertyAmenitiesList implements Action {
  List<PropertyAmenitiesUtility> summerypropertyamenitieslist;

  UpdateAdminSummeryPropertyAmenitiesList(this.summerypropertyamenitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        Summerypropertyamenitieslist: summerypropertyamenitieslist);
  }
}

class UpdateAdminSummeryPropertyUtilitiesList implements Action {
  List<PropertyAmenitiesUtility> summerypropertyutilitieslist;

  UpdateAdminSummeryPropertyUtilitiesList(this.summerypropertyutilitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        Summerypropertyutilitieslist: summerypropertyutilitieslist);
  }
}

class UpdateAdminSummeryStorageAvailableValue implements Action {
  final SystemEnumDetails? storageavailableValue;

  UpdateAdminSummeryStorageAvailableValue(this.storageavailableValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(
        storageavailableValue: storageavailableValue);
  }
}

class UpdateAdminSummeryParkingstalls implements Action {
  final String parkingstalls;

  UpdateAdminSummeryParkingstalls(this.parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(Parkingstalls: parkingstalls);
  }
}

class UpdateAdminSummeryAgreeTCPP implements Action {
  final bool agreeTCPP;

  UpdateAdminSummeryAgreeTCPP(this.agreeTCPP);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminPropertyDetailsState(agree_TCPP: agreeTCPP);
  }
}

class UpdateAdminSummeryPropertyImageList implements Action {
  final List<PropertyImageMediaInfo> propertyImagelist;

  UpdateAdminSummeryPropertyImageList(this.propertyImagelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminPropertyDetailsState(propertyImagelist: propertyImagelist);
  }
}

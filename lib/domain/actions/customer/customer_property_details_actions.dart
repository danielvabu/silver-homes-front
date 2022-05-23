import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateCPDPropID implements Action {
  final String PropID;

  UpdateCPDPropID(this.PropID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(PropID: PropID);
  }
}

class UpdateCPDProperTytypeValue implements Action {
  final SystemEnumDetails? propertytypeValue;

  UpdateCPDProperTytypeValue(this.propertytypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(propertytypeValue: propertytypeValue);
  }
}

class UpdateCPDPropertyTypeOtherValue implements Action {
  final String propertytypeOtherValue;

  UpdateCPDPropertyTypeOtherValue(this.propertytypeOtherValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        propertytypeOtherValue: propertytypeOtherValue);
  }
}

class UpdateCPDRentalSpaceValue implements Action {
  final SystemEnumDetails? rentalspaceValue;

  UpdateCPDRentalSpaceValue(this.rentalspaceValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(rentalspaceValue: rentalspaceValue);
  }
}

class UpdateCPDRentPaymentFrequencyValue implements Action {
  final SystemEnumDetails? rentpaymentFrequencyValue;

  UpdateCPDRentPaymentFrequencyValue(this.rentpaymentFrequencyValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        rentpaymentFrequencyValue: rentpaymentFrequencyValue);
  }
}

class UpdateCPDLeaseTypeValue implements Action {
  final SystemEnumDetails? leasetypeValue;

  UpdateCPDLeaseTypeValue(this.leasetypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(leasetypeValue: leasetypeValue);
  }
}

class UpdateCPDMinimumLeasedurationValue implements Action {
  final SystemEnumDetails? minimumleasedurationValue;

  UpdateCPDMinimumLeasedurationValue(this.minimumleasedurationValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        minimumleasedurationValue: minimumleasedurationValue);
  }
}

class UpdateCPDMinimumleasedurationNumber implements Action {
  final String minimumleasedurationnumber;

  UpdateCPDMinimumleasedurationNumber(this.minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        minimumleasedurationnumber: minimumleasedurationnumber);
  }
}

class UpdateCPDDateofavailable implements Action {
  final String dateofavailable;

  UpdateCPDDateofavailable(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(dateofavailable: dateofavailable);
  }
}

class UpdateCPDPropertyName implements Action {
  final String PropertyName;

  UpdateCPDPropertyName(this.PropertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(PropertyName: PropertyName);
  }
}

class UpdateCPDPropertyAddress implements Action {
  final String PropertyAddress;

  UpdateCPDPropertyAddress(this.PropertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(PropertyAddress: PropertyAddress);
  }
}

class UpdateCPDPropertyDescription implements Action {
  final String PropertyDescription;

  UpdateCPDPropertyDescription(this.PropertyDescription);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(PropertyDescription: PropertyDescription);
  }
}

class UpdateCPDSuiteunit implements Action {
  final String Suiteunit;

  UpdateCPDSuiteunit(this.Suiteunit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(Suiteunit: Suiteunit);
  }
}

class UpdateCPDBuildingname implements Action {
  final String Buildingname;

  UpdateCPDBuildingname(this.Buildingname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Buildingname: Buildingname);
  }
}

class UpdateCPDPropertyCity implements Action {
  final String City;

  UpdateCPDPropertyCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(City: City);
  }
}

class UpdateCPDPropertyProvince implements Action {
  final String Province;

  UpdateCPDPropertyProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(Province: Province);
  }
}

class UpdateCPDPropertyCountryName implements Action {
  final String CountryName;

  UpdateCPDPropertyCountryName(this.CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(CountryName: CountryName);
  }
}

class UpdateCPDPropertyCountryCode implements Action {
  final String CountryCode;

  UpdateCPDPropertyCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(CountryCode: CountryCode);
  }
}

class UpdateCPDPropertyPostalcode implements Action {
  final String Postalcode;

  UpdateCPDPropertyPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Postalcode: Postalcode);
  }
}

class UpdateCPDPropertyRentAmount implements Action {
  final String RentAmount;

  UpdateCPDPropertyRentAmount(this.RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(RentAmount: RentAmount);
  }
}

class UpdateCPDPropertyImage implements Action {
  final MediaInfo? propertyImage;

  UpdateCPDPropertyImage(this.propertyImage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(propertyImage: propertyImage);
  }
}

class UpdateCPDPropertyUint8List implements Action {
  final Uint8List? appimage;

  UpdateCPDPropertyUint8List(this.appimage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(appimage: appimage);
  }
}

class UpdateCPDPropertyImageList implements Action {
  final List<PropertyImageMediaInfo> propertyImagelist;

  UpdateCPDPropertyImageList(this.propertyImagelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(propertyImagelist: propertyImagelist);
  }
}

class UpdateCPDPropertyDrafting implements Action {
  final int PropDrafting;

  UpdateCPDPropertyDrafting(this.PropDrafting);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(PropDrafting: PropDrafting);
  }
}

class UpdateCPDPropertyVacancy implements Action {
  final bool PropVacancy;

  UpdateCPDPropertyVacancy(this.PropVacancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(PropVacancy: PropVacancy);
  }
}

class UpdateCPDFurnishingValue implements Action {
  final SystemEnumDetails? furnishingValue;

  UpdateCPDFurnishingValue(this.furnishingValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(furnishingValue: furnishingValue);
  }
}

class UpdateCPDRestrictionlist implements Action {
  final List<SystemEnumDetails> restrictionlist;

  UpdateCPDRestrictionlist(this.restrictionlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(restrictionlist: restrictionlist);
  }
}

class UpdateCPDOtherPartialFurniture implements Action {
  final String Other_Partial_Furniture;

  UpdateCPDOtherPartialFurniture(this.Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        Other_Partial_Furniture: Other_Partial_Furniture);
  }
}

class UpdateCPDPropertyBedrooms implements Action {
  final String PropertyBedrooms;

  UpdateCPDPropertyBedrooms(this.PropertyBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(PropertyBedrooms: PropertyBedrooms);
  }
}

class UpdateCPDPropertyBathrooms implements Action {
  final String PropertyBathrooms;

  UpdateCPDPropertyBathrooms(this.PropertyBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(PropertyBathrooms: PropertyBathrooms);
  }
}

class UpdateCPDPropertySizeinsquarefeet implements Action {
  final String PropertySizeinsquarefeet;

  UpdateCPDPropertySizeinsquarefeet(this.PropertySizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        PropertySizeinsquarefeet: PropertySizeinsquarefeet);
  }
}

class UpdateCPDPropertyMaxoccupancy implements Action {
  final String PropertyMaxoccupancy;

  UpdateCPDPropertyMaxoccupancy(this.PropertyMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        PropertyMaxoccupancy: PropertyMaxoccupancy);
  }
}

class UpdateCPDPropertyAmenitiesList implements Action {
  List<PropertyAmenitiesUtility> propertyamenitieslist;

  UpdateCPDPropertyAmenitiesList(this.propertyamenitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        PropertyAmenitieslist: propertyamenitieslist);
  }
}

class UpdateCPDPropertyUtilitiesList implements Action {
  List<PropertyAmenitiesUtility> propertyutilitieslist;

  UpdateCPDPropertyUtilitiesList(this.propertyutilitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        PropertyUtilitieslist: propertyutilitieslist);
  }
}

class UpdateCPDPropertyNotIncludedUtilitiesList implements Action {
  List<PropertyAmenitiesUtility> PropertyNotIncludedUtilitieslist;

  UpdateCPDPropertyNotIncludedUtilitiesList(
      this.PropertyNotIncludedUtilitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        PropertyNotIncludedUtilitieslist: PropertyNotIncludedUtilitieslist);
  }
}

class UpdateCPDStorageAvailableValue implements Action {
  final SystemEnumDetails? storageavailableValue;

  UpdateCPDStorageAvailableValue(this.storageavailableValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPropertyDetailsState(
        storageavailableValue: storageavailableValue);
  }
}

class UpdateCPDParkingstalls implements Action {
  final String Parkingstalls;

  UpdateCPDParkingstalls(this.Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Parkingstalls: Parkingstalls);
  }
}

class UpdateCPDAgreeTCPP implements Action {
  final bool agreeTCPP;

  UpdateCPDAgreeTCPP(this.agreeTCPP);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(agree_TCPP: agreeTCPP);
  }
}

class UpdateCPDpropertylist implements Action {
  final List<PropertyData> propertylist;

  UpdateCPDpropertylist(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(propertylist: propertylist);
  }
}

class UpdateCPDLead_firstname implements Action {
  final String Lead_firstname;

  UpdateCPDLead_firstname(this.Lead_firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Lead_firstname: Lead_firstname);
  }
}

class UpdateCPDLead_lastname implements Action {
  final String Lead_lastname;

  UpdateCPDLead_lastname(this.Lead_lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Lead_lastname: Lead_lastname);
  }
}

class UpdateCPDLead_email implements Action {
  final String Lead_email;

  UpdateCPDLead_email(this.Lead_email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Lead_email: Lead_email);
  }
}

class UpdateCPDLead_phone implements Action {
  final String Lead_phone;

  UpdateCPDLead_phone(this.Lead_phone);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Lead_phone: Lead_phone);
  }
}

class UpdateCPDLead_occupant implements Action {
  final String Lead_occupant;

  UpdateCPDLead_occupant(this.Lead_occupant);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Lead_occupant: Lead_occupant);
  }
}

class UpdateCPDLead_children implements Action {
  final String Lead_children;

  UpdateCPDLead_children(this.Lead_children);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Lead_children: Lead_children);
  }
}

class UpdateCPDLead_additionalInfo implements Action {
  final String Lead_additionalInfo;

  UpdateCPDLead_additionalInfo(this.Lead_additionalInfo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPropertyDetailsState(Lead_additionalInfo: Lead_additionalInfo);
  }
}

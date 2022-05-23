import 'dart:typed_data';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class Update_BtLease_lanOwnerId implements Action {
  final String lanOwnerId;

  Update_BtLease_lanOwnerId(this.lanOwnerId);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(lanOwnerId: lanOwnerId);
  }
}

class Update_BtLease_lan_name implements Action {
  final String lan_name;

  Update_BtLease_lan_name(this.lan_name);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(lan_name: lan_name);
  }
}

class Update_BtLease_lan_email implements Action {
  final String lan_email;

  Update_BtLease_lan_email(this.lan_email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(lan_email: lan_email);
  }
}

class Update_BtLease_lan_phoneno implements Action {
  final String lan_phoneno;

  Update_BtLease_lan_phoneno(this.lan_phoneno);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(lan_phoneno: lan_phoneno);
  }
}

class Update_BtLease_lan_Companyname implements Action {
  final String lan_Companyname;

  Update_BtLease_lan_Companyname(this.lan_Companyname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(lan_Companyname: lan_Companyname);
  }
}

class Update_BtLease_lan_Companyemail implements Action {
  final String lan_Companyemail;

  Update_BtLease_lan_Companyemail(this.lan_Companyemail);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(lan_Companyemail: lan_Companyemail);
  }
}

class Update_BtLease_ProperTytypeValue implements Action {
  final SystemEnumDetails? propertytypeValue;

  Update_BtLease_ProperTytypeValue(this.propertytypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(propertytypeValue: propertytypeValue);
  }
}

class Update_BtLease_PropertyTypeOtherValue implements Action {
  final String propertytypeOtherValue;

  Update_BtLease_PropertyTypeOtherValue(this.propertytypeOtherValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(propertytypeOtherValue: propertytypeOtherValue);
  }
}

class Update_BtLease_RentalSpaceValue implements Action {
  final SystemEnumDetails? rentalspaceValue;

  Update_BtLease_RentalSpaceValue(this.rentalspaceValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(rentalspaceValue: rentalspaceValue);
  }
}

class Update_BtLease_RentPaymentFrequencyValue implements Action {
  final SystemEnumDetails? rentpaymentFrequencyValue;

  Update_BtLease_RentPaymentFrequencyValue(this.rentpaymentFrequencyValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(
        rentpaymentFrequencyValue: rentpaymentFrequencyValue);
  }
}

class Update_BtLease_LeaseTypeValue implements Action {
  final SystemEnumDetails? leasetypeValue;

  Update_BtLease_LeaseTypeValue(this.leasetypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(leasetypeValue: leasetypeValue);
  }
}

class Update_BtLease_MinimumLeasedurationValue implements Action {
  final SystemEnumDetails? minimumleasedurationValue;

  Update_BtLease_MinimumLeasedurationValue(this.minimumleasedurationValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(
        minimumleasedurationValue: minimumleasedurationValue);
  }
}

class Update_BtLease_MinimumleasedurationNumber implements Action {
  final String minimumleasedurationnumber;

  Update_BtLease_MinimumleasedurationNumber(this.minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(
        minimumleasedurationnumber: minimumleasedurationnumber);
  }
}

class Update_BtLease_Dateofavailable implements Action {
  final DateTime? dateofavailable;

  Update_BtLease_Dateofavailable(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(dateofavailable: dateofavailable);
  }
}

class Update_BtLease_PropertyName implements Action {
  final String PropertyName;

  Update_BtLease_PropertyName(this.PropertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(PropertyName: PropertyName);
  }
}

class Update_BtLease_PropertyAddress implements Action {
  final String PropertyAddress;

  Update_BtLease_PropertyAddress(this.PropertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(PropertyAddress: PropertyAddress);
  }
}

class Update_BtLease_PropertyDescription implements Action {
  final String PropertyDescription;

  Update_BtLease_PropertyDescription(this.PropertyDescription);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(PropertyDescription: PropertyDescription);
  }
}

class Update_BtLease_Suiteunit implements Action {
  final String Suiteunit;

  Update_BtLease_Suiteunit(this.Suiteunit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(Suiteunit: Suiteunit);
  }
}

class Update_BtLease_Buildingname implements Action {
  final String Buildingname;

  Update_BtLease_Buildingname(this.Buildingname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(Buildingname: Buildingname);
  }
}

class Update_BtLease_PropertyCity implements Action {
  final String City;

  Update_BtLease_PropertyCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(City: City);
  }
}

class Update_BtLease_PropertyProvince implements Action {
  final String Province;

  Update_BtLease_PropertyProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(Province: Province);
  }
}

class Update_BtLease_PropertyCountryName implements Action {
  final String CountryName;

  Update_BtLease_PropertyCountryName(this.CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(CountryName: CountryName);
  }
}

class Update_BtLease_PropertyCountryCode implements Action {
  final String CountryCode;

  Update_BtLease_PropertyCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(CountryCode: CountryCode);
  }
}

class Update_BtLease_PropertyPostalcode implements Action {
  final String Postalcode;

  Update_BtLease_PropertyPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(Postalcode: Postalcode);
  }
}

class Update_BtLease_PropertyRentAmount implements Action {
  final String RentAmount;

  Update_BtLease_PropertyRentAmount(this.RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(RentAmount: RentAmount);
  }
}

class Update_BtLease_PropertyImage implements Action {
  final MediaInfo? propertyImage;

  Update_BtLease_PropertyImage(this.propertyImage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(propertyImage: propertyImage);
  }
}

class Update_BtLease_PropertyUint8List implements Action {
  final Uint8List? appimage;

  Update_BtLease_PropertyUint8List(this.appimage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(appimage: appimage);
  }
}

class Update_BtLease_PropertyDrafting implements Action {
  final int PropDrafting;

  Update_BtLease_PropertyDrafting(this.PropDrafting);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(PropDrafting: PropDrafting);
  }
}

class Update_BtLease_PropertyVacancy implements Action {
  final bool PropVacancy;

  Update_BtLease_PropertyVacancy(this.PropVacancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(PropVacancy: PropVacancy);
  }
}

class Update_BtLease_FurnishingValue implements Action {
  final SystemEnumDetails? furnishingValue;

  Update_BtLease_FurnishingValue(this.furnishingValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(furnishingValue: furnishingValue);
  }
}

class Update_BtLease_OtherPartialFurniture implements Action {
  final String Other_Partial_Furniture;

  Update_BtLease_OtherPartialFurniture(this.Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(Other_Partial_Furniture: Other_Partial_Furniture);
  }
}

class Update_BtLease_PropertyBedrooms implements Action {
  final String PropertyBedrooms;

  Update_BtLease_PropertyBedrooms(this.PropertyBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(PropertyBedrooms: PropertyBedrooms);
  }
}

class Update_BtLease_PropertyBathrooms implements Action {
  final String PropertyBathrooms;

  Update_BtLease_PropertyBathrooms(this.PropertyBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(PropertyBathrooms: PropertyBathrooms);
  }
}

class Update_BtLease_PropertySizeinsquarefeet implements Action {
  final String PropertySizeinsquarefeet;

  Update_BtLease_PropertySizeinsquarefeet(this.PropertySizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(PropertySizeinsquarefeet: PropertySizeinsquarefeet);
  }
}

class Update_BtLease_PropertyMaxoccupancy implements Action {
  final String PropertyMaxoccupancy;

  Update_BtLease_PropertyMaxoccupancy(this.PropertyMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(PropertyMaxoccupancy: PropertyMaxoccupancy);
  }
}

class Update_BtLease_StorageAvailableValue implements Action {
  final SystemEnumDetails? storageavailableValue;

  Update_BtLease_StorageAvailableValue(this.storageavailableValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(storageavailableValue: storageavailableValue);
  }
}

class Update_BtLease_Parkingstalls implements Action {
  final String Parkingstalls;

  Update_BtLease_Parkingstalls(this.Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(Parkingstalls: Parkingstalls);
  }
}

class Update_BtLease_AgreeTCPP implements Action {
  final bool agreeTCPP;

  Update_BtLease_AgreeTCPP(this.agreeTCPP);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(agree_TCPP: agreeTCPP);
  }
}

class Update_BtLease_PropertyImageList implements Action {
  final List<PropertyImageMediaInfo> propertyImagelist;

  Update_BtLease_PropertyImageList(this.propertyImagelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(SummerypropertyImagelist: propertyImagelist);
  }
}

class Update_BtLease_PropertyAmenitiesList implements Action {
  List<PropertyAmenitiesUtility> Summerypropertyamenitieslist;

  Update_BtLease_PropertyAmenitiesList(this.Summerypropertyamenitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(
        Summerypropertyamenitieslist: Summerypropertyamenitieslist);
  }
}

class Update_BtLease_PropertyUtilitiesList implements Action {
  List<PropertyAmenitiesUtility> Summerypropertyutilitieslist;

  Update_BtLease_PropertyUtilitiesList(this.Summerypropertyutilitieslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(
        Summerypropertyutilitieslist: Summerypropertyutilitieslist);
  }
}

class Update_BtLease_Restrictionlist implements Action {
  final List<SystemEnumDetails> restrictionlist;

  Update_BtLease_Restrictionlist(this.restrictionlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .leaseDetailsState(restrictionlist: restrictionlist);
  }
}

class Update_BtLease_MID implements Action {
  final String Lease_MID;

  Update_BtLease_MID(this.Lease_MID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(Lease_MID: Lease_MID);
  }
}

class Update_BtLease_MediaDoc implements Action {
  final MediaInfo? Lease_MediaDoc;

  Update_BtLease_MediaDoc(this.Lease_MediaDoc);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.leaseDetailsState(Lease_MediaDoc: Lease_MediaDoc);
  }
}

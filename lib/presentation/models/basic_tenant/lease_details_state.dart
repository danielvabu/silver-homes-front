import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'lease_details_state.freezed.dart';

@freezed
abstract class LeaseDetailsState with _$LeaseDetailsState {
  const factory LeaseDetailsState({
    /*OwnerDetails*/
    required String lanOwnerId,
    required String lan_name,
    required String lan_email,
    required String lan_phoneno,
    required String lan_Companyname,
    required String lan_Companyemail,

    /*Property Detals*/
    SystemEnumDetails? propertytypeValue,
    required String propertytypeOtherValue,
    SystemEnumDetails? rentalspaceValue,
    SystemEnumDetails? rentpaymentFrequencyValue,
    SystemEnumDetails? leasetypeValue,
    SystemEnumDetails? minimumleasedurationValue,
    required String minimumleasedurationnumber,
    DateTime? dateofavailable,
    required String PropertyName,
    required String PropertyAddress,
    required String PropertyDescription,
    required String Suiteunit,
    required String Buildingname,
    required String City,
    required String Province,
    required String CountryName,
    required String CountryCode,
    required String Postalcode,
    required String RentAmount,
    MediaInfo? propertyImage,
    Uint8List? appimage,

    /*Specification and Restriction*/
    SystemEnumDetails? furnishingValue,
    required List<SystemEnumDetails> restrictionlist,
    required String Other_Partial_Furniture,
    required String PropertyBedrooms,
    required String PropertyBathrooms,
    required String PropertySizeinsquarefeet,
    required String PropertyMaxoccupancy,

    /*Feature*/
    required List<PropertyAmenitiesUtility> Summerypropertyamenitieslist,
    required List<PropertyAmenitiesUtility> Summerypropertyutilitieslist,
    SystemEnumDetails? storageavailableValue,
    required String Parkingstalls,
    required bool agree_TCPP,
    required int PropDrafting,
    required bool PropVacancy,
    required List<PropertyImageMediaInfo> SummerypropertyImagelist,

    /*Lease*/
    required String Lease_MID,
    MediaInfo? Lease_MediaDoc,
  }) = _LeaseDetailsState;

  factory LeaseDetailsState.initial() => LeaseDetailsState(
        /*OwnerDetails*/
        lanOwnerId: "",
        lan_name: "",
        lan_email: "",
        lan_phoneno: "",
        lan_Companyname: "",
        lan_Companyemail: "",

        /*Property*/
        propertytypeValue: null,
        propertytypeOtherValue: "",
        rentalspaceValue: null,
        rentpaymentFrequencyValue: null,
        leasetypeValue: null,
        minimumleasedurationValue: null,
        minimumleasedurationnumber: "",
        dateofavailable: null,
        PropertyName: "",
        PropertyAddress: "",
        PropertyDescription: "",
        Suiteunit: "",
        Buildingname: "",
        City: "",
        Province: "",
        CountryName: "Canada",
        CountryCode: "CA",
        Postalcode: "",
        RentAmount: "",
        propertyImage: null,
        appimage: null,
        furnishingValue: null,
        restrictionlist: List.empty(),
        Other_Partial_Furniture: "",
        PropertyBedrooms: "",
        PropertyBathrooms: "",
        PropertySizeinsquarefeet: "",
        PropertyMaxoccupancy: "",
        Summerypropertyamenitieslist: List.empty(),
        Summerypropertyutilitieslist: List.empty(),
        storageavailableValue: null,
        Parkingstalls: "",
        agree_TCPP: false,
        PropDrafting: 0,
        PropVacancy: false,
        SummerypropertyImagelist: List.empty(),
        Lease_MID: "",
        Lease_MediaDoc: null,
      );
}

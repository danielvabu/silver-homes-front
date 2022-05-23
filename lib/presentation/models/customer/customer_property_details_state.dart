import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'customer_property_details_state.freezed.dart';

@freezed
abstract class CustomerPropertyDetailsState
    with _$CustomerPropertyDetailsState {
  const factory CustomerPropertyDetailsState({
    required String PropID,
    SystemEnumDetails? propertytypeValue,
    required String propertytypeOtherValue,
    SystemEnumDetails? rentalspaceValue,
    SystemEnumDetails? rentpaymentFrequencyValue,
    SystemEnumDetails? leasetypeValue,
    SystemEnumDetails? minimumleasedurationValue,
    required String minimumleasedurationnumber,
    required String dateofavailable,
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
    required List<PropertyImageMediaInfo> propertyImagelist,

    /*Specification and Restriction*/
    SystemEnumDetails? furnishingValue,
    required List<SystemEnumDetails> restrictionlist,
    required String Other_Partial_Furniture,
    required String PropertyBedrooms,
    required String PropertyBathrooms,
    required String PropertySizeinsquarefeet,
    required String PropertyMaxoccupancy,

    /*Feature*/
    required List<PropertyAmenitiesUtility> PropertyAmenitieslist,
    required List<PropertyAmenitiesUtility> PropertyUtilitieslist,
    required List<PropertyAmenitiesUtility> PropertyNotIncludedUtilitieslist,
    SystemEnumDetails? storageavailableValue,
    required String Parkingstalls,
    required bool agree_TCPP,
    required int PropDrafting,
    required bool PropVacancy,

    /*Similer Property*/
    required List<PropertyData> propertylist,

    /*Add Lead*/
    required String Lead_firstname,
    required String Lead_lastname,
    required String Lead_email,
    required String Lead_phone,
    required String Lead_occupant,
    required String Lead_children,
    required String Lead_additionalInfo,
  }) = _CustomerPropertyDetailsState;

  factory CustomerPropertyDetailsState.initial() =>
      CustomerPropertyDetailsState(
        PropID: "",
        propertytypeValue: null,
        propertytypeOtherValue: "",
        rentalspaceValue: null,
        rentpaymentFrequencyValue: null,
        leasetypeValue: null,
        minimumleasedurationValue: null,
        minimumleasedurationnumber: "",
        dateofavailable: "",
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
        RentAmount: "0",
        propertyImage: null,
        appimage: null,
        propertyImagelist: List.empty(),
        furnishingValue: null,
        restrictionlist: List.empty(),
        Other_Partial_Furniture: "",
        PropertyBedrooms: "",
        PropertyBathrooms: "",
        PropertySizeinsquarefeet: "",
        PropertyMaxoccupancy: "",
        PropertyAmenitieslist: List.empty(),
        PropertyUtilitieslist: List.empty(),
        PropertyNotIncludedUtilitieslist: List.empty(),
        storageavailableValue: null,
        Parkingstalls: "",
        agree_TCPP: false,
        PropDrafting: 0,
        PropVacancy: false,
        propertylist: List.empty(),
        Lead_firstname: "",
        Lead_lastname: "",
        Lead_email: "",
        Lead_phone: "",
        Lead_occupant: "0",
        Lead_children: "0",
        Lead_additionalInfo: "",
      );
}

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'admin_property_details_state.freezed.dart';

@freezed
abstract class AdminPropertyDetailsState with _$AdminPropertyDetailsState {
  const factory AdminPropertyDetailsState({
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
    required List<PropertyAmenitiesUtility> Summerypropertyamenitieslist,
    required List<PropertyAmenitiesUtility> Summerypropertyutilitieslist,
    SystemEnumDetails? storageavailableValue,
    required String Parkingstalls,
    required bool agree_TCPP,
    required int PropDrafting,
    required bool PropVacancy,
  }) = _AdminPropertyDetailsState;

  factory AdminPropertyDetailsState.initial() => AdminPropertyDetailsState(
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
        propertyImagelist: List.empty(),
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
      );
}

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'property_summery_state.freezed.dart';

@freezed
abstract class PropertySummeryState with _$PropertySummeryState {
  const factory PropertySummeryState({
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
  }) = _PropertySummeryState;

  factory PropertySummeryState.initial() => PropertySummeryState(
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
      );
}

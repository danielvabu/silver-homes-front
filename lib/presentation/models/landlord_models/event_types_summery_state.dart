import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
//import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'event_types_summery_state.freezed.dart';

@freezed
abstract class EventTypesSummeryState with _$EventTypesSummeryState {
  const factory EventTypesSummeryState({
    SystemEnumDetails? eventtypestypeValue,
    required String eventtypestypeOtherValue,
    SystemEnumDetails? rentalspaceValue,
    SystemEnumDetails? rentpaymentFrequencyValue,
    SystemEnumDetails? leasetypeValue,
    SystemEnumDetails? minimumleasedurationValue,
    required String minimumleasedurationnumber,
    DateTime? dateofavailable,
    required String EventTypesName,
    required String EventTypesAddress,
    required String EventTypesDescription,
    required String Suiteunit,
    required String Buildingname,
    required String City,
    required String Province,
    required String CountryName,
    required String CountryCode,
    required String Postalcode,
    required String RentAmount,
    MediaInfo? eventtypesImage,
    Uint8List? appimage,

    /*Specification and Restriction*/
    SystemEnumDetails? furnishingValue,
    required List<SystemEnumDetails> restrictionlist,
    required String Other_Partial_Furniture,
    required String EventTypesBedrooms,
    required String EventTypesBathrooms,
    required String EventTypesSizeinsquarefeet,
    required String EventTypesMaxoccupancy,

    /*Feature*/
    //required List<EventTypesAmenitiesUtility> Summeryeventtypesamenitieslist,
    //required List<EventTypesAmenitiesUtility> Summeryeventtypesutilitieslist,
    SystemEnumDetails? storageavailableValue,
    required String Parkingstalls,
    required bool agree_TCPP,
    required int PropDrafting,
    required bool PropVacancy,
    //required List<EventTypesImageMediaInfo> SummeryeventtypesImagelist,
  }) = _EventTypesSummeryState;

  factory EventTypesSummeryState.initial() => EventTypesSummeryState(
        eventtypestypeValue: null,
        eventtypestypeOtherValue: "",
        rentalspaceValue: null,
        rentpaymentFrequencyValue: null,
        leasetypeValue: null,
        minimumleasedurationValue: null,
        minimumleasedurationnumber: "",
        dateofavailable: null,
        EventTypesName: "",
        EventTypesAddress: "",
        EventTypesDescription: "",
        Suiteunit: "",
        Buildingname: "",
        City: "",
        Province: "",
        CountryName: "Canada",
        CountryCode: "CA",
        Postalcode: "",
        RentAmount: "",
        eventtypesImage: null,
        appimage: null,
        furnishingValue: null,
        restrictionlist: List.empty(),
        Other_Partial_Furniture: "",
        EventTypesBedrooms: "",
        EventTypesBathrooms: "",
        EventTypesSizeinsquarefeet: "",
        EventTypesMaxoccupancy: "",
        //Summeryeventtypesamenitieslist: List.empty(),
        //Summeryeventtypesutilitieslist: List.empty(),
        storageavailableValue: null,
        Parkingstalls: "",
        agree_TCPP: false,
        PropDrafting: 0,
        PropVacancy: false,
        //SummeryeventtypesImagelist: List.empty(),
      );
}

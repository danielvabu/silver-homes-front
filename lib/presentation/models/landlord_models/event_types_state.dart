import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
//import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'event_types_state.freezed.dart';

@freezed
abstract class EventTypesState with _$EventTypesState {
  const factory EventTypesState({
    required List<EventTypesTemplate> eventtypestypelist,
    EventTypesTemplate? eventtypestypeValue,
    required String eventtypestypeOtherValue,
    required List rentalspacelist,
    SystemEnumDetails? rentalspaceValue,
    required List<SystemEnumDetails> rentpaymentFrequencylist,
    SystemEnumDetails? rentpaymentFrequencyValue,
    required List<SystemEnumDetails> leasetypelist,
    SystemEnumDetails? leasetypeValue,
    required List<SystemEnumDetails> minimumleasedurationlist,
    SystemEnumDetails? minimumleasedurationValue,
    required List<PropertyDropData> PropertyDropDatalist,
    PropertyDropData? selectproperty,
    required String minimumleasedurationnumber,
    DateTime? dateofavailable,
    required String EventTypesName,
    required bool EventTypesRelation,
    required String EventTypesAddress,
    required String EventTypesDescription,
    required bool EventTypesShowing,
    required String EventTypesLocation,
    required bool EventTypesNA,
    required bool EventTypesSPA,
    required String EventTypesLink,
    required String EventTypesColor,
    required int EventTypesRange,
    required String EventTypesFrom,
    required String EventTypesTo,
    required int EventTypesDuration,
    required String EventTypesDurationPeriod,
    required int EventTypesBefore,
    required int EventTypesAfter,
    required String EventTypesBeforePeriod,
    required String EventTypesAfterPeriod,
    required String EventTypesConfirmation,
    DateTime? datefrom,
    DateTime? dateto,
    required String timezone,
    required int displaytz,
    required bool sun,
    required bool mon,
    required bool tue,
    required bool wed,
    required bool thu,
    required bool fri,
    required bool sat,
    required List sunh1,
    required List sunh2,
    required List monh1,
    required List monh2,
    required List tueh1,
    required List tueh2,
    required List wedh1,
    required List wedh2,
    required List thuh1,
    required List thuh2,
    required List frih1,
    required List frih2,
    required List sath1,
    required List sath2,
    required int timescheduling,
    required String timeschedulingmed,
    required int maximum,
    required List overrrides,
    required String Suiteunit,
    required String Buildingname,
    required String City,
    required String Province,
    required String CountryName,
    required String CountryCode,
    required String Postalcode,
    required String RentAmount,

    /*Specification and Restriction*/
    required List<SystemEnumDetails> furnishinglist,
    SystemEnumDetails? furnishingValue,
    required List<SystemEnumDetails> restrictionlist,
    required String Other_Partial_Furniture,
    required String EventTypesBedrooms,
    required String EventTypesBathrooms,
    required String EventTypesSizeinsquarefeet,
    required String EventTypesMaxoccupancy,

    /*Feature*/
    //required List<EventTypesAmenitiesUtility> eventtypesamenitieslist,
    //required List<EventTypesAmenitiesUtility> eventtypesutilitieslist,
    required List<SystemEnumDetails> storageavailablelist,
    SystemEnumDetails? storageavailableValue,
    required String Parkingstalls,
    required bool agree_TCPP,
    required int PropDrafting,
    required bool PropVacancy,
    //required List<EventTypesImageMediaInfo> eventtypesImagelist,

    /*Error Flag*/
    required bool error_eventtypestype,
    required bool error_eventtypestypeOther,
    required bool error_rentalspace,
    required bool error_rentpaymentFrequency,
    required bool error_leasetype,
    required bool error_minimumleaseduration,
    required bool error_minimumleasedurationnumber,
    required bool error_dateofavailable,
    required bool error_EventTypesName,
    required bool error_EventTypesAddress,
    required bool error_City,
    required bool error_Province,
    required bool error_CountryName,
    required bool error_Postalcode,
    required bool error_RentAmount,
    required bool error_furnishing,
    required bool error_Other_Partial_Furniture,
    required bool error_EventTypesBedrooms,
    required bool error_EventTypesBathrooms,
    required bool error_EventTypesSizeinsquarefeet,
    required bool error_EventTypesMaxoccupancy,
    required bool error_storageavailable,
    required bool error_Parkingstalls,
  }) = _EventTypesState;

  factory EventTypesState.initial() => EventTypesState(
        eventtypestypelist: List.empty(),
        eventtypestypeValue: null,
        eventtypestypeOtherValue: "",
        rentalspacelist: List.empty(),
        rentalspaceValue: null,
        rentpaymentFrequencylist: List.empty(),
        rentpaymentFrequencyValue: null,
        leasetypelist: List.empty(),
        leasetypeValue: null,
        minimumleasedurationlist: List.empty(),
        minimumleasedurationValue: null,
        PropertyDropDatalist: List.empty(),
        selectproperty: null,
        minimumleasedurationnumber: "",
        dateofavailable: null,
        EventTypesName: "",
        EventTypesRelation: false,
        EventTypesAddress: "",
        EventTypesDescription: "",
        EventTypesShowing: false,
        EventTypesLocation: "",
        EventTypesNA: false,
        EventTypesSPA: false,
        EventTypesLink: "",
        EventTypesColor: "",
        EventTypesRange: 0,
        EventTypesFrom: "",
        EventTypesTo: "",
        timezone: "Pacific Time",
        displaytz: 0,
        sun: false,
        mon: false,
        tue: false,
        wed: false,
        thu: false,
        fri: false,
        sat: false,
        sunh1: [""],
        sunh2: [""],
        monh1: [""],
        monh2: [""],
        tueh1: [""],
        tueh2: [""],
        wedh1: [""],
        wedh2: [""],
        thuh1: [""],
        thuh2: [""],
        frih1: [""],
        frih2: [""],
        sath1: [""],
        sath2: [""],
        timescheduling: 0,
        timeschedulingmed: 'minutes',
        maximum: 0,
        overrrides: [],
        EventTypesDuration: 0,
        EventTypesDurationPeriod: "minutes",
        EventTypesBefore: 0,
        EventTypesAfter: 0,
        EventTypesBeforePeriod: "minutes",
        EventTypesAfterPeriod: "minutes",
        EventTypesConfirmation: "",
        datefrom: null,
        dateto: null,
        Suiteunit: "",
        Buildingname: "",
        City: "",
        Province: "",
        CountryName: "Canada",
        CountryCode: "CA",
        Postalcode: "",
        RentAmount: "",
        furnishinglist: List.empty(),
        furnishingValue: null,
        restrictionlist: List.empty(),
        Other_Partial_Furniture: "",
        EventTypesBedrooms: "",
        EventTypesBathrooms: "",
        EventTypesSizeinsquarefeet: "",
        EventTypesMaxoccupancy: "",
        //eventtypesamenitieslist: List.empty(),
        //eventtypesutilitieslist: List.empty(),
        storageavailablelist: List.empty(),
        storageavailableValue: null,
        Parkingstalls: "",
        agree_TCPP: false,
        PropDrafting: 0,
        PropVacancy: false,
        //eventtypesImagelist: List.empty(),

        /*Error Flag*/
        error_eventtypestype: false,
        error_eventtypestypeOther: false,
        error_rentalspace: false,
        error_rentpaymentFrequency: false,
        error_leasetype: false,
        error_minimumleaseduration: false,
        error_minimumleasedurationnumber: false,
        error_dateofavailable: false,
        error_EventTypesName: false,
        error_EventTypesAddress: false,
        error_City: false,
        error_Province: false,
        error_CountryName: false,
        error_Postalcode: false,
        error_RentAmount: false,
        error_furnishing: false,
        error_Other_Partial_Furniture: false,
        error_EventTypesBedrooms: false,
        error_EventTypesBathrooms: false,
        error_EventTypesSizeinsquarefeet: false,
        error_EventTypesMaxoccupancy: false,
        error_storageavailable: false,
        error_Parkingstalls: false,
      );
}

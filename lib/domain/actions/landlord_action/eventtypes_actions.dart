import 'dart:async';

import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateProperTytypeList implements Action {
  final List<SystemEnumDetails> eventtypestypelist;

  UpdateProperTytypeList(this.eventtypestypelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(eventtypestypelist: eventtypestypelist);
  }
}

class UpdateProperTytypeValue implements Action {
  final SystemEnumDetails? eventtypestypeValue;

  UpdateProperTytypeValue(this.eventtypestypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(eventtypestypeValue: eventtypestypeValue);
  }
}

class UpdateEventTypesTypeOtherValue implements Action {
  final String eventtypestypeOtherValue;

  UpdateEventTypesTypeOtherValue(this.eventtypestypeOtherValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(eventtypestypeOtherValue: eventtypestypeOtherValue);
  }
}

class UpdateRentalSpaceList implements Action {
  final List<SystemEnumDetails> rentalspacelist;

  UpdateRentalSpaceList(this.rentalspacelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(rentalspacelist: rentalspacelist);
  }
}

class UpdateRentalSpaceValue implements Action {
  final SystemEnumDetails? rentalspaceValue;

  UpdateRentalSpaceValue(this.rentalspaceValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(rentalspaceValue: rentalspaceValue);
  }
}

class UpdateRentPaymentFrequencylist implements Action {
  final List<SystemEnumDetails> rentpaymentFrequencylist;

  UpdateRentPaymentFrequencylist(this.rentpaymentFrequencylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(rentpaymentFrequencylist: rentpaymentFrequencylist);
  }
}

class UpdateRentPaymentFrequencyValue implements Action {
  final SystemEnumDetails? rentpaymentFrequencyValue;

  UpdateRentPaymentFrequencyValue(this.rentpaymentFrequencyValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(rentpaymentFrequencyValue: rentpaymentFrequencyValue);
  }
}

class UpdateLeaseTypeList implements Action {
  final List<SystemEnumDetails> leasetypelist;

  UpdateLeaseTypeList(this.leasetypelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(leasetypelist: leasetypelist);
  }
}

class UpdateLeaseTypeValue implements Action {
  final SystemEnumDetails? leasetypeValue;

  UpdateLeaseTypeValue(this.leasetypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(leasetypeValue: leasetypeValue);
  }
}

class UpdateMER_PropertyDropDatalist implements Action {
  final List<PropertyDropData> PropertyDropDatalist;

  UpdateMER_PropertyDropDatalist(this.PropertyDropDatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .editMaintenanceState(PropertyDropDatalist: PropertyDropDatalist);
  }
}

class UpdateMER_selectproperty implements Action {
  final PropertyDropData? selectproperty;

  UpdateMER_selectproperty(this.selectproperty);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(selectproperty: selectproperty);
  }
}

class UpdateNotAplicable implements Action {
  final bool EventTypesNA;

  UpdateNotAplicable(this.EventTypesNA);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(EventTypesNA: EventTypesNA);
  }
}

class UpdateLocation implements Action {
  final String EventTypesLocation;

  UpdateLocation(this.EventTypesLocation);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesLocation: EventTypesLocation);
  }
}

class UpdateSPA implements Action {
  final bool EventTypesSPA;

  UpdateSPA(this.EventTypesSPA);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(EventTypesSPA: EventTypesSPA);
  }
}

class UpdateDuration implements Action {
  final int EventTypesDuration;

  UpdateDuration(this.EventTypesDuration);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesDuration: EventTypesDuration);
  }
}

class UpdateBefore implements Action {
  final int EventTypesBefore;

  UpdateBefore(this.EventTypesBefore);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesBefore: EventTypesBefore);
  }
}

class UpdateMAR_PropertyDropDatalist implements Action {
  final List<PropertyDropData> PropertyDropDatalist;

  UpdateMAR_PropertyDropDatalist(this.PropertyDropDatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(PropertyDropDatalist: PropertyDropDatalist);
  }
}

class UpdateMinimumLeasedurationList implements Action {
  final List<SystemEnumDetails> minimumleasedurationlist;

  UpdateMinimumLeasedurationList(this.minimumleasedurationlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(minimumleasedurationlist: minimumleasedurationlist);
  }
}

class Updatsunh1 implements Action {
  final List<String> sunh1List;

  Updatsunh1(this.sunh1List);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(sunh1: sunh1List);
  }
}

class Updatsunh2 implements Action {
  final List<String> sunh2List;

  Updatsunh2(this.sunh2List);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(sunh2: sunh2List);
  }
}

class Updatmonh1 implements Action {
  final List<String> monh1List;

  Updatmonh1(this.monh1List);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(monh1: monh1List);
  }
}

class Updatmonh2 implements Action {
  final List<String> monh2List;

  Updatmonh2(this.monh2List);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(monh2: monh2List);
  }
}

class Updattueh1 implements Action {
  final List<String> val;

  Updattueh1(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(tueh1: val);
  }
}

class Updattueh2 implements Action {
  final List<String> val;

  Updattueh2(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(tueh2: val);
  }
}

class Updatwedh1 implements Action {
  final List<String> val;

  Updatwedh1(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(wedh1: val);
  }
}

class Updatwedh2 implements Action {
  final List<String> val;

  Updatwedh2(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(wedh2: val);
  }
}

class Updatthuh1 implements Action {
  final List<String> val;

  Updatthuh1(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(thuh1: val);
  }
}

class Updatthuh2 implements Action {
  final List<String> val;

  Updatthuh2(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(thuh2: val);
  }
}

class Updatfrih1 implements Action {
  final List<String> val;

  Updatfrih1(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(frih1: val);
  }
}

class Updatfrih2 implements Action {
  final List<String> val;

  Updatfrih2(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(frih2: val);
  }
}

class Updatsath1 implements Action {
  final List<String> val;

  Updatsath1(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(sath1: val);
  }
}

class Updatsath2 implements Action {
  final List<String> val;

  Updatsath2(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(sath2: val);
  }
}

class UpdateDurationp implements Action {
  final String durationmed;

  UpdateDurationp(this.durationmed);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesDurationPeriod: durationmed);
  }
}

class UpdateTimezon implements Action {
  final String timez;

  UpdateTimezon(this.timez);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(timezone: timez);
  }
}

class UpdateSun implements Action {
  final bool upsun;

  UpdateSun(this.upsun);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(sun: upsun);
  }
}

class UpdateMon implements Action {
  final bool val;

  UpdateMon(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(mon: val);
  }
}

class Updatetue implements Action {
  final bool val;

  Updatetue(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(tue: val);
  }
}

class Updatewed implements Action {
  final bool val;

  Updatewed(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(wed: val);
  }
}

class Updatethu implements Action {
  final bool val;

  Updatethu(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(thu: val);
  }
}

class Updatefri implements Action {
  final bool val;

  Updatefri(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(fri: val);
  }
}

class Updatesat implements Action {
  final bool val;

  Updatesat(this.val);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(sat: val);
  }
}

class UpdateBeforep implements Action {
  final String durationmed;

  UpdateBeforep(this.durationmed);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesBeforePeriod: durationmed);
  }
}

class UpdateDisplaytz implements Action {
  final int displayyt;

  UpdateDisplaytz(this.displayyt);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(displaytz: displayyt);
  }
}

class UpdateAfterp implements Action {
  final String durationmed;

  UpdateAfterp(this.durationmed);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesAfterPeriod: durationmed);
  }
}

class UpdateAfter implements Action {
  final int durationmed;

  UpdateAfter(this.durationmed);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(EventTypesAfter: durationmed);
  }
}

class Updatetimescheduling implements Action {
  final int time;

  Updatetimescheduling(this.time);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(timescheduling: time);
  }
}

class Updatetimeschedulingmed implements Action {
  final String time;

  Updatetimeschedulingmed(this.time);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(timeschedulingmed: time);
  }
}

class Updatemaximum implements Action {
  final int max;

  Updatemaximum(this.max);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(maximum: max);
  }
}

class UpdateMinimumleasedurationNumber implements Action {
  final String minimumleasedurationnumber;

  UpdateMinimumleasedurationNumber(this.minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(
        minimumleasedurationnumber: minimumleasedurationnumber);
  }
}

class UpdateDateofavailable implements Action {
  final DateTime? dateofavailable;

  UpdateDateofavailable(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(dateofavailable: dateofavailable);
  }
}

class UpdateDateto implements Action {
  final DateTime? dateofavailable;

  UpdateDateto(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(dateto: dateofavailable);
  }
}

class UpdateDatefrom implements Action {
  final DateTime? dateofavailable;

  UpdateDatefrom(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(datefrom: dateofavailable);
  }
}

class UpdateEventTypesName implements Action {
  final String EventTypesName;

  UpdateEventTypesName(this.EventTypesName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(EventTypesName: EventTypesName);
  }
}

class UpdateEventTypesRelations implements Action {
  final bool EventTypesRelations;

  UpdateEventTypesRelations(this.EventTypesRelations);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesRelation: EventTypesRelations);
  }
}

class UpdateEventTypesShowing implements Action {
  final bool EventTypesShowing;

  UpdateEventTypesShowing(this.EventTypesShowing);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesShowing: EventTypesShowing);
  }
}

class UpdateEventTypesAddress implements Action {
  final String EventTypesAddress;

  UpdateEventTypesAddress(this.EventTypesAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesAddress: EventTypesAddress);
  }
}

class UpdateEventTypesDescription implements Action {
  final String EventTypesDescription;

  UpdateEventTypesDescription(this.EventTypesDescription);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesDescription: EventTypesDescription);
  }
}

class UpdateEventTypesConfirmation implements Action {
  final String EventTypesConfirmation;

  UpdateEventTypesConfirmation(this.EventTypesConfirmation);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(EventTypesConfirmation: EventTypesConfirmation);
  }
}

class UpdateURL implements Action {
  final String EventTypesLink;

  UpdateURL(this.EventTypesLink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(EventTypesLink: EventTypesLink);
  }
}

class UpdateEventTypesColor implements Action {
  final String EventTypesColor;

  UpdateEventTypesColor(this.EventTypesColor);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(EventTypesColor: EventTypesColor);
  }
}

class UpdateEventTypesRanges implements Action {
  final int EventTypesRange;

  UpdateEventTypesRanges(this.EventTypesRange);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(EventTypesRange: EventTypesRange);
  }
}

class UpdateSuiteunit implements Action {
  final String Suiteunit;

  UpdateSuiteunit(this.Suiteunit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(Suiteunit: Suiteunit);
  }
}

class UpdateBuildingname implements Action {
  final String Buildingname;

  UpdateBuildingname(this.Buildingname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(Buildingname: Buildingname);
  }
}

class UpdateEventTypesCity implements Action {
  final String City;

  UpdateEventTypesCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(City: City);
  }
}

class UpdateEventTypesProvince implements Action {
  final String Province;

  UpdateEventTypesProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(Province: Province);
  }
}

class UpdateEventTypesCountryName implements Action {
  final String CountryName;

  UpdateEventTypesCountryName(this.CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(CountryName: CountryName);
  }
}

class UpdateEventTypesCountryCode implements Action {
  final String CountryCode;

  UpdateEventTypesCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(CountryCode: CountryCode);
  }
}

class UpdateEventTypesPostalcode implements Action {
  final String Postalcode;

  UpdateEventTypesPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(Postalcode: Postalcode);
  }
}

class UpdateEventTypesRentAmount implements Action {
  final String RentAmount;

  UpdateEventTypesRentAmount(this.RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(RentAmount: RentAmount);
  }
}

class UpdateEventTypesDrafting implements Action {
  final int PropDrafting;

  UpdateEventTypesDrafting(this.PropDrafting);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(PropDrafting: PropDrafting);
  }
}

class UpdateEventTypesVacancy implements Action {
  final bool PropVacancy;

  UpdateEventTypesVacancy(this.PropVacancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(PropVacancy: PropVacancy);
  }
}

class UpdateErrorEventTypestype implements Action {
  final bool error_eventtypestype;

  UpdateErrorEventTypestype(this.error_eventtypestype);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_eventtypestype: error_eventtypestype);
  }
}

class UpdateErrorEventTypestypeOther implements Action {
  final bool error_eventtypestypeOther;

  UpdateErrorEventTypestypeOther(this.error_eventtypestypeOther);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_eventtypestypeOther: error_eventtypestypeOther);
  }
}

class UpdateErrorRentalspace implements Action {
  final bool error_rentalspace;

  UpdateErrorRentalspace(this.error_rentalspace);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_rentalspace: error_rentalspace);
  }
}

class UpdateErrorRentpaymentFrequency implements Action {
  final bool error_rentpaymentFrequency;

  UpdateErrorRentpaymentFrequency(this.error_rentpaymentFrequency);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(
        error_rentpaymentFrequency: error_rentpaymentFrequency);
  }
}

class UpdateErrorLeasetype implements Action {
  final bool error_leasetype;

  UpdateErrorLeasetype(this.error_leasetype);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(error_leasetype: error_leasetype);
  }
}

class UpdateErrorMinimumleaseduration implements Action {
  final bool error_minimumleaseduration;

  UpdateErrorMinimumleaseduration(this.error_minimumleaseduration);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(
        error_minimumleaseduration: error_minimumleaseduration);
  }
}

class UpdateErrorMinimumleasedurationnumber implements Action {
  final bool error_minimumleasedurationnumber;

  UpdateErrorMinimumleasedurationnumber(this.error_minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(
        error_minimumleasedurationnumber: error_minimumleasedurationnumber);
  }
}

class UpdateErrorDateofavailable implements Action {
  final bool error_dateofavailable;

  UpdateErrorDateofavailable(this.error_dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_dateofavailable: error_dateofavailable);
  }
}

class UpdateErrorEventTypesName implements Action {
  final bool error_EventTypesName;

  UpdateErrorEventTypesName(this.error_EventTypesName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_EventTypesName: error_EventTypesName);
  }
}

class UpdateErrorEventTypesAddress implements Action {
  final bool error_EventTypesAddress;

  UpdateErrorEventTypesAddress(this.error_EventTypesAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_EventTypesAddress: error_EventTypesAddress);
  }
}

class UpdateErrorCity implements Action {
  final bool error_City;

  UpdateErrorCity(this.error_City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(error_City: error_City);
  }
}

class UpdateErrorProvince implements Action {
  final bool error_Province;

  UpdateErrorProvince(this.error_Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(error_Province: error_Province);
  }
}

class UpdateErrorCountryName implements Action {
  final bool error_CountryName;

  UpdateErrorCountryName(this.error_CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_CountryName: error_CountryName);
  }
}

class UpdateErrorPostalcode implements Action {
  final bool error_Postalcode;

  UpdateErrorPostalcode(this.error_Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_Postalcode: error_Postalcode);
  }
}

class UpdateErrorRentAmount implements Action {
  final bool error_RentAmount;

  UpdateErrorRentAmount(this.error_RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_RentAmount: error_RentAmount);
  }
}

class UpdateErrorFurnishing implements Action {
  final bool error_furnishing;

  UpdateErrorFurnishing(this.error_furnishing);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_furnishing: error_furnishing);
  }
}

class UpdateErrorOther_Partial_Furniture implements Action {
  final bool error_Other_Partial_Furniture;

  UpdateErrorOther_Partial_Furniture(this.error_Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(
        error_Other_Partial_Furniture: error_Other_Partial_Furniture);
  }
}

class UpdateErrorEventTypesBedrooms implements Action {
  final bool error_EventTypesBedrooms;

  UpdateErrorEventTypesBedrooms(this.error_EventTypesBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_EventTypesBedrooms: error_EventTypesBedrooms);
  }
}

class UpdateErrorEventTypesBathrooms implements Action {
  final bool error_EventTypesBathrooms;

  UpdateErrorEventTypesBathrooms(this.error_EventTypesBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_EventTypesBathrooms: error_EventTypesBathrooms);
  }
}

class UpdateErrorEventTypesSizeinsquarefeet implements Action {
  final bool error_EventTypesSizeinsquarefeet;

  UpdateErrorEventTypesSizeinsquarefeet(this.error_EventTypesSizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(
        error_EventTypesSizeinsquarefeet: error_EventTypesSizeinsquarefeet);
  }
}

class UpdateErrorEventTypesMaxoccupancy implements Action {
  final bool error_EventTypesMaxoccupancy;

  UpdateErrorEventTypesMaxoccupancy(this.error_EventTypesMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventTypesState(
        error_EventTypesMaxoccupancy: error_EventTypesMaxoccupancy);
  }
}

class UpdateErrorStorageavailable implements Action {
  final bool error_storageavailable;

  UpdateErrorStorageavailable(this.error_storageavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_storageavailable: error_storageavailable);
  }
}

class UpdateErrorParkingstalls implements Action {
  final bool error_Parkingstalls;

  UpdateErrorParkingstalls(this.error_Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventTypesState(error_Parkingstalls: error_Parkingstalls);
  }
}

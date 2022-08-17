import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateEventTypesList implements Action {
  final List<SystemEnumDetails> eventtypeslist;

  UpdateEventTypesList(this.eventtypeslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(eventtypeslist: eventtypeslist);
  }
}

class UpdateEventTypesValue implements Action {
  final SystemEnumDetails? eventtypesValue;

  UpdateEventTypesValue(this.eventtypesValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(eventtypesValue: eventtypesValue);
  }
}

class UpdatePropertyTypeOtherValue implements Action {
  final String eventtypesOtherValue;

  UpdatePropertyTypeOtherValue(this.eventtypesOtherValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(eventtypesOtherValue: eventtypesOtherValue);
  }
}

class UpdateRentalSpaceList implements Action {
  final List<SystemEnumDetails> rentalspacelist;

  UpdateRentalSpaceList(this.rentalspacelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(rentalspacelist: rentalspacelist);
  }
}

class UpdateRentalSpaceValue implements Action {
  final SystemEnumDetails? rentalspaceValue;

  UpdateRentalSpaceValue(this.rentalspaceValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(rentalspaceValue: rentalspaceValue);
  }
}

class UpdateRentPaymentFrequencylist implements Action {
  final List<SystemEnumDetails> rentpaymentFrequencylist;

  UpdateRentPaymentFrequencylist(this.rentpaymentFrequencylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(rentpaymentFrequencylist: rentpaymentFrequencylist);
  }
}

class UpdateRentPaymentFrequencyValue implements Action {
  final SystemEnumDetails? rentpaymentFrequencyValue;

  UpdateRentPaymentFrequencyValue(this.rentpaymentFrequencyValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(rentpaymentFrequencyValue: rentpaymentFrequencyValue);
  }
}

class UpdateLeaseTypeList implements Action {
  final List<SystemEnumDetails> leasetypelist;

  UpdateLeaseTypeList(this.leasetypelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(leasetypelist: leasetypelist);
  }
}

class UpdateLeaseTypeValue implements Action {
  final SystemEnumDetails? leasetypeValue;

  UpdateLeaseTypeValue(this.leasetypeValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(leasetypeValue: leasetypeValue);
  }
}

class UpdateMinimumLeasedurationList implements Action {
  final List<SystemEnumDetails> minimumleasedurationlist;

  UpdateMinimumLeasedurationList(this.minimumleasedurationlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(minimumleasedurationlist: minimumleasedurationlist);
  }
}

class UpdateMinimumLeasedurationValue implements Action {
  final SystemEnumDetails? minimumleasedurationValue;

  UpdateMinimumLeasedurationValue(this.minimumleasedurationValue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(minimumleasedurationValue: minimumleasedurationValue);
  }
}

class UpdateMinimumleasedurationNumber implements Action {
  final String minimumleasedurationnumber;

  UpdateMinimumleasedurationNumber(this.minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(minimumleasedurationnumber: minimumleasedurationnumber);
  }
}

class UpdateDateofavailable implements Action {
  final DateTime? dateofavailable;

  UpdateDateofavailable(this.dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(dateofavailable: dateofavailable);
  }
}

class UpdatePropertyName implements Action {
  final String PropertyName;

  UpdatePropertyName(this.PropertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(PropertyName: PropertyName);
  }
}

class UpdatePropertyAddress implements Action {
  final String PropertyAddress;

  UpdatePropertyAddress(this.PropertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(PropertyAddress: PropertyAddress);
  }
}

class UpdatePropertyDescription implements Action {
  final String PropertyDescription;

  UpdatePropertyDescription(this.PropertyDescription);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(PropertyDescription: PropertyDescription);
  }
}

class UpdateSuiteunit implements Action {
  final String Suiteunit;

  UpdateSuiteunit(this.Suiteunit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(Suiteunit: Suiteunit);
  }
}

class UpdateBuildingname implements Action {
  final String Buildingname;

  UpdateBuildingname(this.Buildingname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(Buildingname: Buildingname);
  }
}

class UpdatePropertyCity implements Action {
  final String City;

  UpdatePropertyCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(City: City);
  }
}

class UpdatePropertyProvince implements Action {
  final String Province;

  UpdatePropertyProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(Province: Province);
  }
}

class UpdatePropertyCountryName implements Action {
  final String CountryName;

  UpdatePropertyCountryName(this.CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(CountryName: CountryName);
  }
}

class UpdatePropertyCountryCode implements Action {
  final String CountryCode;

  UpdatePropertyCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(CountryCode: CountryCode);
  }
}

class UpdatePropertyPostalcode implements Action {
  final String Postalcode;

  UpdatePropertyPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(Postalcode: Postalcode);
  }
}

class UpdatePropertyRentAmount implements Action {
  final String RentAmount;

  UpdatePropertyRentAmount(this.RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(RentAmount: RentAmount);
  }
}

class UpdatePropertyDrafting implements Action {
  final int PropDrafting;

  UpdatePropertyDrafting(this.PropDrafting);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(PropDrafting: PropDrafting);
  }
}

class UpdatePropertyVacancy implements Action {
  final bool PropVacancy;

  UpdatePropertyVacancy(this.PropVacancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(PropVacancy: PropVacancy);
  }
}

class UpdateErrorPropertytype implements Action {
  final bool error_eventtypes;

  UpdateErrorPropertytype(this.error_eventtypes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_eventtypes: error_eventtypes);
  }
}

class UpdateErrorPropertytypeOther implements Action {
  final bool error_eventtypesOther;

  UpdateErrorPropertytypeOther(this.error_eventtypesOther);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_eventtypesOther: error_eventtypesOther);
  }
}

class UpdateErrorRentalspace implements Action {
  final bool error_rentalspace;

  UpdateErrorRentalspace(this.error_rentalspace);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_rentalspace: error_rentalspace);
  }
}

class UpdateErrorRentpaymentFrequency implements Action {
  final bool error_rentpaymentFrequency;

  UpdateErrorRentpaymentFrequency(this.error_rentpaymentFrequency);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_rentpaymentFrequency: error_rentpaymentFrequency);
  }
}

class UpdateErrorLeasetype implements Action {
  final bool error_leasetype;

  UpdateErrorLeasetype(this.error_leasetype);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(error_leasetype: error_leasetype);
  }
}

class UpdateErrorMinimumleaseduration implements Action {
  final bool error_minimumleaseduration;

  UpdateErrorMinimumleaseduration(this.error_minimumleaseduration);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_minimumleaseduration: error_minimumleaseduration);
  }
}

class UpdateErrorMinimumleasedurationnumber implements Action {
  final bool error_minimumleasedurationnumber;

  UpdateErrorMinimumleasedurationnumber(this.error_minimumleasedurationnumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(
        error_minimumleasedurationnumber: error_minimumleasedurationnumber);
  }
}

class UpdateErrorDateofavailable implements Action {
  final bool error_dateofavailable;

  UpdateErrorDateofavailable(this.error_dateofavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_dateofavailable: error_dateofavailable);
  }
}

class UpdateErrorPropertyName implements Action {
  final bool error_PropertyName;

  UpdateErrorPropertyName(this.error_PropertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_PropertyName: error_PropertyName);
  }
}

class UpdateErrorPropertyAddress implements Action {
  final bool error_PropertyAddress;

  UpdateErrorPropertyAddress(this.error_PropertyAddress);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_PropertyAddress: error_PropertyAddress);
  }
}

class UpdateErrorCity implements Action {
  final bool error_City;

  UpdateErrorCity(this.error_City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(error_City: error_City);
  }
}

class UpdateErrorProvince implements Action {
  final bool error_Province;

  UpdateErrorProvince(this.error_Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(error_Province: error_Province);
  }
}

class UpdateErrorCountryName implements Action {
  final bool error_CountryName;

  UpdateErrorCountryName(this.error_CountryName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_CountryName: error_CountryName);
  }
}

class UpdateErrorPostalcode implements Action {
  final bool error_Postalcode;

  UpdateErrorPostalcode(this.error_Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(error_Postalcode: error_Postalcode);
  }
}

class UpdateErrorRentAmount implements Action {
  final bool error_RentAmount;

  UpdateErrorRentAmount(this.error_RentAmount);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(error_RentAmount: error_RentAmount);
  }
}

class UpdateErrorFurnishing implements Action {
  final bool error_furnishing;

  UpdateErrorFurnishing(this.error_furnishing);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(error_furnishing: error_furnishing);
  }
}

class UpdateErrorOther_Partial_Furniture implements Action {
  final bool error_Other_Partial_Furniture;

  UpdateErrorOther_Partial_Furniture(this.error_Other_Partial_Furniture);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(
        error_Other_Partial_Furniture: error_Other_Partial_Furniture);
  }
}

class UpdateErrorPropertyBedrooms implements Action {
  final bool error_PropertyBedrooms;

  UpdateErrorPropertyBedrooms(this.error_PropertyBedrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_PropertyBedrooms: error_PropertyBedrooms);
  }
}

class UpdateErrorPropertyBathrooms implements Action {
  final bool error_PropertyBathrooms;

  UpdateErrorPropertyBathrooms(this.error_PropertyBathrooms);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_PropertyBathrooms: error_PropertyBathrooms);
  }
}

class UpdateErrorPropertySizeinsquarefeet implements Action {
  final bool error_PropertySizeinsquarefeet;

  UpdateErrorPropertySizeinsquarefeet(this.error_PropertySizeinsquarefeet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.eventtypesState(
        error_PropertySizeinsquarefeet: error_PropertySizeinsquarefeet);
  }
}

class UpdateErrorPropertyMaxoccupancy implements Action {
  final bool error_PropertyMaxoccupancy;

  UpdateErrorPropertyMaxoccupancy(this.error_PropertyMaxoccupancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_PropertyMaxoccupancy: error_PropertyMaxoccupancy);
  }
}

class UpdateErrorStorageavailable implements Action {
  final bool error_storageavailable;

  UpdateErrorStorageavailable(this.error_storageavailable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_storageavailable: error_storageavailable);
  }
}

class UpdateErrorParkingstalls implements Action {
  final bool error_Parkingstalls;

  UpdateErrorParkingstalls(this.error_Parkingstalls);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .eventtypesState(error_Parkingstalls: error_Parkingstalls);
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'add_vendor_state.freezed.dart';

@freezed
abstract class AddVendorState with _$AddVendorState {
  factory AddVendorState({
    required List<CountryData> countrydatalist,
    CountryData? selectedCountry,
    required List<StateData> statedatalist,
    StateData? selectedState,
    required List<CityData> citydatalist,
    CityData? selectedCity,
    required List<SystemEnumDetails> Categorylist,
    SystemEnumDetails? selectCategory,
    required int vid,
    required int personid,
    required double rating,
    required String companyname,
    required String cfirstname,
    required String clastname,
    required String cemail,
    required String cphone,
    required String cdialcode,
    required String ccountrycode,
    required String address,
    required String suit,
    required String postalcode,
    required String Note,
  }) = _AddVendorState;

  factory AddVendorState.initial() => AddVendorState(
        countrydatalist: List.empty(),
        selectedCountry: null,
        statedatalist: List.empty(),
        selectedState: null,
        citydatalist: List.empty(),
        selectedCity: null,
        Categorylist: List.empty(),
        selectCategory: null,
        vid: 0,
        personid: 0,
        rating: 0,
        companyname: "",
        cfirstname: "",
        clastname: "",
        cemail: "",
        cphone: "",
        cdialcode: "",
        ccountrycode: "",
        address: "",
        suit: "",
        postalcode: "",
        Note: "",
      );
}

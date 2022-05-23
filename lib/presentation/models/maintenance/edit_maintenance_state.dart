import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/basic_tenant/addvendordata.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/log_activity.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'edit_maintenance_state.freezed.dart';

@freezed
abstract class EditMaintenanceState with _$EditMaintenanceState {
  factory EditMaintenanceState({
    required String mid,
    required int Type_User,
    required String Applicant_ID,
    required String Date_Created,
    required bool IsLock,
    required List<SystemEnumDetails> MaintenanceStatuslist,
    SystemEnumDetails? selectStatus,
    required List<SystemEnumDetails> MaintenanceCategorylist,
    SystemEnumDetails? selectCategory,
    required List<PropertyDropData> PropertyDropDatalist,
    PropertyDropData? selectproperty,
    required String requestName,
    required int priority,
    required String description,
    required List<FileObject> fileobjectlist,
    required List<AddVendorData> vendordatalist,
    required List<CountryData> countrydatalist,
    CountryData? selectedCountry,
    required List<StateData> statedatalist,
    StateData? selectedState,
    required List<CityData> citydatalist,
    List<CityData>? selectedCity,
    required List<VendorData> mainvendordatalist,
    required List<SystemEnumDetails> filterCategorylist,
    required List<LogActivity> logActivitylist,
  }) = _EditMaintenanceState;

  factory EditMaintenanceState.initial() => EditMaintenanceState(
        mid: "",
        Type_User: 0,
        Applicant_ID: "",
        Date_Created: "",
        IsLock: false,
        MaintenanceStatuslist: List.empty(),
        selectStatus: null,
        MaintenanceCategorylist: List.empty(),
        selectCategory: null,
        PropertyDropDatalist: List.empty(),
        selectproperty: null,
        requestName: "",
        priority: 0,
        description: "",
        fileobjectlist: List.empty(),
        vendordatalist: List.empty(),
        countrydatalist: List.empty(),
        selectedCountry: null,
        statedatalist: List.empty(),
        selectedState: null,
        citydatalist: List.empty(),
        selectedCity: null,
        mainvendordatalist: List.empty(),
        filterCategorylist: List.empty(),
        logActivitylist: List.empty(),
      );
}

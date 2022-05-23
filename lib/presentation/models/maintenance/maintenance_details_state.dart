import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/maintenance_vendor.dart';
import 'package:silverhome/domain/entities/property_maintenance_images.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'maintenance_details_state.freezed.dart';

@freezed
abstract class MaintenanceDetailsState with _$MaintenanceDetailsState {
  factory MaintenanceDetailsState({
    required String mID,
    required bool IsLock,
    required String Describe_Issue,
    required String Date_Created,
    required int Type_User,
    required String RequestName,
    SystemEnumDetails? Category,
    SystemEnumDetails? Status,
    SystemEnumDetails? Priority,
    required String Applicant_ID,
    required String Applicant_UserID,
    required String Applicant_firstname,
    required String Applicant_lastname,
    required String Applicant_email,
    required String Applicant_mobile,
    required String Applicant_dialcode,
    required String Owner_ID,
    required String Owner_firstname,
    required String Owner_lastname,
    required String Owner_email,
    required String Owner_mobile,
    required String Owner_dialcode,
    required String CompanyName,
    required String HomePageLink,
    MediaInfo? Company_logo,
    required String Prop_ID,
    required String Property_Address,
    required String PropertyName,
    required String Suite_Unit,
    required List<PropertyMaintenanceImages> maintenanceImageslist,
    required List<MaintenanceVendor> maintenanceVendorlist,
  }) = _MaintenanceDetailsState;

  factory MaintenanceDetailsState.initial() => MaintenanceDetailsState(
        mID: "",
        IsLock: false,
        Describe_Issue: "",
        Date_Created: "",
        Type_User: 0,
        RequestName: "",
        Category: null,
        Status: null,
        Priority: null,
        /*Applicant*/
        Applicant_ID: "",
        Applicant_UserID: "",
        Applicant_firstname: "",
        Applicant_lastname: "",
        Applicant_email: "",
        Applicant_mobile: "",
        Applicant_dialcode: "",
        /*Landlord*/
        Owner_ID: "",
        Owner_firstname: "",
        Owner_lastname: "",
        Owner_email: "",
        Owner_mobile: "",
        Owner_dialcode: "",
        CompanyName: "",
        HomePageLink: "",
        Company_logo: null,
        /*Property*/
        Prop_ID: "",
        Property_Address: "",
        PropertyName: "",
        Suite_Unit: "",
        /*PropertyMaintenanceImages*/
        maintenanceImageslist: List.empty(),
        /*MaintenanceVendor*/
        maintenanceVendorlist: List.empty(),
      );
}

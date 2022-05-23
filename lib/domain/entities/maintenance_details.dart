import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/property_maintenance_images.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

import 'maintenance_vendor.dart';

class MaintenanceDetails {
  String? mID;
  bool? IsLock;
  String? Describe_Issue;
  String? Date_Created;
  int? Type_User;
  String? RequestName;
  SystemEnumDetails? Category;
  SystemEnumDetails? Status;
  SystemEnumDetails? Priority;
  String? Applicant_ID;
  String? Applicant_UserID;
  String? Applicant_firstname;
  String? Applicant_lastname;
  String? Applicant_email;
  String? Applicant_mobile;
  String? Applicant_dialcode;
  String? Owner_ID;
  String? Owner_firstname;
  String? Owner_lastname;
  String? Owner_email;
  String? Owner_mobile;
  String? Owner_dialcode;
  String? CompanyName;
  String? HomePageLink;
  MediaInfo? Company_logo;
  String? Prop_ID;
  String? Property_Address;
  String? PropertyName;
  String? Suite_Unit;
  List<PropertyMaintenanceImages>? maintenanceImageslist = [];
  List<MaintenanceVendor>? maintenanceVendorlist = [];
  CountryData? Country;
  StateData? State;
  String? City;

  MaintenanceDetails({
    this.mID,
    this.IsLock,
    this.Describe_Issue,
    this.Date_Created,
    this.Type_User,
    this.RequestName,
    this.Category,
    this.Status,
    this.Priority,
    this.Applicant_ID,
    this.Applicant_UserID,
    this.Applicant_firstname,
    this.Applicant_lastname,
    this.Applicant_email,
    this.Applicant_mobile,
    this.Applicant_dialcode,
    this.Owner_ID,
    this.Owner_firstname,
    this.Owner_lastname,
    this.Owner_email,
    this.Owner_mobile,
    this.Owner_dialcode,
    this.CompanyName,
    this.HomePageLink,
    this.Company_logo,
    this.Prop_ID,
    this.Property_Address,
    this.PropertyName,
    this.Suite_Unit,
    this.maintenanceImageslist,
    this.maintenanceVendorlist,
  });
}

import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/admin_action/admin_dashbord_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlord_account_actions.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlord_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlord_leads_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_landlord_property_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_leads_details_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_property_details_actions.dart';
import 'package:silverhome/domain/actions/admin_action/admin_setting_action.dart';
import 'package:silverhome/domain/actions/admin_action/admin_team_action.dart';
import 'package:silverhome/domain/entities/admin_class/db_tenant_owner_data.dart';
import 'package:silverhome/domain/entities/bulk_property.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';
import 'package:silverhome/domain/entities/leadtenantdata.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/e_table_names.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';

import 'api_manager.dart';
import 'httpclient.dart';

class ApiManagerAdmin {
  final _store = getIt<AppStore>();
  late OverlayEntry loader;

  /*==============================================================================*/
  /*========================     DashBord     =============================*/
  /*==============================================================================*/

  getDashbordStatusCount(BuildContext context) async {
    /* OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.Admin_Dashbord_DSQ1,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          int TotalTenant =
              myobject['Total Tenant'] != null ? myobject['Total Tenant'] : 0;

          int TotalProperties = myobject['Total Properties'] != null
              ? myobject['Total Properties']
              : 0;

          int TotalPropertyOwner = myobject['Total Property Owner'] != null
              ? myobject['Total Property Owner']
              : 0;

          int TotalLeasedSigned = myobject['Total Leased Signed'] != null
              ? myobject['Total Leased Signed']
              : 0;

          _store.dispatch(UpdateAdminDB_totalTenant_cout(TotalTenant));
          _store.dispatch(UpdateAdminDB_totalProperty_cout(TotalProperties));
          _store.dispatch(
              UpdateAdminDB_totalProperty_owner_cout(TotalPropertyOwner));
          _store.dispatch(
              UpdateAdminDB_totallease_signed_count(TotalLeasedSigned));
        }
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getDashbordList(BuildContext context) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_Dashbord_DSQ2,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        loader.remove();
        var data = jsonDecode(respoce);
        List<DbTenantOwnerData> newJoineeOwnerList = <DbTenantOwnerData>[];
        List<DbTenantOwnerData> todayTenantInviteList = <DbTenantOwnerData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String Email = myobject['Email'] != null ? myobject['Email'] : "";
          String Name = myobject['Name'] != null ? myobject['Name'] : "";
          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name']
              : "";
          String Landlord =
              myobject['Landlord'] != null ? myobject['Landlord'] : "";
          int ID = myobject['ID'] != null ? myobject['ID'] : 0;
          int UserType =
              myobject['UserType'] != null ? myobject['UserType'] : 0;

          DbTenantOwnerData dbTenantOwnerData = new DbTenantOwnerData();
          dbTenantOwnerData.id = ID;
          dbTenantOwnerData.email = Email;
          dbTenantOwnerData.name = Name;
          dbTenantOwnerData.userType = UserType;
          dbTenantOwnerData.PropertyName = PropertyName;
          dbTenantOwnerData.landlordname = Landlord;

          if (UserType == eUserType().landlord) {
            newJoineeOwnerList.add(dbTenantOwnerData);
          } else {
            todayTenantInviteList.add(dbTenantOwnerData);
          }

          _store.dispatch(UpdateAdminDB_newJoineeOwnerList(newJoineeOwnerList));
          _store.dispatch(
              UpdateAdminDB_todayTenantInviteList(todayTenantInviteList));
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  /*======================================================================*/
  /*===========================    LandLord View     =====================*/
  /*======================================================================*/

  getLandlordList(BuildContext context, String json, int ftime) async {
    /* OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    Helper.Log("getLandlordList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<LandLordData> landlorddatalist = <LandLordData>[];

        if (data['Result'].length > 0) {
          landlorddatalist = (data['Result'] as List)
              .map((p) => LandLordData.fromJson(p))
              .toList();
        }

        if (ftime == 0) {
          if (landlorddatalist.length > 0) {
            //int count = widget.departmentlist[0].page;

            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateAdminLandlord_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdateAdminLandlord_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdateAdminLandlord_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateAdminLandlord_totalpage(1));
          }
          _store.dispatch(UpdateAdminLandlord_pageNo(1));
        }

        _store.dispatch(UpdateAdminLandlord_isloding(false));
        _store.dispatch(UpdateAdminLandlord_datalist(landlorddatalist));
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getLandlordListExportCSV(BuildContext context) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_LandlordList,
      "Reqtokens": {"Roles": Weburl.RoleID},
      "LoadLookUpValues": true,
      "Sort": [
        {"FieldID": "Owner_ID", "SortSequence": 1}
      ]
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        loader.remove();
        var data = jsonDecode(respoce);

        List<LandLordData> landlorddatalist = <LandLordData>[];

        if (data['Result'].length > 0) {
          landlorddatalist = (data['Result'] as List)
              .map((p) => LandLordData.fromJson(p))
              .toList();

          String csv;
          List<List<dynamic>> csvList = [];

          List csvHeaderTitle = [];
          csvHeaderTitle.add(GlobleString.ALL_ID);
          csvHeaderTitle.add(GlobleString.ALL_LandlordName);
          csvHeaderTitle.add(GlobleString.ALL_Email);
          csvHeaderTitle.add(GlobleString.ALL_PhoneNumber);
          csvHeaderTitle.add(GlobleString.ALL_ofProperties);
          csvHeaderTitle.add(GlobleString.PH_Active_Inactive);

          csvList.add(csvHeaderTitle);

          for (var data in landlorddatalist.toSet()) {
            List row = [];
            row.add(data.id);
            row.add(data.landlordName);
            row.add(data.email);
            row.add(data.phoneNumber);
            row.add(data.ofProperties);
            row.add(data.activeInactive! ? "Active" : "InActive");

            csvList.add(row);
          }

          csv = const ListToCsvConverter().convert(csvList);

          String filename = "LandLordDataList_" +
              DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
              ".csv";

          // prepare
          final bytes = utf8.encode(csv);
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.document.createElement('a') as html.AnchorElement
            ..href = url
            ..style.display = 'none'
            ..download = filename;

          html.document.body!.children.add(anchor);
          anchor.click();
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  UpdateLandlordActive(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        String Result = data['Result'] != null ? data['Result'].toString() : "";

        loader.remove();
        CallBackQuesy(true, Result);
      } else {
        loader.remove();
        CallBackQuesy(false, respoce);
      }
    });
  }

  deleteLandlordData(
      BuildContext context, String userId, CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query =
        Weburl.RawSQL_Api + "query=DeleteUserAllData&UserID=" + userId;

    HttpClientCall().RawSQLAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        loader.remove();
        CallBackQuesy(true, Result);
      } else {
        loader.remove();
        CallBackQuesy(false, respoce);
      }
    });
  }

  /*===========================    LandLord View Details     =====================*/

  getLandlordAccountdetails(BuildContext context, String ownerid) async {
    //OverlayEntry loader = Helper.overlayLoader(context);
    //Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_Landlord_details,
      "Reqtokens": {"Owner_ID": ownerid},
      "LoadLookUpValues": true
    };

    String json = jsonEncode(myjson);

    Helper.Log("getLandlordAccountdetails", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);
        Helper.Log("getLandlordAccountdetails", data.toString());

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;
          String FirstName =
              myobject['FirstName'] != null ? myobject['FirstName'] : "";
          String LastName =
              myobject['LastName'] != null ? myobject['LastName'] : "";
          String Email = myobject['Email'] != null ? myobject['Email'] : "";
          String Dial_Code = myobject['Dial_Code'] != null &&
                  myobject['Dial_Code'].toString().isNotEmpty
              ? myobject['Dial_Code']
              : "+1";

          String Country_Code = myobject['Country_Code'] != null &&
                  myobject['Country_Code'].toString().isNotEmpty
              ? myobject['Country_Code']
              : "CA";

          String PhoneNumber =
              myobject['Phone Number'] != null ? myobject['Phone Number'] : "";

          String HomePageLink =
              myobject['HomePageLink'] != null ? myobject['HomePageLink'] : "";

          String CompanyName =
              myobject['CompanyName'] != null ? myobject['CompanyName'] : "";

          String CustomerFeatureListingURL =
              myobject['CustomerFeatureListingURL'] != null
                  ? myobject['CustomerFeatureListingURL']
                  : "";

          MediaInfo? Company_logo = myobject['Company_logo'] != null
              ? MediaInfo.fromJson(myobject['Company_logo'])
              : null;

          _store.dispatch(UpdateLandlordAccount_OwnerId(Owner_ID));
          _store.dispatch(UpdateLandlordAccount_firstname(FirstName));
          _store.dispatch(UpdateLandlordAccount_lastname(LastName));
          _store.dispatch(UpdateLandlordAccount_email(Email));
          _store.dispatch(UpdateLandlordAccount_dialcode(Dial_Code));
          _store.dispatch(UpdateLandlordAccount_countrycode(Country_Code));
          _store.dispatch(UpdateLandlordAccount_phoneno(PhoneNumber));
          _store.dispatch(UpdateLandlordAccount_isloading(false));
          _store.dispatch(UpdateLandlordAccount_Homepagelink(HomePageLink));
          _store.dispatch(UpdateLandlordAccount_Companyname(CompanyName));
          _store.dispatch(UpdateLandlordAccount_Companylogo(Company_logo));
          _store.dispatch(UpdateLandlordAccount_CustomerFeatureListingURL(
              CustomerFeatureListingURL));
          _store.dispatch(
              UpdateLandlordAccount_CustomerFeatureListingURL_Update(
                  CustomerFeatureListingURL));
        }
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  customerUrlUpdateworkflow(BuildContext context, String userid, String url,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.workflow_Admin_Customer_URL,
      "Reqtokens": {"Owner_ID": userid, "CustomerFeatureListingURL": url}
    };

    String json = jsonEncode(myjson);

    Helper.Log("customerUrlUpdateworkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        Helper.Log("customerUrlUpdateworkflow", respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  getLandlordPropertyList(BuildContext context, String json, int ftime) async {
    /* OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<PropertyData> propertylist = <PropertyData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

          String PropertyName = myobject['PropertyName'] != null
              ? myobject['PropertyName'].toString()
              : "";

          String Other_Property_Type = myobject['Other_Property_Type'] != null
              ? myobject['Other_Property_Type'].toString()
              : "";

          String Building_Name = myobject['Building_Name'] != null
              ? myobject['Building_Name'].toString()
              : "";

          String Property_Address = myobject['Property_Address'] != null
              ? myobject['Property_Address'].toString()
              : "";

          bool IsActive =
              myobject['IsActive'] != null ? myobject['IsActive'] : false;

          String Postal_Code = myobject['Postal_Code'] != null
              ? myobject['Postal_Code'].toString()
              : "";

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "";

          int Size = myobject['Size'] != null ? myobject['Size'] : 0;

          String Other_Partial_Furniture =
              myobject['Other_Partial_Furniture'] != null
                  ? myobject['Other_Partial_Furniture'].toString()
                  : "";

          String Max_Occupancy = myobject['Max_Occupancy'] != null
              ? myobject['Max_Occupancy'].toString()
              : "";

          String Date_Available = myobject['Date_Available'] != null
              ? myobject['Date_Available'].toString()
              : "";

          bool IsAgreed_TandC = myobject['IsAgreed_TandC'] != null
              ? myobject['IsAgreed_TandC']
              : false;

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String Rent_Amount = myobject['Rent_Amount'] != null
              ? myobject['Rent_Amount'].toString()
              : "";

          int Min_Lease_Number = myobject['Min_Lease_Number'] != null
              ? myobject['Min_Lease_Number']
              : "";

          String Parking_Stalls = myobject['Parking_Stalls'] != null
              ? myobject['Parking_Stalls'].toString()
              : "";

          String Country =
              myobject['Country'] != null ? myobject['Country'].toString() : "";

          int Bedrooms =
              myobject['Bedrooms'] != null ? myobject['Bedrooms'] : 0;

          String Suite_Unit = myobject['Suite_Unit'] != null
              ? myobject['Suite_Unit'].toString()
              : "";

          String Province = myobject['Province'] != null
              ? myobject['Province'].toString()
              : "";

          String Property_Description = myobject['Property_Description'] != null
              ? myobject['Property_Description'].toString()
              : "";

          int Bathrooms =
              myobject['Bathrooms'] != null ? myobject['Bathrooms'] : 0;

          int PropDrafting =
              myobject['PropDrafting'] != null ? myobject['PropDrafting'] : 0;

          bool Vacancy =
              myobject['Vacancy'] != null ? myobject['Vacancy'] : false;

          String ApplicantID = myobject['ApplicantID'] != null
              ? myobject['ApplicantID'].toString()
              : "";

          String TenantName = myobject['TenantName'] != null
              ? myobject['TenantName'].toString()
              : "";

          MediaInfo? Property_Image = myobject['Property_Image'] != null
              ? MediaInfo.fromJson(myobject['Property_Image'])
              : null;

          SystemEnumDetails? Property_Type = myobject['Property_Type'] != null
              ? SystemEnumDetails.fromJson(myobject['Property_Type'])
              : null;

          SystemEnumDetails? Min_Lease_Duration =
              myobject['Min_Lease_Duration'] != null
                  ? SystemEnumDetails.fromJson(myobject['Min_Lease_Duration'])
                  : null;

          SystemEnumDetails? Lease_Type = myobject['Lease_Type'] != null
              ? SystemEnumDetails.fromJson(myobject['Lease_Type'])
              : null;

          SystemEnumDetails? Furnishing = myobject['Furnishing'] != null
              ? SystemEnumDetails.fromJson(myobject['Furnishing'])
              : null;

          SystemEnumDetails? Rent_Payment_Frequency =
              myobject['Rent_Payment_Frequency'] != null
                  ? SystemEnumDetails.fromJson(
                      myobject['Rent_Payment_Frequency'])
                  : null;

          SystemEnumDetails? StorageAvailable =
              myobject['StorageAvailable'] != null
                  ? SystemEnumDetails.fromJson(myobject['StorageAvailable'])
                  : null;

          SystemEnumDetails? Rental_Space = myobject['Rental_Space'] != null
              ? SystemEnumDetails.fromJson(myobject['Rental_Space'])
              : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          PropertyData propertyData = new PropertyData();
          propertyData.ID = ID;
          propertyData.propertyName = PropertyName;
          propertyData.otherPropertyType = Other_Property_Type;
          propertyData.buildingName = Building_Name;
          propertyData.propertyAddress = Property_Address;
          propertyData.isActive = IsActive;
          propertyData.propertyImage = Property_Image;
          propertyData.postalCode = Postal_Code;
          propertyData.countryCode = Country_Code;
          propertyData.size = Size;
          propertyData.otherPartialFurniture = Other_Partial_Furniture;
          propertyData.maxOccupancy = Max_Occupancy;
          propertyData.dateAvailable = Date_Available;
          propertyData.isAgreedTandC = IsAgreed_TandC;
          propertyData.city = City;
          propertyData.rentAmount = Rent_Amount;
          propertyData.minLeaseNumber = Min_Lease_Number;
          propertyData.parkingStalls = Parking_Stalls;
          propertyData.country = Country;
          propertyData.bedrooms = Bedrooms;
          propertyData.suiteUnit = Suite_Unit;
          propertyData.province = Province;
          propertyData.propertyDescription = Property_Description;
          propertyData.bathrooms = Bathrooms;
          propertyData.propertyType = Property_Type;
          propertyData.minLeaseDuration = Min_Lease_Duration;
          propertyData.leaseType = Lease_Type;
          propertyData.furnishing = Furnishing;
          propertyData.rentPaymentFrequency = Rent_Payment_Frequency;
          propertyData.storageAvailable = StorageAvailable;
          propertyData.rentalSpace = Rental_Space;
          propertyData.PropDrafting = PropDrafting;
          propertyData.Vacancy = Vacancy;
          propertyData.createdOn = CreatedOn;
          propertyData.updatedOn = UpdatedOn;
          propertyData.ApplicantID = ApplicantID;
          propertyData.TenantName = TenantName;

          propertylist.add(propertyData);
        }

        if (ftime == 0) {
          if (propertylist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateAdminLL_Property_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdateAdminLL_Property_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdateAdminLL_Property_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateAdminLL_Property_totalpage(1));
          }
          _store.dispatch(UpdateAdminLL_Property_pageNo(1));
        }

        _store.dispatch(UpdateAdminLL_Property_isloding(false));
        _store.dispatch(UpdateAdminLL_PropertyDatalist(propertylist));
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getLandlordPropertyListExportCSV(BuildContext context, String OwnerID) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_Landlord_propertyList,
      "Reqtokens": {
        "Owner_ID": OwnerID,
      },
      "LoadLookUpValues": true,
      "LoadRecordInfo": true,
      "Sort": [
        {"FieldID": "PropertyName", "SortSequence": 1}
      ]
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        loader.remove();
        var data = jsonDecode(respoce);

        List<PropertyData> propertylist = <PropertyData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

          String PropertyName = myobject['PropertyName'] != null
              ? myobject['PropertyName'].toString()
              : "";

          String Other_Property_Type = myobject['Other_Property_Type'] != null
              ? myobject['Other_Property_Type'].toString()
              : "";

          String Building_Name = myobject['Building_Name'] != null
              ? myobject['Building_Name'].toString()
              : "";

          String Property_Address = myobject['Property_Address'] != null
              ? myobject['Property_Address'].toString()
              : "";

          bool IsActive =
              myobject['IsActive'] != null ? myobject['IsActive'] : false;

          String Postal_Code = myobject['Postal_Code'] != null
              ? myobject['Postal_Code'].toString()
              : "";

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "";

          int Size = myobject['Size'] != null ? myobject['Size'] : 0;

          String Other_Partial_Furniture =
              myobject['Other_Partial_Furniture'] != null
                  ? myobject['Other_Partial_Furniture'].toString()
                  : "";

          String Max_Occupancy = myobject['Max_Occupancy'] != null
              ? myobject['Max_Occupancy'].toString()
              : "";

          String Date_Available = myobject['Date_Available'] != null
              ? myobject['Date_Available'].toString()
              : "";

          bool IsAgreed_TandC = myobject['IsAgreed_TandC'] != null
              ? myobject['IsAgreed_TandC']
              : false;

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String Rent_Amount = myobject['Rent_Amount'] != null
              ? myobject['Rent_Amount'].toString()
              : "";

          int Min_Lease_Number = myobject['Min_Lease_Number'] != null
              ? myobject['Min_Lease_Number']
              : "";

          String Parking_Stalls = myobject['Parking_Stalls'] != null
              ? myobject['Parking_Stalls'].toString()
              : "";

          String Country =
              myobject['Country'] != null ? myobject['Country'].toString() : "";

          int Bedrooms =
              myobject['Bedrooms'] != null ? myobject['Bedrooms'] : 0;

          String Suite_Unit = myobject['Suite_Unit'] != null
              ? myobject['Suite_Unit'].toString()
              : "";

          String Province = myobject['Province'] != null
              ? myobject['Province'].toString()
              : "";

          String Property_Description = myobject['Property_Description'] != null
              ? myobject['Property_Description'].toString()
              : "";

          int Bathrooms =
              myobject['Bathrooms'] != null ? myobject['Bathrooms'] : 0;

          int PropDrafting =
              myobject['PropDrafting'] != null ? myobject['PropDrafting'] : 0;

          bool Vacancy =
              myobject['Vacancy'] != null ? myobject['Vacancy'] : false;

          MediaInfo? Property_Image = myobject['Property_Image'] != null
              ? MediaInfo.fromJson(myobject['Property_Image'])
              : null;

          SystemEnumDetails? Property_Type = myobject['Property_Type'] != null
              ? SystemEnumDetails.fromJson(myobject['Property_Type'])
              : null;

          SystemEnumDetails? Min_Lease_Duration =
              myobject['Min_Lease_Duration'] != null
                  ? SystemEnumDetails.fromJson(myobject['Min_Lease_Duration'])
                  : null;

          SystemEnumDetails? Lease_Type = myobject['Lease_Type'] != null
              ? SystemEnumDetails.fromJson(myobject['Lease_Type'])
              : null;

          SystemEnumDetails? Furnishing = myobject['Furnishing'] != null
              ? SystemEnumDetails.fromJson(myobject['Furnishing'])
              : null;

          SystemEnumDetails? Rent_Payment_Frequency =
              myobject['Rent_Payment_Frequency'] != null
                  ? SystemEnumDetails.fromJson(
                      myobject['Rent_Payment_Frequency'])
                  : null;

          SystemEnumDetails? StorageAvailable =
              myobject['StorageAvailable'] != null
                  ? SystemEnumDetails.fromJson(myobject['StorageAvailable'])
                  : null;

          SystemEnumDetails? Rental_Space = myobject['Rental_Space'] != null
              ? SystemEnumDetails.fromJson(myobject['Rental_Space'])
              : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          PropertyData propertyData = new PropertyData();
          propertyData.ID = ID;
          propertyData.propertyName = PropertyName;
          propertyData.otherPropertyType = Other_Property_Type;
          propertyData.buildingName = Building_Name;
          propertyData.propertyAddress = Property_Address;
          propertyData.isActive = IsActive;
          propertyData.propertyImage = Property_Image;
          propertyData.postalCode = Postal_Code;
          propertyData.countryCode = Country_Code;
          propertyData.size = Size;
          propertyData.otherPartialFurniture = Other_Partial_Furniture;
          propertyData.maxOccupancy = Max_Occupancy;
          propertyData.dateAvailable = Date_Available;
          propertyData.isAgreedTandC = IsAgreed_TandC;
          propertyData.city = City;
          propertyData.rentAmount = Rent_Amount;
          propertyData.minLeaseNumber = Min_Lease_Number;
          propertyData.parkingStalls = Parking_Stalls;
          propertyData.country = Country;
          propertyData.bedrooms = Bedrooms;
          propertyData.suiteUnit = Suite_Unit;
          propertyData.province = Province;
          propertyData.propertyDescription = Property_Description;
          propertyData.bathrooms = Bathrooms;
          propertyData.propertyType = Property_Type;
          propertyData.minLeaseDuration = Min_Lease_Duration;
          propertyData.leaseType = Lease_Type;
          propertyData.furnishing = Furnishing;
          propertyData.rentPaymentFrequency = Rent_Payment_Frequency;
          propertyData.storageAvailable = StorageAvailable;
          propertyData.rentalSpace = Rental_Space;
          propertyData.PropDrafting = PropDrafting;
          propertyData.Vacancy = Vacancy;
          propertyData.createdOn = CreatedOn;
          propertyData.updatedOn = UpdatedOn;

          propertylist.add(propertyData);
        }

        String csv;
        List<List<dynamic>> csvList = [];

        List csvHeaderTitle = [];
        csvHeaderTitle.add(GlobleString.ALLD_PH_Property_Name);
        csvHeaderTitle.add(GlobleString.ALLD_PH_Unit);
        csvHeaderTitle.add(GlobleString.ALLD_PH_City);
        csvHeaderTitle.add(GlobleString.ALLD_PH_Country);
        csvHeaderTitle.add(GlobleString.ALLD_PH_Property_Type);
        csvHeaderTitle.add(GlobleString.ALLD_PH_Vacancy);
        csvHeaderTitle.add(GlobleString.ALLD_PH_Active_Inactive);

        csvList.add(csvHeaderTitle);

        for (var data in propertylist.toSet()) {
          List row = [];

          row.add(data.propertyName);
          row.add(data.suiteUnit);
          row.add(data.city);
          row.add(data.country);

          if (data.propertyType!.EnumDetailID == 6) {
            row.add(data.otherPropertyType);
          } else {
            row.add(data.propertyType!.displayValue);
          }
          row.add(data.Vacancy!
              ? GlobleString.PH_Vacancy_Occupied
              : GlobleString.PH_Vacancy_Vacant);
          row.add(data.isActive! ? "Active" : "Inactive");

          csvList.add(row);
        }

        csv = const ListToCsvConverter().convert(csvList);

        String filename = "PropertyDataList_" +
            DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
            ".csv";

        // prepare
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = filename;

        html.document.body!.children.add(anchor);
        anchor.click();
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getLandlordPropertyDetails(BuildContext context, PropertyData propertyData,
      CallBackQuesy CallBackQuesy) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    //{"DSQID":"4602BD62-35B7-42FD-81E4-D14AA7D13ED5","Reqtokens":{"ID":"ED6C9422-ED86-4A26-98D2-575ED29B74BD"},"LoadLookup":true,"LoadChildren":true}

    var myjson = {
      "DSQID": Weburl.Admin_Landlord_property_details,
      "LoadLookup": true,
      //"LoadLookUpValues": true,
      "LoadChildren": true,
      "Reqtokens": {"ID": propertyData.ID}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        loader.remove();
        var data = jsonDecode(respoce);

        List<PropertyAmenitiesUtility> amenitieslist =
            <PropertyAmenitiesUtility>[];
        List<PropertyAmenitiesUtility> Summery_amenitieslist =
            <PropertyAmenitiesUtility>[];
        List<PropertyAmenitiesUtility> utilitylist =
            <PropertyAmenitiesUtility>[];
        List<PropertyAmenitiesUtility> Summery_utilitylist =
            <PropertyAmenitiesUtility>[];

        List<SystemEnumDetails> restrictionlist = [];
        List<SystemEnumDetails> Summery_restrictionlist = [];

        restrictionlist =
            await QueryFilter().PlainValues(eSystemEnums().Restrictions);
        Summery_restrictionlist =
            await QueryFilter().PlainValues(eSystemEnums().Restrictions);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          for (int j = 0; j < myobject['Property_Restriction'].length; j++) {
            var myRest = myobject['Property_Restriction'][j];

            SystemEnumDetails? Restrictions = myRest['Restrictions'] != null
                ? SystemEnumDetails.fromJson(myRest['Restrictions'])
                : null;

            for (int d = 0; d < restrictionlist.length; d++) {
              SystemEnumDetails restric = restrictionlist[d];

              if (restric.EnumDetailID == Restrictions!.EnumDetailID) {
                restrictionlist[d].ischeck = true;
                Summery_restrictionlist[d].ischeck = true;
              }
            }
          }

          if (myobject['Property_Amenities_Utilities'].length > 0) {
            for (int k = 0;
                k < myobject['Property_Amenities_Utilities'].length;
                k++) {
              var myAmenti = myobject['Property_Amenities_Utilities'][k];

              var Feature_ID = myAmenti['Feature_ID'] != null
                  ? myAmenti['Feature_ID']
                  : null;

              /*String Feature_Value = Feature_ID['Feature_Value'] != null
                ? Feature_ID['Feature_Value'].toString()
                : "1";*/

              PropertyAmenitiesUtility propertyAmenitiesUtility =
                  new PropertyAmenitiesUtility();

              if (Feature_ID != null) {
                int ID = Feature_ID['ID'] != null ? Feature_ID['ID'] : 0;

                String Feature = Feature_ID['Feature'] != null
                    ? Feature_ID['Feature'].toString()
                    : "";

                SystemEnumDetails? Feature_Type =
                    Feature_ID['Feature_Type'] != null
                        ? SystemEnumDetails.fromJson(Feature_ID['Feature_Type'])
                        : null;

                propertyAmenitiesUtility.id = ID;
                propertyAmenitiesUtility.Feature = Feature;
                propertyAmenitiesUtility.Feature_Type =
                    Feature_Type!.EnumDetailID;
              }

              SystemEnumDetails? Feature_Value =
                  myAmenti['Feature_Value'] != null
                      ? SystemEnumDetails.fromJson(myAmenti['Feature_Value'])
                      : null;

              propertyAmenitiesUtility.value =
                  Feature_Value!.EnumDetailID.toString();

              if (propertyAmenitiesUtility.Feature_Type == 1) {
                amenitieslist.add(propertyAmenitiesUtility);
                Summery_amenitieslist.add(propertyAmenitiesUtility);
              } else if (propertyAmenitiesUtility.Feature_Type == 2) {
                utilitylist.add(propertyAmenitiesUtility);
                Summery_utilitylist.add(propertyAmenitiesUtility);
              }
            }

            amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
            Summery_amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));

            utilitylist.sort((a, b) => a.id!.compareTo(b.id!));
            Summery_utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

            _store.dispatch(
                UpdateAdminSummeryPropertyAmenitiesList(Summery_amenitieslist));
            _store.dispatch(
                UpdateAdminSummeryPropertyUtilitiesList(Summery_utilitylist));
          } else {
            await ApiManagerAdmin().getPropertyFeaturelist(context);
          }

          if (myobject['PropertyImages'].length > 0) {
            List<PropertyImageMediaInfo> PropertyImageMediaInfolist = [];

            for (int k = 0; k < myobject['PropertyImages'].length; k++) {
              var PImages = myobject['PropertyImages'][k];

              String PID =
                  PImages['ID'] != null ? PImages['ID'].toString() : "";

              bool IsFavorite =
                  PImages['IsFavorite'] != null ? PImages['IsFavorite'] : false;

              var Media_ID = PImages["Media_ID"];

              int ID = Media_ID['ID'] != null ? Media_ID['ID'] : 0;

              int RefID = Media_ID['RefID'] != null ? Media_ID['RefID'] : 0;

              String URL = Media_ID['URL'] != null ? Media_ID['URL'] : "";

              int Sequence =
                  Media_ID['Sequence'] != null ? Media_ID['Sequence'] : 0;

              int FileType =
                  Media_ID['FileType'] != null ? Media_ID['FileType'] : 0;

              int IsActive =
                  Media_ID['IsActive'] != null ? Media_ID['IsActive'] : 0;

              int Type = Media_ID['Type'] != null ? Media_ID['Type'] : 0;

              PropertyImageMediaInfo propertyImageMediaInfo =
                  new PropertyImageMediaInfo();

              propertyImageMediaInfo.id = ID;
              propertyImageMediaInfo.fileType = FileType;
              propertyImageMediaInfo.refId = RefID;
              propertyImageMediaInfo.url = URL;
              propertyImageMediaInfo.isActive = IsActive;
              propertyImageMediaInfo.sequence = Sequence;
              propertyImageMediaInfo.type = Type;
              propertyImageMediaInfo.islive = true;
              propertyImageMediaInfo.ishover = false;
              propertyImageMediaInfo.appImage = null;
              propertyImageMediaInfo.fileName = null;
              propertyImageMediaInfo.ImageID = PID;
              propertyImageMediaInfo.IsFavorite = IsFavorite;

              PropertyImageMediaInfolist.add(propertyImageMediaInfo);
            }
            _store.dispatch(UpdateAdminSummeryPropertyImageList(
                PropertyImageMediaInfolist));
          } else {
            _store.dispatch(UpdateAdminSummeryPropertyImageList(
                <PropertyImageMediaInfo>[]));
          }

          _store.dispatch(
              UpdateAdminSummeryRestrictionlist(Summery_restrictionlist));
        }

        CallBackQuesy(true, respoce);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
        CallBackQuesy(false, respoce);
      }
    });
  }

  getPropertyFeaturelist(BuildContext context) async {
    Object blankObject = new Object();

    String query = await QueryFilter().SelectQuery(
        blankObject,
        etableName.Property_Features,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo,
        false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        List<PropertyAmenitiesUtility> amenitieslist =
            <PropertyAmenitiesUtility>[];
        List<PropertyAmenitiesUtility> summery_amenitieslist =
            <PropertyAmenitiesUtility>[];

        List<PropertyAmenitiesUtility> utilitylist =
            <PropertyAmenitiesUtility>[];
        List<PropertyAmenitiesUtility> summery_utilitylist =
            <PropertyAmenitiesUtility>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          String Feature =
              myobject['Feature'] != null ? myobject['Feature'].toString() : "";

          int Feature_Type =
              myobject['Feature_Type'] != null ? myobject['Feature_Type'] : "";

          PropertyAmenitiesUtility propertyAmenitiesUtility =
              new PropertyAmenitiesUtility();
          propertyAmenitiesUtility.id = ID;
          propertyAmenitiesUtility.Feature = Feature;
          propertyAmenitiesUtility.Feature_Type = Feature_Type;
          propertyAmenitiesUtility.value = "1";

          if (Feature_Type == 1) {
            amenitieslist.add(propertyAmenitiesUtility);
            summery_amenitieslist.add(propertyAmenitiesUtility);
          } else {
            utilitylist.add(propertyAmenitiesUtility);
            summery_utilitylist.add(propertyAmenitiesUtility);
          }
        }

        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        summery_amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));

        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));
        summery_utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        _store.dispatch(
            UpdateAdminSummeryPropertyAmenitiesList(summery_amenitieslist));
        _store.dispatch(
            UpdateAdminSummeryPropertyUtilitiesList(summery_utilitylist));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  getLandlordLeadsList(BuildContext context, String json, int ftime) async {
    //OverlayEntry loader = Helper.overlayLoader(context);
    //Overlay.of(context)!.insert(loader);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<LeadTenantData> leadTenantDatalist = <LeadTenantData>[];

        if (data['Result'].length > 0) {
          leadTenantDatalist = (data['Result'] as List)
              .map((p) => LeadTenantData.fromJson(p))
              .toList();
        }

        if (ftime == 0) {
          if (leadTenantDatalist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateAdminLL_Leads_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdateAdminLL_Leads_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdateAdminLL_Leads_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateAdminLL_Leads_totalpage(1));
          }
          _store.dispatch(UpdateAdminLL_Leads_pageNo(1));
        }

        _store.dispatch(UpdateAdminLL_Leads_isloding(false));
        _store.dispatch(UpdateAdminLL_leadstenantDatalist(leadTenantDatalist));
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getLandlordLeadsListExportCSV(BuildContext context, String OwnerID) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_Landlord_LeadsList,
      "Reqtokens": {
        "Owner_ID": OwnerID,
      },
      "LoadLookUpValues": true,
      "LoadRecordInfo": true,
      "Sort": [
        {"FieldID": "ID", "SortSequence": 1}
      ]
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        loader.remove();
        var data = jsonDecode(respoce);

        List<LeadTenantData> leadTenantDatalist = <LeadTenantData>[];

        if (data['Result'].length > 0) {
          leadTenantDatalist = (data['Result'] as List)
              .map((p) => LeadTenantData.fromJson(p))
              .toList();
        }

        String csv;
        List<List<dynamic>> csvList = [];

        List csvHeaderTitle = [];
        csvHeaderTitle.add(GlobleString.ALLD_ID);
        csvHeaderTitle.add(GlobleString.ALLD_Tenant);
        csvHeaderTitle.add(GlobleString.ALLD_Email);
        csvHeaderTitle.add(GlobleString.ALLD_PhoneNumber);
        csvHeaderTitle.add(GlobleString.ALLD_Rating);
        csvHeaderTitle.add(GlobleString.ALLD_LandlordName);
        csvHeaderTitle.add(GlobleString.ALLD_Property_Name);

        csvList.add(csvHeaderTitle);

        for (var data in leadTenantDatalist.toSet()) {
          List row = [];

          row.add(data.id);
          row.add(data.applicantName);
          row.add(data.email);
          row.add(data.mobileNumber);
          row.add(data.rating);
          row.add(data.landlordName);
          row.add(data.propertyName);
          csvList.add(row);
        }

        csv = const ListToCsvConverter().convert(csvList);

        String filename = "LeadsTenantDataList_" +
            DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
            ".csv";

        // prepare
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = filename;

        html.document.body!.children.add(anchor);
        anchor.click();
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getLandlordTenancyDetailsOld(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_Landlord_Leads_details,
      "LoadLookupValues": true,
      "LoadChildren": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("TenancyDetails", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ApplicantID =
              myobject['ID'] != null ? myobject['ID'].toString() : "";

          bool IsSmoking =
              myobject['IsSmoking'] != null ? myobject['IsSmoking'] : false;

          bool IsPet = myobject['IsPet'] != null ? myobject['IsPet'] : false;

          bool IsVehicle =
              myobject['IsVehicle'] != null ? myobject['IsVehicle'] : false;

          String SmokingDesc = myobject['SmokingDesc'] != null
              ? myobject['SmokingDesc'].toString()
              : "";
          String yourstory =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          String IntendedTenancyStartDate =
              myobject['IntendedTenancyStartDate'] != null
                  ? myobject['IntendedTenancyStartDate'].toString()
                  : "";

          SystemEnumDetails? IntendedLenth = myobject['IntendedLenth'] != null
              ? SystemEnumDetails.fromJson(myobject['IntendedLenth'])
              : null;

          SystemEnumDetails? IntendedPeriod = myobject['IntendedPeriod'] != null
              ? SystemEnumDetails.fromJson(myobject['IntendedPeriod'])
              : null;

          String IntendedPeriodNo = myobject['IntendedPeriodNo'] != null
              ? myobject['IntendedPeriodNo'].toString()
              : "";

          if (IntendedTenancyStartDate != "") {
            DateTime tempDate = DateTime.parse(IntendedTenancyStartDate);
            _store.dispatch(
                UpdateAdminLeadDetailAdditionalInfoTenancyStartDate(tempDate));
          } else {
            _store.dispatch(
                UpdateAdminLeadDetailAdditionalInfoTenancyStartDate(null));
          }

          _store.dispatch(UpdateAdminLeadDetailApplicantID(ApplicantID));
          _store.dispatch(
              UpdateAdminLeadDetailAdditionalInfoisSmoking(IsSmoking));
          _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIspets(IsPet));
          _store.dispatch(
              UpdateAdminLeadDetailAdditionalInfoisVehical(IsVehicle));
          _store.dispatch(
              UpdateAdminLeadDetailAdditionalInfoComment(SmokingDesc));
          _store.dispatch(
              UpdateAdminLeadDetailAdditionalInfoLenthOfTenancy(IntendedLenth));
          _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIntendedPeriod(
              IntendedPeriod));
          _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIntendedPeriodNo(
              IntendedPeriodNo));

          /*===============*/
          /* Personal Info */
          /*===============*/
          var PersonalInfo = myobject["Person_ID"];

          String PersonID =
              PersonalInfo['ID'] != null ? PersonalInfo['ID'].toString() : "";

          String FirstName = PersonalInfo['FirstName'] != null
              ? PersonalInfo['FirstName'].toString()
              : "";

          String LastName = PersonalInfo['LastName'] != null
              ? PersonalInfo['LastName'].toString()
              : "";

          String Email = PersonalInfo['Email'] != null
              ? PersonalInfo['Email'].toString()
              : "";

          String MobileNumber = PersonalInfo['MobileNumber'] != null
              ? PersonalInfo['MobileNumber'].toString()
              : "";

          String Country_Code = PersonalInfo['Country_Code'] != null
              ? PersonalInfo['Country_Code'].toString()
              : "CA";

          String Dial_Code = PersonalInfo['Dial_Code'] != null
              ? PersonalInfo['Dial_Code'].toString()
              : "+1";

          String DOB =
              PersonalInfo['DOB'] != null ? PersonalInfo['DOB'].toString() : "";

          _store.dispatch(UpdateAdminLeadDetailPersonID(PersonID));
          _store.dispatch(UpdateAdminLeadDetailFirstname(FirstName));
          _store.dispatch(UpdateAdminLeadDetailLastname(LastName));
          _store.dispatch(UpdateAdminLeadDetailEmail(Email));
          _store.dispatch(UpdateAdminLeadDetailPhoneNumber(MobileNumber));
          _store.dispatch(UpdateAdminLeadDetailCountryCode(Country_Code));
          _store.dispatch(UpdateAdminLeadDetailDialCode(Dial_Code));
          _store.dispatch(UpdateAdminLeadDetailStory(yourstory));

          if (DOB != "") {
            DateTime tempDate = DateTime.parse(DOB);
            _store.dispatch(UpdateAdminLeadDetailDateofBirth(tempDate));
            _store.dispatch(UpdateAdminLeadDetailAge(
                Helper.calculateAge(tempDate).toString()));
          } else {
            _store.dispatch(UpdateAdminLeadDetailDateofBirth(null));
            _store.dispatch(UpdateAdminLeadDetailAge("0"));
          }

          /*===============*/
          /*  Application  */
          /*===============*/
          for (int j = 0; j < myobject['Application'].length; j++) {
            var objectApplication = myobject['Application'][j];

            String AID = objectApplication['ID'] != null
                ? objectApplication['ID'].toString()
                : "";

            SystemEnumDetails? ApplicationStatus =
                objectApplication['ApplicationStatus'] != null
                    ? SystemEnumDetails.fromJson(
                        objectApplication['ApplicationStatus'])
                    : null;

            /*===============*/
            /*  Applicant_ID */
            /*===============*/
            var Applicant_ID = objectApplication["Applicant_ID"];

            String RatingReview = Applicant_ID['RatingReview'] != null
                ? Applicant_ID['RatingReview'].toString()
                : "";

            double Rating =
                Applicant_ID['Rating'] != null ? Applicant_ID['Rating'] : 0;

            _store.dispatch(UpdateAdminLeadDetailRating(Rating));
            _store.dispatch(UpdateAdminLeadDetailRatingReview(RatingReview));
            _store.dispatch(UpdateAdminLeadDetailApplicationID(AID));
            _store.dispatch(
                UpdateAdminLeadDetailApplicationStatus(ApplicationStatus));

            /*======================*/
            /*  AdditionalOccupants */
            /*======================*/

            List<TenancyAdditionalOccupant> occupantlist =
                <TenancyAdditionalOccupant>[];

            for (int k = 0;
                k < objectApplication['AdditionalOccupants'].length;
                k++) {
              var objectAdditionalOccupants =
                  objectApplication['AdditionalOccupants'][k];

              String AOID = objectAdditionalOccupants['ID'] != null
                  ? objectAdditionalOccupants['ID'].toString()
                  : "";

              String AORelationWithApplicant =
                  objectAdditionalOccupants['RelationWithApplicant'] != null
                      ? objectAdditionalOccupants['RelationWithApplicant']
                          .toString()
                      : "";

              /*===============*/
              /*  Occupant */
              /*===============*/
              var Occupant = objectAdditionalOccupants["Occupant"];

              String Occupant_ID =
                  Occupant['ID'] != null ? Occupant['ID'].toString() : "";

              String Occupant_FirstName = Occupant['FirstName'] != null
                  ? Occupant['FirstName'].toString()
                  : "";

              String Occupant_LastName = Occupant['LastName'] != null
                  ? Occupant['LastName'].toString()
                  : "";

              TenancyAdditionalOccupant tenancyAdditionalOccupant =
                  new TenancyAdditionalOccupant();
              tenancyAdditionalOccupant.id = AOID;
              tenancyAdditionalOccupant.primaryApplicant =
                  AORelationWithApplicant;
              tenancyAdditionalOccupant.firstname = Occupant_FirstName;
              tenancyAdditionalOccupant.lastname = Occupant_LastName;
              tenancyAdditionalOccupant.OccupantID = Occupant_ID;

              occupantlist.add(tenancyAdditionalOccupant);
            }

            _store.dispatch(UpdateAdminLeadDetailAddOccupantlist(occupantlist));

            bool IsNotApplicableAddOccupant =
                objectApplication['IsNotApplicableAddOccupant'] != null
                    ? objectApplication['IsNotApplicableAddOccupant']
                    : false;

            _store.dispatch(UpdateAdminLeadDetailAddOccupantNotApplicable(
                IsNotApplicableAddOccupant));

            /*======================*/
            /*  AdditionalReferences */
            /*======================*/

            List<TenancyAdditionalReference> referencelist =
                <TenancyAdditionalReference>[];

            for (int l = 0;
                l < objectApplication['AdditionalReferences'].length;
                l++) {
              var objectAdditionalReferences =
                  objectApplication['AdditionalReferences'][l];

              String ARID = objectAdditionalReferences['ID'] != null
                  ? objectAdditionalReferences['ID'].toString()
                  : "";

              String ARRelationWithApplicant =
                  objectAdditionalReferences['RelationWithApplicant'] != null
                      ? objectAdditionalReferences['RelationWithApplicant']
                          .toString()
                      : "";

              /*===============*/
              /*  Reference */
              /*===============*/
              var Reference = objectAdditionalReferences["ReferenceID"];

              String Reference_ID =
                  Reference['ID'] != null ? Reference['ID'].toString() : "";

              String Reference_FirstName = Reference['FirstName'] != null
                  ? Reference['FirstName'].toString()
                  : "";

              String Reference_LastName = Reference['LastName'] != null
                  ? Reference['LastName'].toString()
                  : "";

              String Reference_Country_Code = Reference['Country_Code'] != null
                  ? Reference['Country_Code'].toString()
                  : "CA";

              String Reference_Dial_Code = Reference['Dial_Code'] != null
                  ? Reference['Dial_Code'].toString()
                  : "+1";

              String Reference_MobileNumber = Reference['MobileNumber'] != null
                  ? Reference['MobileNumber'].toString()
                  : "";

              String Reference_Email = Reference['Email'] != null
                  ? Reference['Email'].toString()
                  : "";

              TenancyAdditionalReference tenancyAdditionalReference =
                  new TenancyAdditionalReference();
              tenancyAdditionalReference.id = ARID;
              tenancyAdditionalReference.reletionshipprimaryApplicant =
                  ARRelationWithApplicant;
              tenancyAdditionalReference.firstname = Reference_FirstName;
              tenancyAdditionalReference.lastname = Reference_LastName;
              tenancyAdditionalReference.countrycode = Reference_Country_Code;
              tenancyAdditionalReference.dailcode = Reference_Dial_Code;
              tenancyAdditionalReference.phonenumber = Reference_MobileNumber;
              tenancyAdditionalReference.email = Reference_Email;
              tenancyAdditionalReference.ReferenceID = Reference_ID;

              referencelist.add(tenancyAdditionalReference);
            }

            _store.dispatch(
                UpdateAdminLeadDetailAdditionalReferencelist(referencelist));
          }

          /*===============*/
          /* CurrentTenancy */
          /*===============*/

          if (myobject['CurrentTenancy'].length > 0) {
            for (int b = 0; b < myobject['CurrentTenancy'].length; b++) {
              var objectCurrentTenancy = myobject['CurrentTenancy'][b];

              String CurrentTenancy_ID = objectCurrentTenancy['ID'] != null
                  ? objectCurrentTenancy['ID'].toString()
                  : "";

              String CurrentTenancy_Start_Date =
                  objectCurrentTenancy['Start_Date'] != null
                      ? objectCurrentTenancy['Start_Date'].toString()
                      : "";

              String CurrentTenancy_End_Date =
                  objectCurrentTenancy['End_Date'] != null
                      ? objectCurrentTenancy['End_Date'].toString()
                      : "";

              String CurrentTenancy_Suite =
                  objectCurrentTenancy['Suite'] != null
                      ? objectCurrentTenancy['Suite'].toString()
                      : "";

              String CurrentTenancy_Address =
                  objectCurrentTenancy['Address'] != null
                      ? objectCurrentTenancy['Address'].toString()
                      : "";

              String CurrentTenancy_City = objectCurrentTenancy['City'] != null
                  ? objectCurrentTenancy['City'].toString()
                  : "";

              String CurrentTenancy_Province =
                  objectCurrentTenancy['Province'] != null
                      ? objectCurrentTenancy['Province'].toString()
                      : "";

              String CurrentTenancy_PostalCode =
                  objectCurrentTenancy['PostalCode'] != null
                      ? objectCurrentTenancy['PostalCode'].toString()
                      : "";

              bool CurrentTenancy_As_Reference = objectCurrentTenancy[
                          'CurrentLandLordIschecked_As_Reference'] !=
                      null
                  ? objectCurrentTenancy[
                      'CurrentLandLordIschecked_As_Reference']
                  : false;

              /*===============*/
              /* Personal Info */
              /*===============*/
              var CurrentLandLordInfo = objectCurrentTenancy["CurrentLandLord"];

              String CurrentLandLord_ID = CurrentLandLordInfo['ID'] != null
                  ? CurrentLandLordInfo['ID'].toString()
                  : "";

              String CurrentLandLord_FirstName =
                  CurrentLandLordInfo['FirstName'] != null
                      ? CurrentLandLordInfo['FirstName'].toString()
                      : "";

              String CurrentLandLord_LastName =
                  CurrentLandLordInfo['LastName'] != null
                      ? CurrentLandLordInfo['LastName'].toString()
                      : "";

              String CurrentLandLord_Email =
                  CurrentLandLordInfo['Email'] != null
                      ? CurrentLandLordInfo['Email'].toString()
                      : "";

              String CurrentLandLord_MobileNumber =
                  CurrentLandLordInfo['MobileNumber'] != null
                      ? CurrentLandLordInfo['MobileNumber'].toString()
                      : "";

              String CurrentLandLord_Country_Code =
                  CurrentLandLordInfo['Country_Code'] != null
                      ? CurrentLandLordInfo['Country_Code'].toString()
                      : "CA";

              String CurrentLandLord_Dial_Code =
                  CurrentLandLordInfo['Dial_Code'] != null
                      ? CurrentLandLordInfo['Dial_Code'].toString()
                      : "+1";

              if (CurrentTenancy_Start_Date != "") {
                DateTime tempDate = DateTime.parse(CurrentTenancy_Start_Date);
                _store.dispatch(
                    UpdateAdminLeadDetailCurrenttenantStartDate(tempDate));
              } else {
                _store.dispatch(
                    UpdateAdminLeadDetailCurrenttenantStartDate(null));
              }

              if (CurrentTenancy_End_Date != "") {
                DateTime tempDate = DateTime.parse(CurrentTenancy_End_Date);
                _store.dispatch(
                    UpdateAdminLeadDetailCurrenttenantEndDate(tempDate));
              } else {
                _store
                    .dispatch(UpdateAdminLeadDetailCurrenttenantEndDate(null));
              }

              _store.dispatch(
                  UpdateAdminLeadDetailCurrenttenantCurrentTenancyID(
                      CurrentTenancy_ID));
              _store.dispatch(
                  UpdateAdminLeadDetailCurrenttenantCurrentLandLordID(
                      CurrentLandLord_ID));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantSuiteUnit(
                  CurrentTenancy_Suite));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantAddress(
                  CurrentTenancy_Address));
              _store.dispatch(
                  UpdateAdminLeadDetailCurrenttenantCity(CurrentTenancy_City));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantProvince(
                  CurrentTenancy_Province));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantPostalcode(
                  CurrentTenancy_PostalCode));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantisReference(
                  CurrentTenancy_As_Reference));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantFirstname(
                  CurrentLandLord_FirstName));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantLastname(
                  CurrentLandLord_LastName));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantEmail(
                  CurrentLandLord_Email));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantPhonenumber(
                  CurrentLandLord_MobileNumber));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantCode(
                  CurrentLandLord_Country_Code));
              _store.dispatch(UpdateAdminLeadDetailCurrenttenantDailCode(
                  CurrentLandLord_Dial_Code));
            }
          } else {
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantStartDate(null));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantEndDate(null));
            _store.dispatch(
                UpdateAdminLeadDetailCurrenttenantCurrentTenancyID(""));
            _store.dispatch(
                UpdateAdminLeadDetailCurrenttenantCurrentLandLordID(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantSuiteUnit(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantAddress(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantCity(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantProvince(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantPostalcode(""));
            _store
                .dispatch(UpdateAdminLeadDetailCurrenttenantisReference(false));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantFirstname(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantLastname(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantEmail(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantPhonenumber(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantCode(""));
            _store.dispatch(UpdateAdminLeadDetailCurrenttenantDailCode(""));
          }

          /*===============*/
          /* Employment */
          /*===============*/

          if (myobject['Employment'].length > 0) {
            for (int a = 0; a < myobject['Employment'].length; a++) {
              var objectEmployment = myobject['Employment'][a];

              String Employment_ID = objectEmployment['ID'] != null
                  ? objectEmployment['ID'].toString()
                  : "";

              String Employment_LinkedIn = objectEmployment['LinkedIn'] != null
                  ? objectEmployment['LinkedIn'].toString()
                  : "";

              String Employment_OtherSourceIncome =
                  objectEmployment['OtherSourceIncome'] != null
                      ? objectEmployment['OtherSourceIncome'].toString()
                      : "";

              SystemEnumDetails? Employment_Annual_Income_Status =
                  objectEmployment['Annual_Income_Status'] != null
                      ? SystemEnumDetails.fromJson(
                          objectEmployment['Annual_Income_Status'])
                      : null;

              SystemEnumDetails? Employment_Emp_Status_ID =
                  objectEmployment['Emp_Status_ID'] != null
                      ? SystemEnumDetails.fromJson(
                          objectEmployment['Emp_Status_ID'])
                      : null;

              _store.dispatch(UpdateAdminLeadDetailothersourceincome(
                  Employment_OtherSourceIncome));
              _store.dispatch(
                  UpdateAdminLeadDetaillinkedprofile(Employment_LinkedIn));
              _store.dispatch(UpdateAdminLeadDetailAnualincomestatus(
                  Employment_Annual_Income_Status));
              _store.dispatch(
                  UpdateAdminLeadDetailempstatus(Employment_Emp_Status_ID));
              _store.dispatch(UpdateAdminLeadDetailEmploymentID(Employment_ID));

              /*===============*/
              /* Occupation Info */
              /*===============*/

              List<TenancyEmploymentInformation> listoccupation =
                  <TenancyEmploymentInformation>[];

              for (int to = 0;
                  to < objectEmployment['Occupation'].length;
                  to++) {
                var OccupationInfo = objectEmployment['Occupation'][to];

                String Occupation_ID = OccupationInfo['ID'] != null
                    ? OccupationInfo['ID'].toString()
                    : "";

                String Occupation = OccupationInfo['Occupation'] != null
                    ? OccupationInfo['Occupation'].toString()
                    : "";

                String Occupation_Organization =
                    OccupationInfo['Organization'] != null
                        ? OccupationInfo['Organization'].toString()
                        : "";

                String Occupation_LegthofEmpoyment =
                    OccupationInfo['Duration'] != null
                        ? OccupationInfo['Duration'].toString()
                        : "";

                bool Occupation_IsCurrentOccupation =
                    OccupationInfo['IsCurrentOccupation'] != null
                        ? OccupationInfo['IsCurrentOccupation']
                        : false;

                SystemEnumDetails? Occupation_Annual_Income_Status =
                    OccupationInfo['Annual_Income_Status'] != null
                        ? SystemEnumDetails.fromJson(
                            OccupationInfo['Annual_Income_Status'])
                        : null;

                if (Occupation_IsCurrentOccupation) {
                  _store.dispatch(UpdateAdminLeadDetailAnualincomestatus(
                      Occupation_Annual_Income_Status));
                }

                TenancyEmploymentInformation tenancyEmploymentInformation =
                    new TenancyEmploymentInformation();
                tenancyEmploymentInformation.id = Occupation_ID;
                tenancyEmploymentInformation.occupation = Occupation;
                tenancyEmploymentInformation.organization =
                    Occupation_Organization;
                tenancyEmploymentInformation.lenthofemp =
                    Occupation_LegthofEmpoyment;
                tenancyEmploymentInformation.anualIncome =
                    Occupation_Annual_Income_Status;

                listoccupation.add(tenancyEmploymentInformation);
              }

              _store.dispatch(
                  UpdateAdminLeadDetaillistoccupation(listoccupation));
            }
          } else {
            _store.dispatch(UpdateAdminLeadDetailothersourceincome(""));
            _store.dispatch(UpdateAdminLeadDetaillinkedprofile(""));
            _store.dispatch(UpdateAdminLeadDetailAnualincomestatus(null));
            _store.dispatch(UpdateAdminLeadDetailempstatus(null));
            _store.dispatch(UpdateAdminLeadDetailEmploymentID(""));

            _store.dispatch(UpdateAdminLeadDetaillistoccupation(
                <TenancyEmploymentInformation>[]));
          }

          /*===============*/
          /* PetInfo */
          /*===============*/

          List<Pets> petslist = <Pets>[];

          for (int c = 0; c < myobject['PetInfo'].length; c++) {
            var objectPetInfo = myobject['PetInfo'][c];

            String PetInfo_ID = objectPetInfo['ID'] != null
                ? objectPetInfo['ID'].toString()
                : "";

            String PetInfo_TypeOfPet = objectPetInfo['TypeOfPet'] != null
                ? objectPetInfo['TypeOfPet'].toString()
                : "";

            String PetInfo_Size = objectPetInfo['Size'] != null
                ? objectPetInfo['Size'].toString()
                : "";

            String PetInfo_Age = objectPetInfo['Age'] != null
                ? objectPetInfo['Age'].toString()
                : "";

            Pets pets = new Pets();
            pets.id = PetInfo_ID;
            pets.typeofpets = PetInfo_TypeOfPet;
            pets.size = PetInfo_Size;
            pets.age = PetInfo_Age;

            petslist.add(pets);
          }

          _store
              .dispatch(UpdateAdminLeadDetailAdditionalInfoPetslist(petslist));

          /*===============*/
          /* VehicleInfo */
          /*===============*/

          List<Vehical> vehicallist = <Vehical>[];

          for (int d = 0; d < myobject['VehicleInfo'].length; d++) {
            var objectVehicleInfo = myobject['VehicleInfo'][d];

            String VehicleInfo_ID = objectVehicleInfo['ID'] != null
                ? objectVehicleInfo['ID'].toString()
                : "";

            String VehicleInfo_Model = objectVehicleInfo['Model'] != null
                ? objectVehicleInfo['Model'].toString()
                : "";

            String VehicleInfo_Make = objectVehicleInfo['Make'] != null
                ? objectVehicleInfo['Make'].toString()
                : "";

            String VehicleInfo_Year = objectVehicleInfo['Year'] != null
                ? objectVehicleInfo['Year'].toString()
                : "";

            Vehical vehical = new Vehical();
            vehical.id = VehicleInfo_ID;
            vehical.model = VehicleInfo_Model;
            vehical.make = VehicleInfo_Make;
            vehical.year = VehicleInfo_Year;

            vehicallist.add(vehical);
          }

          _store.dispatch(
              UpdateAdminLeadDetailAdditionalInfoVehicallist(vehicallist));
        }

        loader.remove();
        callBackQuesy(true, "");
      } else {
        loader.remove();
        callBackQuesy(false, respoce);
      }
    });
  }

  getLandlordTenancyDetails(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    await clearLeadTenantState();

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getTenancyDetails_Applicant(context, id,
        (status, responce, applicantDetails) {
      if (status) {
        if (applicantDetails!.intendedTenancyStartDate != "") {
          DateTime tempDate =
              DateTime.parse(applicantDetails.intendedTenancyStartDate!);
          _store.dispatch(
              UpdateAdminLeadDetailAdditionalInfoTenancyStartDate(tempDate));
        } else {
          _store.dispatch(
              UpdateAdminLeadDetailAdditionalInfoTenancyStartDate(null));
        }

        _store.dispatch(UpdateAdminLeadDetailApplicantID(applicantDetails.id!));
        _store.dispatch(UpdateAdminLeadDetailAdditionalInfoisSmoking(
            applicantDetails.isSmoking!));
        _store.dispatch(
            UpdateAdminLeadDetailAdditionalInfoIspets(applicantDetails.isPet!));
        _store.dispatch(UpdateAdminLeadDetailAdditionalInfoisVehical(
            applicantDetails.isVehicle!));
        _store.dispatch(UpdateAdminLeadDetailAdditionalInfoComment(
            applicantDetails.smokingDesc!));
        _store.dispatch(UpdateAdminLeadDetailAdditionalInfoLenthOfTenancy(
            applicantDetails.intendedLenth));
        _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIntendedPeriod(
            applicantDetails.intendedPeriod));
        _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIntendedPeriodNo(
            applicantDetails.intendedPeriodNo!));

        _store.dispatch(
            UpdateAdminLeadDetailPersonID(applicantDetails.personId!.id!));
        _store.dispatch(UpdateAdminLeadDetailFirstname(
            applicantDetails.personId!.firstName!));
        _store.dispatch(UpdateAdminLeadDetailLastname(
            applicantDetails.personId!.lastName!));
        _store.dispatch(
            UpdateAdminLeadDetailEmail(applicantDetails.personId!.email!));
        _store.dispatch(UpdateAdminLeadDetailPhoneNumber(
            applicantDetails.personId!.mobileNumber!));
        _store.dispatch(UpdateAdminLeadDetailCountryCode(
            applicantDetails.personId!.countryCode!));
        _store.dispatch(UpdateAdminLeadDetailDialCode(
            applicantDetails.personId!.dialCode!));
        _store
            .dispatch(UpdateAdminLeadDetailStory(applicantDetails.yourStory!));
        //_store.dispatch(UpdateAdminLeadDetailNote(applicantDetails.note!));

        if (applicantDetails.personId!.DOB != "") {
          DateTime tempDate = DateTime.parse(applicantDetails.personId!.DOB!);
          _store.dispatch(UpdateAdminLeadDetailDateofBirth(tempDate));
          _store.dispatch(UpdateAdminLeadDetailAge(
              Helper.calculateAge(tempDate).toString()));
        } else {
          _store.dispatch(UpdateAdminLeadDetailDateofBirth(null));
          _store.dispatch(UpdateAdminLeadDetailAge("0"));
        }

        _store.dispatch(UpdateAdminLeadDetailRating(applicantDetails.rating!));
        _store.dispatch(
            UpdateAdminLeadDetailRatingReview(applicantDetails.note!));
      }
    });

    ApiManager().getTenancyDetails_Application(context, id,
        (status, responce, applicationDetails, propdata, ownerdata) async {
      if (status) {
        _store.dispatch(
            UpdateAdminLeadDetailApplicationID(applicationDetails!.id!));
        _store.dispatch(UpdateAdminLeadDetailApplicationStatus(
            applicationDetails.applicationStatus));

        _store.dispatch(UpdateAdminLeadDetailAddOccupantNotApplicable(
            applicationDetails.IsNotApplicableAddOccupant!));

        await ApiManager().getTenancyDetails_AdditionalOccupant(
            context, applicationDetails.id!, (status, responce, occupantlist) {
          if (status) {
            _store.dispatch(UpdateAdminLeadDetailAddOccupantlist(occupantlist));
          }
        });

        await ApiManager().getTenancyDetails_AdditionalReference(
            context, applicationDetails.id!, (status, responce, referencelist) {
          if (status) {
            _store.dispatch(
                UpdateAdminLeadDetailAdditionalReferencelist(referencelist));
          }
        });

        loader.remove();

        callBackQuesy(true, "");
      }
    });

    ApiManager().getTenancyDetails_CurrentTenancy(context, id,
        (status, responce, applicatCurrentTenancy) {
      if (status) {
        if (applicatCurrentTenancy!.startDate != "") {
          DateTime tempDate = DateTime.parse(applicatCurrentTenancy.startDate!);
          _store
              .dispatch(UpdateAdminLeadDetailCurrenttenantStartDate(tempDate));
        } else {
          _store.dispatch(UpdateAdminLeadDetailCurrenttenantStartDate(null));
        }

        if (applicatCurrentTenancy.endDate != "") {
          DateTime tempDate = DateTime.parse(applicatCurrentTenancy.endDate!);
          _store.dispatch(UpdateAdminLeadDetailCurrenttenantEndDate(tempDate));
        } else {
          _store.dispatch(UpdateAdminLeadDetailCurrenttenantEndDate(null));
        }

        _store.dispatch(UpdateAdminLeadDetailCurrenttenantCurrentTenancyID(
            applicatCurrentTenancy.id!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantCurrentLandLordID(
            applicatCurrentTenancy.CurrentLandLord_ID!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantSuiteUnit(
            applicatCurrentTenancy.suite!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantAddress(
            applicatCurrentTenancy.address!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantCity(
            applicatCurrentTenancy.city!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantProvince(
            applicatCurrentTenancy.province!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantPostalcode(
            applicatCurrentTenancy.postalCode!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantisReference(
            applicatCurrentTenancy.currentLandLordIscheckedAsReference!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantFirstname(
            applicatCurrentTenancy.CurrentLandLord_FirstName!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantLastname(
            applicatCurrentTenancy.CurrentLandLord_LastName!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantEmail(
            applicatCurrentTenancy.CurrentLandLord_Email!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantPhonenumber(
            applicatCurrentTenancy.CurrentLandLord_MobileNumber!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantCode(
            applicatCurrentTenancy.CurrentLandLord_Country_Code!));
        _store.dispatch(UpdateAdminLeadDetailCurrenttenantDailCode(
            applicatCurrentTenancy.CurrentLandLord_Dial_Code!));
      }
    });

    ApiManager().getTenancyDetails_Employemant(context, id,
        (status, responce, employemantDetails) {
      if (status) {
        _store.dispatch(UpdateAdminLeadDetailothersourceincome(
            employemantDetails!.otherSourceIncome!));
        _store.dispatch(
            UpdateAdminLeadDetaillinkedprofile(employemantDetails.LinkedIn!));
        _store.dispatch(UpdateAdminLeadDetailAnualincomestatus(
            employemantDetails.annualIncomeStatus));
        _store.dispatch(
            UpdateAdminLeadDetailempstatus(employemantDetails.empStatusId));
        _store.dispatch(
            UpdateAdminLeadDetailEmploymentID(employemantDetails.id!));
        _store.dispatch(UpdateAdminLeadDetaillistoccupation(
            employemantDetails.occupation!));

        for (int b = 0; b < employemantDetails.occupation!.length; b++) {
          TenancyEmploymentInformation tenancyEmploymentInformation =
              employemantDetails.occupation![b];

          if (tenancyEmploymentInformation.IsCurrentOccupation!) {
            _store.dispatch(UpdateAdminLeadDetailAnualincomestatus(
                tenancyEmploymentInformation.anualIncome!));
            break;
          }
        }
      }
    });

    ApiManager().getTenancyDetails_PetInfo(context, id,
        (status, responce, petslist) {
      if (status) {
        _store.dispatch(UpdateAdminLeadDetailAdditionalInfoPetslist(petslist));
      }
    });

    ApiManager().getTenancyDetails_Vehicallist(context, id,
        (status, responce, vehicallist) {
      if (status) {
        _store.dispatch(
            UpdateAdminLeadDetailAdditionalInfoVehicallist(vehicallist));
      }
    });
  }

  clearLeadTenantState() {
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoTenancyStartDate(null));
    _store.dispatch(UpdateAdminLeadDetailApplicantID(""));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoisSmoking(false));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIspets(false));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoisVehical(false));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoComment(""));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoLenthOfTenancy(null));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIntendedPeriod(null));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoIntendedPeriodNo(""));

    _store.dispatch(UpdateAdminLeadDetailPersonID(""));
    _store.dispatch(UpdateAdminLeadDetailFirstname(""));
    _store.dispatch(UpdateAdminLeadDetailLastname(""));
    _store.dispatch(UpdateAdminLeadDetailEmail(""));
    _store.dispatch(UpdateAdminLeadDetailPhoneNumber(""));
    _store.dispatch(UpdateAdminLeadDetailCountryCode(""));
    _store.dispatch(UpdateAdminLeadDetailDialCode(""));
    _store.dispatch(UpdateAdminLeadDetailStory(""));
    //_store.dispatch(UpdateAdminLeadDetailNote(applicantDetails.note!));

    _store.dispatch(UpdateAdminLeadDetailDateofBirth(null));
    _store.dispatch(UpdateAdminLeadDetailAge("0"));

    _store.dispatch(UpdateAdminLeadDetailRating(0));
    _store.dispatch(UpdateAdminLeadDetailRatingReview(""));

    _store.dispatch(UpdateAdminLeadDetailApplicationID(""));
    _store.dispatch(UpdateAdminLeadDetailApplicationStatus(null));

    _store.dispatch(UpdateAdminLeadDetailAddOccupantNotApplicable(false));

    _store.dispatch(UpdateAdminLeadDetailAddOccupantlist([]));

    _store.dispatch(UpdateAdminLeadDetailAdditionalReferencelist([]));

    _store.dispatch(UpdateAdminLeadDetailCurrenttenantStartDate(null));

    _store.dispatch(UpdateAdminLeadDetailCurrenttenantEndDate(null));

    _store.dispatch(UpdateAdminLeadDetailCurrenttenantCurrentTenancyID(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantCurrentLandLordID(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantSuiteUnit(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantAddress(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantCity(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantProvince(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantPostalcode(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantisReference(false));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantFirstname(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantLastname(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantEmail(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantPhonenumber(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantCode(""));
    _store.dispatch(UpdateAdminLeadDetailCurrenttenantDailCode(""));

    _store.dispatch(UpdateAdminLeadDetailothersourceincome(""));
    _store.dispatch(UpdateAdminLeadDetaillinkedprofile(""));
    _store.dispatch(UpdateAdminLeadDetailAnualincomestatus(null));
    _store.dispatch(UpdateAdminLeadDetailempstatus(null));
    _store.dispatch(UpdateAdminLeadDetailEmploymentID(""));
    _store.dispatch(UpdateAdminLeadDetaillistoccupation([]));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoPetslist([]));
    _store.dispatch(UpdateAdminLeadDetailAdditionalInfoVehicallist([]));
  }

  /*======================================================================*/
  /*===========================    Leads & tenant    =====================*/
  /*======================================================================*/

  getLeadsTenantList(BuildContext context, String json, int ftime) async {
    //OverlayEntry loader = Helper.overlayLoader(context);
    //Overlay.of(context)!.insert(loader);

    Helper.Log("getLeadsTenantList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<LeadTenantData> leadTenantDatalist = <LeadTenantData>[];

        if (data['Result'].length > 0) {
          leadTenantDatalist = (data['Result'] as List)
              .map((p) => LeadTenantData.fromJson(p))
              .toList();
        }

        if (ftime == 0) {
          if (leadTenantDatalist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateAdminLL_Leads_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdateAdminLL_Leads_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdateAdminLL_Leads_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateAdminLL_Leads_totalpage(1));
          }
          _store.dispatch(UpdateAdminLL_Leads_pageNo(1));
        }

        _store.dispatch(UpdateAdminLL_Leads_isloding(false));
        _store.dispatch(UpdateAdminLL_leadstenantDatalist(leadTenantDatalist));
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getLeadsTenantListExportCSV(BuildContext context) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_Landlord_LeadsList,
      "Reqtokens": {
        "Application Received": "1",
      },
      "LoadLookUpValues": true,
      "LoadRecordInfo": true,
      "Sort": [
        {"FieldID": "ID", "SortSequence": 1}
      ]
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        loader.remove();
        var data = jsonDecode(respoce);

        List<LeadTenantData> leadTenantDatalist = <LeadTenantData>[];

        if (data['Result'].length > 0) {
          leadTenantDatalist = (data['Result'] as List)
              .map((p) => LeadTenantData.fromJson(p))
              .toList();
        }

        String csv;
        List<List<dynamic>> csvList = [];

        List csvHeaderTitle = [];
        csvHeaderTitle.add(GlobleString.ALLD_ID);
        csvHeaderTitle.add(GlobleString.ALLD_Tenant);
        csvHeaderTitle.add(GlobleString.ALLD_Email);
        csvHeaderTitle.add(GlobleString.ALLD_PhoneNumber);
        csvHeaderTitle.add(GlobleString.ALLD_Rating);
        csvHeaderTitle.add(GlobleString.ALLD_LandlordName);
        csvHeaderTitle.add(GlobleString.ALLD_Property_Name);

        csvList.add(csvHeaderTitle);

        for (var data in leadTenantDatalist.toSet()) {
          List row = [];

          row.add(data.id);
          row.add(data.applicantName);
          row.add(data.email);
          row.add(data.mobileNumber);
          row.add(data.rating);
          row.add(data.landlordName);
          row.add(data.propertyName);
          csvList.add(row);
        }

        csv = const ListToCsvConverter().convert(csvList);

        String filename = "LeadsTenantDataList_" +
            DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
            ".csv";

        // prepare
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = filename;

        html.document.body!.children.add(anchor);
        anchor.click();
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getPropertyDetailsByID(BuildContext context, String propertyid,
      CallBackQuesy CallBackQuesy) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getPropertyRestriction(context, propertyid,
        (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(UpdateAdminSummeryRestrictionlist(restrictionlist));
      } else {
        _store.dispatch(UpdateAdminSummeryRestrictionlist([]));
      }
    });

    ApiManager().getPropertyAmanityUtility(context, propertyid,
        (status, responce, amenitieslist, utilitylist) {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        _store.dispatch(UpdateAdminSummeryPropertyAmenitiesList(amenitieslist));
        _store.dispatch(UpdateAdminSummeryPropertyUtilitiesList(utilitylist));
      } else {
        _store.dispatch(UpdateAdminSummeryPropertyAmenitiesList([]));
        _store.dispatch(UpdateAdminSummeryPropertyUtilitiesList([]));
      }
    });

    ApiManager().getPropertyImagesDSQ(context, propertyid,
        (status, responce, PropertyImageMediaInfolist) {
      if (status) {
        _store.dispatch(
            UpdateAdminSummeryPropertyImageList(PropertyImageMediaInfolist));
      } else {
        _store.dispatch(UpdateAdminSummeryPropertyImageList([]));
      }
    });

    await ApiManager().getPropertyDetails(context, propertyid,
        (status, responce, propertyData) async {
      if (status) {
        loader.remove();
        await bindPropertyData(propertyData!);
        CallBackQuesy(true, responce);
      } else {
        loader.remove();
        CallBackQuesy(false, responce);
      }
    });
  }

  bindPropertyData(PropertyData propertyData) {
    //DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(propertyData.dateAvailable);

    DateTime tempDate = DateTime.parse(propertyData.dateAvailable!);

    /*Summery*/

    _store.dispatch(
        UpdateAdminSummeryProperTytypeValue(propertyData.propertyType));
    _store.dispatch(UpdateAdminSummeryPropertyTypeOtherValue(
        propertyData.otherPropertyType!));
    _store.dispatch(UpdateAdminSummeryDateofavailable(tempDate));
    _store
        .dispatch(UpdateAdminSummeryRentalSpaceValue(propertyData.rentalSpace));
    _store.dispatch(UpdateAdminSummeryPropertyName(propertyData.propertyName!));
    _store.dispatch(
        UpdateAdminSummeryPropertyAddress(propertyData.propertyAddress!));
    _store.dispatch(UpdateAdminSummeryPropertyDescription(
        propertyData.propertyDescription!));
    _store.dispatch(UpdateAdminSummerySuiteunit(propertyData.suiteUnit!));
    _store.dispatch(UpdateAdminSummeryBuildingname(propertyData.buildingName!));
    _store.dispatch(UpdateAdminSummeryPropertyCity(propertyData.city!));
    _store.dispatch(
        UpdateAdminSummeryPropertyCountryCode(propertyData.countryCode!));
    _store
        .dispatch(UpdateAdminSummeryPropertyCountryName(propertyData.country!));
    _store.dispatch(UpdateAdminSummeryPropertyProvince(propertyData.province!));
    _store.dispatch(
        UpdateAdminSummeryPropertyPostalcode(propertyData.postalCode!));
    _store.dispatch(
        UpdateAdminSummeryPropertyRentAmount(propertyData.rentAmount!));
    _store.dispatch(UpdateAdminSummeryRentPaymentFrequencyValue(
        propertyData.rentPaymentFrequency));
    _store.dispatch(UpdateAdminSummeryLeaseTypeValue(propertyData.leaseType));
    _store.dispatch(UpdateAdminSummeryMinimumLeasedurationValue(
        propertyData.minLeaseDuration));
    _store.dispatch(UpdateAdminSummeryMinimumleasedurationNumber(
        propertyData.minLeaseNumber.toString()));
    _store
        .dispatch(UpdateAdminSummeryPropertyImage(propertyData.propertyImage));
    _store.dispatch(UpdateAdminSummeryPropertyUint8List(null));
    _store.dispatch(
        UpdateAdminSummeryPropertyBedrooms(propertyData.bedrooms.toString()));
    _store.dispatch(
        UpdateAdminSummeryPropertyBathrooms(propertyData.bathrooms.toString()));
    _store.dispatch(UpdateAdminSummeryPropertySizeinsquarefeet(
        propertyData.size.toString()));
    _store.dispatch(
        UpdateAdminSummeryPropertyMaxoccupancy(propertyData.maxOccupancy!));
    _store.dispatch(UpdateAdminSummeryFurnishingValue(propertyData.furnishing));
    _store.dispatch(UpdateAdminSummeryOtherPartialFurniture(
        propertyData.otherPartialFurniture.toString()));
    _store
        .dispatch(UpdateAdminSummeryParkingstalls(propertyData.parkingStalls!));
    _store.dispatch(
        UpdateAdminSummeryStorageAvailableValue(propertyData.storageAvailable));
    _store.dispatch(UpdateAdminSummeryAgreeTCPP(propertyData.isAgreedTandC!));
    _store.dispatch(
        UpdateAdminSummeryPropertyDrafting(propertyData.PropDrafting!));
    _store.dispatch(UpdateAdminSummeryPropertyVacancy(propertyData.Vacancy!));
  }

  /*======================================================================*/
  /*===========================    Team Management   =====================*/
  /*======================================================================*/

  AdminRegisterApi(BuildContext context, String email, String password,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "Email": email,
      "Password": password,
      "Role": Weburl.Super_Admin_Role,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().Register(context, json, (error, respoce) async {
      if (error) {
        var responce = jsonDecode(respoce);
        var result = responce['Result'];
        var Token = result['Token'];

        //await Prefs.setString(PrefsName.userTokan, Token);

        var user = result['user'];
        var Attributes = user['Attributes'];
        var Id = Attributes['Id'];

        Helper.Log("Token", Token);

        CallBackQuesy(true, Id);
      } else {
        Helper.Log("responce", respoce);
        CallBackQuesy(false, respoce);
      }
    });
  }

  InsetNewAdminUser(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQuery(POJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        CallBackQuesy(true, "");
      } else {
        Helper.Log("respoce", respoce);
        CallBackQuesy(false, "");
      }
    });
  }

  getTeamMangList(BuildContext context, String json, int ftime) async {
    /* OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<LandLordData> landlorddatalist = <LandLordData>[];

        if (data['Result'].length > 0) {
          landlorddatalist = (data['Result'] as List)
              .map((p) => LandLordData.fromJson(p))
              .toList();
        }

        if (ftime == 0) {
          if (landlorddatalist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateAdminTeam_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdateAdminTeam_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdateAdminTeam_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateAdminTeam_totalpage(1));
          }
          _store.dispatch(UpdateAdminTeam_pageNo(1));
        }

        _store.dispatch(UpdateAdminTeam_isloding(false));
        _store.dispatch(UpdateAdminTeam_datalist(landlorddatalist));
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getTeamMangListExport(BuildContext context) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "DSQID": Weburl.Admin_LandlordList,
      "Reqtokens": {"Roles": Weburl.Super_Admin_RoleID},
      "LoadLookUpValues": true,
      "Sort": [
        {"FieldID": "Owner_ID", "SortSequence": 1}
      ]
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<LandLordData> landlorddatalist = <LandLordData>[];

        if (data['Result'].length > 0) {
          landlorddatalist = (data['Result'] as List)
              .map((p) => LandLordData.fromJson(p))
              .toList();

          String csv;
          List<List<dynamic>> csvList = [];

          List csvHeaderTitle = [];
          csvHeaderTitle.add(GlobleString.TM_ID);
          csvHeaderTitle.add(GlobleString.TM_Name);
          csvHeaderTitle.add(GlobleString.TM_Email);
          csvHeaderTitle.add(GlobleString.TM_PhoneNumber);
          csvHeaderTitle.add(GlobleString.PH_Active_Inactive);

          csvList.add(csvHeaderTitle);

          for (var data in landlorddatalist.toSet()) {
            List row = [];
            row.add(data.id);
            row.add(data.landlordName);
            row.add(data.email);
            row.add(data.phoneNumber);
            row.add(data.activeInactive! ? "Active" : "InActive");

            csvList.add(row);
          }

          csv = const ListToCsvConverter().convert(csvList);

          String filename = "TeamManagementDataList_" +
              DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
              ".csv";

          // prepare
          final bytes = utf8.encode(csv);
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.document.createElement('a') as html.AnchorElement
            ..href = url
            ..style.display = 'none'
            ..download = filename;

          html.document.body!.children.add(anchor);
          anchor.click();
        }
        loader.remove();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  UpdateAdminTeamProfile(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, "");
      }
    });
  }

  AddCSVFile(
      BuildContext context, Uint8List data, CallBackQuesy CallBackQuesy) async {
    List<int> _selectedFile = data;

    String filepath = '${DateTime.now().millisecondsSinceEpoch}.csv';

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    var multipartRequest =
        new http.MultipartRequest("POST", Uri.parse(Weburl.FileUpload_Api));

    multipartRequest.headers.addAll(headers);

    multipartRequest.files.add(await http.MultipartFile.fromBytes(
        'file', _selectedFile,
        contentType: new MediaType('application', 'csv'), filename: filepath));

    await multipartRequest.send().then((result) {
      //print('admin');
      if (result.statusCode == 200) {
        http.Response.fromStream(result).then((response) {
          if (response.statusCode == 200) {
            if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
              var data = jsonDecode(response.body);

              if (data != null) {
                for (int i = 0; i < data['Result'].length; i++) {
                  var myobject = data['Result'][i];

                  String MediaID = myobject['MediaID'] != null
                      ? "" + myobject['MediaID'].toString()
                      : "";

                  String url = myobject['url'] != null
                      ? "" + myobject['url'].toString()
                      : "";

                  CallBackQuesy(true, MediaID);
                }
              } else {
                CallBackQuesy(false, GlobleString.Error);
              }
            } else {
              CallBackQuesy(false, GlobleString.Error);
            }
          } else if (response.statusCode == 401) {
            CallBackQuesy(false, GlobleString.Error_401);
          } else {
            CallBackQuesy(false, GlobleString.Error);
          }
        });
      } else if (result.statusCode == 401) {
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    });
  }

  WorkFlowPropertyUpload(BuildContext context, String mediaid, String Owner_ID,
      CallBackQuesyError callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.workflow_Admin_Landlord_Property_Upload,
      "Reqtokens": {"ID": mediaid, "Owner_ID": Owner_ID}
    };

    String json = jsonEncode(myjson);

    Helper.Log("Property Upload", json);

    HttpClientCall().WorkFlowExecuteCSVAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        Helper.Log("WorkFlowPropertyUpload ", respoce);
        List<BulkProperty> bulkPropertylist = <BulkProperty>[];

        if (data['Result'].length > 0)
          callBackQuesy(true, "", bulkPropertylist);
        else {
          if (data['Log'].length > 0) {
            String myobject = data['Log'][0].toString();
            var logdata = jsonDecode(myobject);

            if (logdata.length > 0) {
              bulkPropertylist = (logdata as List)
                  .map((p) => BulkProperty.fromJson(p))
                  .toList();
            }

            if (bulkPropertylist.length > 0) {
              callBackQuesy(false, "1", bulkPropertylist);
            } else {
              callBackQuesy(false, "2", bulkPropertylist);
            }
          } else {
            callBackQuesy(false, "2", bulkPropertylist);
          }
        }
      } else {
        List<BulkProperty> bulkPropertylist = <BulkProperty>[];
        Helper.Log("WorkFlowPropertyUpload ", respoce);
        callBackQuesy(false, "", bulkPropertylist);
      }
    });
  }

  DeleteTeamManagement(BuildContext context, Object POJO1, Object POJO2,
      CallBackQuesy CallBackQuesy) {
    List<QueryObject> queryList = <QueryObject>[];

    String User_query = QueryFilter().DeleteQuery(POJO2, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    var querydecode2 = jsonDecode(User_query);
    QueryObject uquery = QueryObject.fromJson(querydecode2);

    String person_query = QueryFilter().DeleteQuery(POJO1, etableName.Person,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    var querydecode1 = jsonDecode(person_query);
    QueryObject pquery = QueryObject.fromJson(querydecode1);

    queryList.add(uquery);
    queryList.add(pquery);

    String json = jsonEncode(queryList);

    HttpClientCall().QueryAPICall(context, json, (error, respoce) async {
      if (error) {
        List data = jsonDecode(respoce) as List;

        bool issuccess = false;

        for (int i = 0; i < data.length; i++) {
          var myobject = data[i];

          String StatusCode = myobject['StatusCode'] != null
              ? myobject['StatusCode'].toString()
              : "";

          if (StatusCode.isEmpty || StatusCode != "200") {
            issuccess = true;
            CallBackQuesy(false, "");
            break;
          }

          if ((data.length - 1) == i && !issuccess) {
            CallBackQuesy(true, "");
          }
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  /*======================================================================*/
  /*===========================   Website Under maintenance   =====================*/
  /*======================================================================*/

  UnderMaintenanceDetails(BuildContext context) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {"DSQID": Weburl.Admin_website_maintenance, "Reqtokens": {}};

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        loader.remove();
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          var myobject = data['Result'][0];

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;
          bool Status = myobject['Status'] != null ? myobject['Status'] : false;
          String Title = myobject['Maintenance_Title'] != null
              ? myobject['Maintenance_Title']
              : "";
          String Instruction = myobject['Maintenance_Instruction'] != null
              ? myobject['Maintenance_Instruction']
              : "";

          _store.dispatch(UpdateAdminSettingID(ID));
          _store.dispatch(UpdateAdminSettingisMaintenance(Status));
          _store.dispatch(UpdateAdminSettingTitle(Title));
          _store.dispatch(UpdateAdminSettingInstruction(Instruction));
          _store.dispatch(UpdateAdminSettingisLoading(false));
        } else {
          _store.dispatch(UpdateAdminSettingID(0));
          _store.dispatch(UpdateAdminSettingisMaintenance(false));
          _store.dispatch(UpdateAdminSettingTitle(""));
          _store.dispatch(UpdateAdminSettingInstruction(""));
          _store.dispatch(UpdateAdminSettingisLoading(false));
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
        _store.dispatch(UpdateAdminSettingisLoading(false));
      }
    });
  }

  InsetNewUnderMaintenance(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQuery(
        POJO,
        etableName.Website_under_Maintenance,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        CallBackQuesy(true, "");
      } else {
        Helper.Log("respoce", respoce);
        CallBackQuesy(false, "");
      }
    });
  }

  UpdateUnderMaintenance(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Website_under_Maintenance,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, "");
      }
    });
  }
}

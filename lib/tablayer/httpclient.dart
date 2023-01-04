import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/entities/LandlordProfile.dart';
import 'package:silverhome/domain/entities/applicant_currenttenancy.dart';
import 'package:silverhome/domain/entities/applicant_details.dart';
import 'package:silverhome/domain/entities/application_details.dart';
import 'package:silverhome/domain/entities/bulk_property.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/emailcheck.dart';
import 'package:silverhome/domain/entities/employment_details.dart';
import 'package:silverhome/domain/entities/event_typesdata.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/domain/entities/maintenance_details.dart';
import 'package:silverhome/domain/entities/maintenance_vendor.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';
import 'package:silverhome/domain/entities/ownerdata.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/domain/entities/property_maintenance_images.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/domain/entities/userinfo.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';

typedef CallBackListQuesy = void Function(
    bool status, List<String> responce, String message);
typedef CallBackDocList = void Function(
    bool status, String message, List<GetListDocument> allListData);
typedef CallBackQuesy = void Function(bool status, String responce);

typedef CallBackApplicant = void Function(
    bool status, String responce, String Applicant_Id, String ApplicantionID);

typedef CallBackLandlordProfile = void Function(
    bool status, String responce, LandlordProfile? data);

typedef CallBackWelcome = void Function(bool status, String username,
    String email, String personid, String responce);

typedef CallBackLeadList = void Function(
    bool status, String message, List<TenancyApplication> allListData);

typedef CallBack = void Function(bool errorBool);

typedef CallBackUserInfo = void Function(bool status, UserInfo? responce);

typedef CallBackReferenceQuery = void Function(
    bool status, List<LeadReference> responce, String message);

typedef CallBackNotificationQuery = void Function(
    bool status, List<NotificationData> notificationlist, String message);

typedef CallBackFilterProperty = void Function(
    bool status, String responce, List<FilterPropertyItem> propertylist);

typedef CallBackFilterCity = void Function(
    bool status, String responce, List<FilterCityItem> citylist);
typedef CallBackQuesyError = void Function(
    bool status, String title, List<BulkProperty> errorlist);
typedef CallBackMaintenancePro = void Function(
    bool status, String responce, List<PropertyDropData> errorlist);
typedef CallBackTemplate = void Function(
    bool status, String responce, List<EventTypesTemplate> errorlist);
typedef CallBackLink = void Function(
    bool status, String responce, List errorlist);
typedef CallBackQuesyEmailExit = void Function(
    bool status, String responce, List<EmailExit> EmailExitlist);
typedef CallBackCountry = void Function(
    bool status, String responce, List<CountryData> errorlist);
typedef CallBackState = void Function(
    bool status, String responce, List<StateData> errorlist);
typedef CallBackCity = void Function(
    bool status, String responce, List<CityData> errorlist);
typedef CallBackVendorDatalist = void Function(
    bool status, String responce, List<VendorData> vendorDatalist);
typedef CallBackVendorData = void Function(
    bool status, String responce, VendorData vendorData);
typedef CallBackMaintenanceDetails = void Function(
    bool status, String responce, MaintenanceDetails? maintenanceDetails);

typedef CallBackPropertyDetails = void Function(
    bool status, String responce, PropertyData? propertyData);

typedef CallBackEventTypesDetails = void Function(
    bool status, String responce, EventTypesData? eventtypesData);
typedef CallBackAmntUtltlist = void Function(
    bool status,
    String responce,
    List<PropertyAmenitiesUtility> amenitieslist,
    List<PropertyAmenitiesUtility> utilitylist);
typedef CallBackPropertyImages = void Function(bool status, String responce,
    List<PropertyImageMediaInfo> PropertyImageMediaInfolist);
typedef CallBackRestriction = void Function(
    bool status, String responce, List<SystemEnumDetails> restrictionlist);

typedef CallBackApplicantDetails = void Function(
    bool status, String responce, ApplicantDetails? applicantDetails);
typedef CallBackApplicationDetails = void Function(
    bool status,
    String responce,
    ApplicationDetails? applicationDetails,
    PropertyData? propdata,
    OwnerData? ownerdata);

typedef CallBackAdditionalOccupant = void Function(
    bool status, String responce, List<TenancyAdditionalOccupant> occupantlist);
typedef CallBackAdditionalReference = void Function(bool status,
    String responce, List<TenancyAdditionalReference> referencelist);
typedef CallBackApplicatCurrentTenancy = void Function(bool status,
    String responce, ApplicatCurrentTenancy? applicatCurrentTenancy);
typedef CallBackEmployemantDetails = void Function(
    bool status, String responce, EmployemantDetails? employemantDetails);
typedef CallBackPetslist = void Function(
    bool status, String responce, List<Pets> petslist);

typedef CallBackVehicallist = void Function(
    bool status, String responce, List<Vehical> vehicallist);

typedef CallBackMaintenanceVendorlist = void Function(bool status,
    String responce, List<MaintenanceVendor> maintenanceVendorlist);
typedef CallBackMaintenanceImageslist = void Function(bool status,
    String responce, List<PropertyMaintenanceImages> maintenanceImageslist);

typedef CallBackCheckUserExist = void Function(bool status, String response);
typedef CallBackListDocuments = void Function(bool status, List allListData);

class HttpClientCall {
  callNavigateLogin(BuildContext context) {
    navigateTo(context, RouteNames.Login);
  }

  /*--------selectAPI call--------*/
  selectAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    Helper.Log("Select Query", myjson);

    try {
      var response = await client.post(Uri.parse(Weburl.Select_Api),
          headers: headers, body: myjson);

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*--------deleteAPI call--------*/
  deleteAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.Delete_Api),
          headers: headers, body: myjson);

      Helper.Log("Responce", response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*--------updateAPI Call--------*/
  updateAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.Update_Api),
          headers: headers, body: myjson);

      Helper.Log("Responce", response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*--------InsertApi call--------*/
  insertAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.Insert_Api),
          headers: headers, body: myjson);

      Helper.Log("Responce", response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*--------QueryApi call--------*/
  QueryAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    Helper.Log("QueryAPICall  JSON", myjson);
    Helper.Log("QueryAPICall URI", Uri.parse(Weburl.Query_Api).toString());

    try {
      var response = await client.post(Uri.parse(Weburl.Query_Api),
          headers: headers, body: myjson);

      Helper.Log("Responce", response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        Helper.Log("DSQ", response.body.toString());

        /* if (jsonDecode(response.body)['StatusCode'].toString() == "200") {

        } else {
          CallBackQuesy(false, GlobleString.Error1);
        }*/
        CallBackQuesy(true, response.body);
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {}
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*--------RawSQL call--------*/
  RawSQLAPICall(
      BuildContext context, String url, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    Helper.Log("RawSQL_Api  URI", url);

    try {
      print(url);
      var response = await client.get(Uri.parse(url), headers: headers);

      //Helper.Log("Responce",  response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        Helper.Log("RawSQLAPICall ", response.body.toString());
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          print("RawSQLAPICall" + response.body.toString());
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {}
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*--------DSQAPI call--------*/
  DSQAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.DSQ_Api),
          headers: headers, body: myjson);

      //Helper.Log("Responce",  response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        var temp = jsonDecode(response.body);
        print(temp);
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error1);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  LinkS3APICall(String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.GetNamesS3),
          headers: headers, body: myjson);

      //Helper.Log("Responce",  response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        var temp = jsonDecode(response.body);
        print(temp);
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error1);
        }
      } else if (response.statusCode == 401) {
        //  callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  InsertMedia(String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.InsertMedia),
          headers: headers, body: myjson);

      //Helper.Log("Responce",  response.body.toString());
      Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        var temp = jsonDecode(response.body);
        print(temp);
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error1);
        }
      } else if (response.statusCode == 401) {
        //  callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  Future<void> CallAPIToken(
      BuildContext context, CallBackQuesy CallBackQuesy) async {
    var myjson = {"Email": "silverhomeapp@gmail.com", "Password": "Asdf1234.."};

    String json = jsonEncode(myjson);

    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true",
      //'Cache-Control': "no-cache",
      //'Pragma': "no-cache"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.login_Api),
          headers: headers, body: json);

      //Helper.Log("Responce", response.body.toString());
      //Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          var responce = jsonDecode(response.body);
          var result = responce['Result'];
          var Token = result['Token'];

          Helper.Log("Token", Token);

          CallBackQuesy(true, Token.toString());
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  Future<void> Login(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'ApplicationCode': Weburl.API_CODE
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true",
      //'Cache-Control': "no-cache",
      //'Pragma': "no-cache",
      //'Access-Control-Request-Headers': 'Content-Type'
    };

    try {
      var response = await client.post(Uri.parse(Weburl.login_Api),
          headers: headers, body: myjson);

      //Helper.Log("Responce", response.body.toString());
      //Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  Future<void> Register(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'ApplicationCode': Weburl.API_CODE,
      //'accept': '*/*',
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.register_Api),
          headers: headers, body: myjson);

      //Helper.Log("Responce",  response.body.toString());
      //Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  Future<void> ChangePassword(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.ChangePassword_Api),
          headers: headers, body: myjson);

      //Helper.Log("Responce",  response.body.toString());
      //Helper.Log("statusCode", response.statusCode.toString());

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.Error);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  /*--------WorkFlow/Execute Api call--------*/
  WorkFlowExecuteAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.WorkFlow_Api),
          headers: headers, body: myjson);

      if (response.statusCode == 200) {
        Helper.Log("Responce Workflow", jsonDecode(response.body).toString());

        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(
              false, jsonDecode(response.body)['Errors'][0].toString());
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }

  WorkFlowExecuteCSVAPICall(
      BuildContext context, String myjson, CallBackQuesy CallBackQuesy) async {
    var client = http.Client();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
      //'Access-Control-Allow-Origin': "*",
      //'Access-Control-Allow-Credentials': "true"
    };

    try {
      var response = await client.post(Uri.parse(Weburl.WorkFlow_Api),
          headers: headers, body: myjson);

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
          CallBackQuesy(true, response.body);
        } else {
          CallBackQuesy(false, GlobleString.CSV_Error_server);
        }
      } else if (response.statusCode == 401) {
        callNavigateLogin(context);
        CallBackQuesy(false, GlobleString.Error_401);
      } else {
        CallBackQuesy(false, GlobleString.Error);
      }
    } catch (e) {
      print(e);
      CallBackQuesy(false, GlobleString.Error_server);
    } finally {
      client.close();
      //CallBackQuesy(false, GlobleString.Error_server);
    }
  }
}

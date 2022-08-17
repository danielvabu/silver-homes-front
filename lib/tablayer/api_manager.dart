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
import 'package:silverhome/domain/actions/actions.dart';
import 'package:silverhome/domain/actions/basictenant_action/lease_details_actions.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_add_maintenance_action.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_maintenance_action.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_personal_action.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_portal_action.dart';
import 'package:silverhome/domain/actions/customer/customer_portal_action.dart';
import 'package:silverhome/domain/actions/customer/customer_property_details_actions.dart';
import 'package:silverhome/domain/actions/customer/customer_propertylist_action.dart';
import 'package:silverhome/domain/actions/landlord_action/editlead_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/funnelview_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_profile_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_activetenant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_applicant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lead_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_lease_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/landlordtenancyarchive_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/preview_document_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/preview_lease_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_disclosure_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertyform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertylist_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_questionnaire_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_questionnaire_details_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancy_lease_agreement_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancy_varification_doc_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/varification_document_actions.dart';
import 'package:silverhome/domain/actions/maintenance_action/edit_maintenance_action.dart';
import 'package:silverhome/domain/actions/maintenance_action/landlord_maintenance_action.dart';
import 'package:silverhome/domain/actions/maintenance_action/maintenance_details_action.dart';
import 'package:silverhome/domain/actions/vendor_action/landlord_vendor_action.dart';
import 'package:silverhome/domain/entities/LandlordProfile.dart';
import 'package:silverhome/domain/entities/applicant_currenttenancy.dart';
import 'package:silverhome/domain/entities/applicant_details.dart';
import 'package:silverhome/domain/entities/application_details.dart';
import 'package:silverhome/domain/entities/basic_tenant/addvendordata.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/emailcheck.dart';
import 'package:silverhome/domain/entities/employment_details.dart';
import 'package:silverhome/domain/entities/fileobject.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/domain/entities/log_activity.dart';
import 'package:silverhome/domain/entities/maintenance_data.dart';
import 'package:silverhome/domain/entities/maintenance_details.dart';
import 'package:silverhome/domain/entities/maintenance_vendor.dart';
import 'package:silverhome/domain/entities/notificationdata.dart';
import 'package:silverhome/domain/entities/ownerdata.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/property_drop_data.dart';
import 'package:silverhome/domain/entities/property_maintenance_images.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/propertylist.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/domain/entities/userinfo.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/e_table_names.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';

class ApiManager {
  final _store = getIt<AppStore>();
  late OverlayEntry loader;

  //--------x: OnlyFor Reference :x---------//

  SelectAPICall(Object POJO) {
    Helper.Log("In APIManager SelectQuery", ">>");
    String query = QueryFilter().SelectQuery(
        POJO,
        etableName.AdditionalOccupants,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo,
        false);
  }

  DeleteAPICall(Object POJO) {
    Helper.Log("In APIManager DeleteQuery", ">>");
    String query = QueryFilter().DeleteQuery(
        POJO,
        etableName.AdditionalOccupants,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);
  }

  InsetAPICall(Object POJO) {
    Helper.Log("In APIManager InsertQuery", ">>");
    String query = QueryFilter().InsertQuery(
        POJO,
        etableName.AdditionalOccupants,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);
  }

  UpdateAPICall(Object ClausePOJO, Object UpdatePOJO) {
    Helper.Log("In APIManager UpdateQuery", ">>");
    QueryFilter().UpdateQuery(
        ClausePOJO,
        UpdatePOJO,
        etableName.AdditionalOccupants,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);
  }

  //----------------------------x: Required API :x---------------------------//

  getSystemEnumCallDSQ(
      BuildContext context, CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_SYSTEMENUM.toString(),
      "Reqtokens": {
        "ID":
            "1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,2184,3184,3186,3187,3188"
      }
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        List<SystemEnumDetails> list;
        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;
        list = rest
            .map<SystemEnumDetails>((json) => SystemEnumDetails.fromJson(json))
            .toList();

        await Prefs.setString(PrefsName.systemEnumDetails, jsonEncode(list));
        CallBackQuesy(true, "");
      } else {
        Helper.Log("getSystemEnumCall", respoce);
        CallBackQuesy(false, respoce);
      }
    });
  }

  /*==============================================================================*/
  /*========================     Authentication     =============================*/
  /*==============================================================================*/

  LoginApi(BuildContext context, String email, String password,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "Email": email,
      "Password": password,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().Login(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("responce", respoce);

        var responce = jsonDecode(respoce);
        var result = responce['Result'];
        var Token = result['Token'];

        Helper.Log("Token", Token);

        await Prefs.setString(PrefsName.userTokan, Token);

        var user = result['user'];
        var Attributes = user['Attributes'];
        var Id = Attributes['Id'];

        CallBackQuesy(true, Id.toString());
      } else {
        Helper.Log("LoginApi respoce", respoce);

        CallBackQuesy(false, respoce);
      }
    });
  }

  userCheckActive(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) async {
    String query = await QueryFilter().SelectQuery(POJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        bool IsActive =
            rest[0]["IsActive"] != null ? rest[0]["IsActive"] : false;

        if (IsActive) {
          CallBackQuesy(true, "");
        } else {
          CallBackQuesy(false, "1");
        }
      } else {
        Helper.Log("userCheckActive respoce", respoce);
        CallBackQuesy(false, respoce);
      }
    });
  }

  userLoginDSQCall(
      BuildContext context, String UserID, CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_UserLogin.toString(),
      "LoadLookupValues": true,
      "Reqtokens": {"UserID": UserID}
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("userLoginDSQCall", respoce);

        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        if (data["Result"].length > 0) {
          bool IsActive =
              rest[0]["IsActive"] != null ? rest[0]["IsActive"] : false;

          bool adminsideIsActive = rest[0]["AdminsideIsActive"] != null
              ? rest[0]["AdminsideIsActive"]
              : false;

          if (IsActive) {
            if (adminsideIsActive) {
              var Roles = rest[0]["Roles"];
              var RoleId = Roles["Id"];

              var ID = rest[0]["ID"].toString();

              String CustomerFeatureListingURL =
                  rest[0]["CustomerFeatureListingURL"] != null
                      ? rest[0]["CustomerFeatureListingURL"].toString()
                      : "";

              String CompanyName = rest[0]["CompanyName"] != null
                  ? rest[0]["CompanyName"].toString()
                  : "";

              var PersonID = rest[0]["PersonID"];

              var Email = PersonID['Email'];
              var FirstName = PersonID['FirstName'];
              var LastName = PersonID['LastName'];

              if (RoleId == Weburl.Super_Admin_RoleID) {
                await Prefs.setString(PrefsName.admin_ID, ID);
                await Prefs.setString(PrefsName.admin_Email, Email);
                await Prefs.setString(PrefsName.admin_fname, FirstName);
                await Prefs.setString(PrefsName.admin_lname, LastName);
                await Prefs.setBool(PrefsName.Is_adminlogin, true);
              } else {
                await Prefs.setString(PrefsName.OwnerID, ID);
                await Prefs.setString(PrefsName.user_Email, Email);
                await Prefs.setString(PrefsName.user_fname, FirstName);
                await Prefs.setString(PrefsName.user_lname, LastName);
                await Prefs.setString(PrefsName.user_CustomerFeatureListingURL,
                    CustomerFeatureListingURL);
                await Prefs.setString(PrefsName.user_CompanyName, CompanyName);
                await Prefs.setBool(PrefsName.Is_adminlogin, false);
              }

              await Prefs.setBool(PrefsName.Is_login, true);

              CallBackQuesy(true, RoleId);
            } else {
              CallBackQuesy(false, "2");
            }
          } else {
            CallBackQuesy(false, "1");
          }
        } else {
          CallBackQuesy(false, "3");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  CheckUserAccountExistDSQCall(BuildContext context, String email,
      CallBackCheckUserExist callbackUserExist) {
    var myjson = {
      "DSQID": Weburl.DSQ_CheckUserExist,
      "Reqtokens": {"email": email},
      "LoadLookupValues": false
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (status, responce) {
      if (status) {
        Map data = jsonDecode(responce);
        List users = data['Result'] ?? [];
        if (users.isEmpty) {
          callbackUserExist(false, responce);
        } else {
          Map userdata = users[0];
          if (userdata['UserName'] == email) {
            callbackUserExist(true, responce);
          } else {
            callbackUserExist(false, responce);
          }
        }
      } else {
        callbackUserExist(false, responce);
      }
    });
  }

  welcomeMailWorkflow(
      BuildContext context, String userid, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.Welcome_workflow,
      "Reqtokens": {
        "UserID": userid,
        "HostURL": Weburl.Email_URL,
        "DbAppCode": Weburl.API_CODE,
      }
    };

    String json = jsonEncode(myjson);

    Helper.Log("welcomeMailWorkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  UserDetails(
      BuildContext context, Object POJO, CallBackWelcome CallBackQuesy) async {
    String query = await QueryFilter().SelectQuery(POJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, true);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        var ID = rest[0]["ID"].toString();
        var PersonID = rest[0]["PersonID"];

        var Person_ID = PersonID['ID'].toString();
        var Email = PersonID['Email'];
        var FirstName = PersonID['FirstName'];
        //var LastName = PersonID['LastName'];

        CallBackQuesy(true, FirstName, Email, Person_ID, ID);
      } else {
        CallBackQuesy(false, "", "", "", respoce);
      }
    });
  }

  UpdateUserAccount(BuildContext context, Object CPOJO, Object UpPOJO,
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

  RegisterApi(BuildContext context, String email, String password, String Role,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "Email": email,
      "Password": password,
      "Role": Role,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().Register(context, json, (error, respoce) async {
      if (error) {
        var responce = jsonDecode(respoce);
        var result = responce['Result'];
        var Token = result['Token'];

        await Prefs.setString(PrefsName.userTokan, Token);

        var user = result['user'];
        var Attributes = user['Attributes'];
        var Id = Attributes['Id'];

        Helper.Log("Token", Token);
        CallBackQuesy(true, Id);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  InsetNewUser(BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQuery(POJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, "");
      } else {
        CallBackQuesy(false, "");
      }
    });
  }

  userProfileDSQCall(
      BuildContext context, String UserID, CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_User_ProfileDetails.toString(),
      "LoadLookupValues": true,
      "Reqtokens": {"ID": UserID}
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        Helper.Log("userProfileDSQCall", respoce);

        var rest = data["Result"] as List;

        String ID = rest[0]["ID"] != null ? rest[0]["ID"].toString() : "";

        String CompanyName = rest[0]["CompanyName"] != null
            ? rest[0]["CompanyName"].toString()
            : "";

        String HomePageLink = rest[0]["HomePageLink"] != null
            ? rest[0]["HomePageLink"].toString()
            : "";

        String CustomerFeatureListingURL =
            rest[0]['CustomerFeatureListingURL'] != null
                ? rest[0]['CustomerFeatureListingURL']
                : "";

        MediaInfo? Company_logo = rest[0]['Company_logo'] != null
            ? MediaInfo.fromJson(rest[0]['Company_logo'])
            : null;

        var PersonID = rest[0]["PersonID"];

        String pID = PersonID['ID'] != null ? PersonID['ID'].toString() : "";
        String Email =
            PersonID['Email'] != null ? PersonID['Email'].toString() : "";
        String FirstName = PersonID['FirstName'] != null
            ? PersonID['FirstName'].toString()
            : "";
        String LastName =
            PersonID['LastName'] != null ? PersonID['LastName'].toString() : "";
        String Country_Code =
            PersonID['Country_Code'] != null && PersonID['Country_Code'] != ""
                ? PersonID['Country_Code'].toString()
                : "CA";
        String Dial_Code =
            PersonID['Dial_Code'] != null && PersonID['Dial_Code'] != ""
                ? PersonID['Dial_Code'].toString()
                : "+1";
        String MobileNumber = PersonID['MobileNumber'] != null
            ? PersonID['MobileNumber'].toString()
            : "";

        _store.dispatch(UpdateLandlordProfileID(ID));
        _store.dispatch(UpdateLandlordProfileCompanyname(CompanyName));
        _store.dispatch(UpdateLandlordProfileHomepagelink(HomePageLink));
        _store.dispatch(UpdateLandlordProfileCustomerFeatureListingURL(
            CustomerFeatureListingURL));
        _store.dispatch(UpdateLandlordProfileCustomerFeatureListingURL_update(
            CustomerFeatureListingURL));
        _store.dispatch(UpdateLandlordProfileCompanylogo(Company_logo));
        _store.dispatch(UpdateLandlordProfileUint8List(null));

        _store.dispatch(UpdateLandlordProfilePersonID(pID));
        _store.dispatch(UpdateLandlordProfileFirstname(FirstName));
        _store.dispatch(UpdateLandlordProfileLastname(LastName));
        _store.dispatch(UpdateLandlordProfileEmail(Email));
        _store.dispatch(UpdateLandlordProfilePhonenumber(MobileNumber));
        _store.dispatch(UpdateLandlordProfileCountrycode(Country_Code));
        _store.dispatch(UpdateLandlordProfileDialcode(Dial_Code));

        CallBackQuesy(
            true,
            (Company_logo != null && Company_logo.url != null
                ? Company_logo.url.toString()
                : ""));
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  UpdateProfileData(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, Result);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  getUserProfile(BuildContext context) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().userProfileDSQCall(context, Prefs.getString(PrefsName.OwnerID),
        (error, respoce2) {
      if (error) {
        loader.remove();
        _store.dispatch(UpdatePortalPage(7, GlobleString.NAV_Profile));
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce2, false);
      }
    });
  }

  /*==============================================================================*/
  /*========================  Property OnBoarding  =============================*/
  /*==============================================================================*/

  getPropertyIdForApplication(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) async {
    String query = await QueryFilter().SelectQuery(POJO, etableName.Application,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        String Prop_ID =
            rest[0]["Prop_ID"] != null ? rest[0]["Prop_ID"] : false;

        CallBackQuesy(true, Prop_ID);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  getPropertyStatusCount(BuildContext context, String Ownerid) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_PropertyStatusCount,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": Ownerid}
    };

    String json = jsonEncode(myjson);

    Helper.Log("getPropertyStatusCount", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);
        Helper.Log("getPropertyStatusCount", respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          int VacantUnits =
              myobject['Vacant Units'] != null ? myobject['Vacant Units'] : 0;
          int UnitsRented =
              myobject['Units Rented'] != null ? myobject['Units Rented'] : 0;
          int UnitsHeld =
              myobject['Units Held'] != null ? myobject['Units Held'] : 0;

          _store.dispatch(UpdatePropertyStatus_UnitsHeld(UnitsHeld));
          _store.dispatch(UpdatePropertyStatus_UnitsRented(UnitsRented));
          _store.dispatch(UpdatePropertyStatus_VacantUnits(VacantUnits));
        }
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  InsertPropertyDetails(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().InsertQuery(POJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, Result);
        loader.remove();
      } else {
        loader.remove();
        CallBackQuesy(false, respoce);
      }
    });
  }

  UpdatePropertyDetails(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Property,
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

  deleteAllRestriction(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().DeleteQuery(
        POJO,
        etableName.Property_Restriction,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().deleteAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  AddPropertySpecificatinRestriction(BuildContext context, List<Object> POJO,
      Object CPOJO, Object UpPOJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> queryList = <QueryObject>[];

    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);
    var querydecode = jsonDecode(query);
    QueryObject updatequery = QueryObject.fromJson(querydecode);

    for (int i = 0; i < POJO.length; i++) {
      String queryinsert = QueryFilter().InsertQuery(
          POJO[i],
          etableName.Property_Restriction,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      queryList.add(insetquery);
    }

    queryList.add(updatequery);
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

        _store.dispatch(UpdatePropertyAmenitiesList(amenitieslist));
        _store.dispatch(UpdatePropertyUtilitiesList(utilitylist));

        List<PropertyAmenitiesUtility> secondAmenityList = summery_amenitieslist
            .map((item) => new PropertyAmenitiesUtility.clone(item))
            .toList();

        _store.dispatch(
            UpdateSummeryPropertyAmenitiesList(List.from(secondAmenityList)));

        List<PropertyAmenitiesUtility> secondUtilityList = summery_utilitylist
            .map((item) => new PropertyAmenitiesUtility.clone(item))
            .toList();

        _store.dispatch(
            UpdateSummeryPropertyUtilitiesList(List.from(secondUtilityList)));

        _store.dispatch(UpdateCPDPropertyAmenitiesList(summery_amenitieslist));
        _store.dispatch(UpdateCPDPropertyUtilitiesList(summery_utilitylist));
      } else {
        Helper.Log("responce", respoce);
      }
    });
  }

  deleteAllAmenitiesUtilities(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().DeleteQuery(
        POJO,
        etableName.Property_Amenities_Utilities,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().deleteAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  AddPropertyFeature(BuildContext context, List<Object> POJO, Object CPOJO,
      Object UpPOJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);
    var querydecode = jsonDecode(query);
    QueryObject updatequery = QueryObject.fromJson(querydecode);

    for (int i = 0; i < POJO.length; i++) {
      String queryinsert = QueryFilter().InsertQuery(
          POJO[i],
          etableName.Property_Amenities_Utilities,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      query_list.add(insetquery);
    }
    query_list.add(updatequery);
    String json = jsonEncode(query_list);

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

  AddSingleImage(
      BuildContext context, Uint8List data, CallBackQuesy CallBackQuesy) async {
    List<int> _selectedFile = data;

    String filepath = '${DateTime.now().millisecondsSinceEpoch}.png';
    // String filepath = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    var multipartRequest =
        new http.MultipartRequest("POST", Uri.parse(Weburl.FileUpload_Api));

    multipartRequest.headers.addAll(headers);

    multipartRequest.files.add(await http.MultipartFile.fromBytes(
        'file[]', _selectedFile,
        contentType: new MediaType('application', 'png'), filename: filepath));

    await multipartRequest.send().then((result) {
      //print('AddSingleImage');
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

  UpdatePropertyDisclosure(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";

        CallBackQuesy(true, Result);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  getPropertyOnboadingList(BuildContext context, String json, int ftime) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    Helper.Log("Property", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<PropertyDataList> propertylist = <PropertyDataList>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

          String PropertyName = myobject['PropertyName'] != null
              ? myobject['PropertyName'].toString()
              : "";

          String Other_Property_Type = myobject['Other_Property_Type'] != null
              ? myobject['Other_Property_Type'].toString()
              : "";

          String Suite_Unit = myobject['Suite_Unit'] != null
              ? myobject['Suite_Unit'].toString()
              : "";

          bool IsActive =
              myobject['IsActive'] != null ? myobject['IsActive'] : false;

          bool IsAgreed_TandC = myobject['IsAgreed_TandC'] != null
              ? myobject['IsAgreed_TandC']
              : false;

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String Country =
              myobject['Country'] != null ? myobject['Country'].toString() : "";

          int PropDrafting =
              myobject['PropDrafting'] != null ? myobject['PropDrafting'] : 0;

          bool Vacancy =
              myobject['Vacancy'] != null ? myobject['Vacancy'] : false;

          bool IsPublished =
              myobject['IsPublished'] != null ? myobject['IsPublished'] : false;

          SystemEnumDetails? Property_Type = myobject['Property_Type'] != null
              ? SystemEnumDetails.fromJson(myobject['Property_Type'])
              : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          PropertyDataList propertyData = new PropertyDataList();
          propertyData.id = ID;
          propertyData.propertyName = PropertyName;
          propertyData.otherPropertyType = Other_Property_Type;
          propertyData.isActive = IsActive;
          propertyData.isAgreedTandC = IsAgreed_TandC;
          propertyData.city = City;
          propertyData.country = Country;
          propertyData.suiteUnit = Suite_Unit;
          propertyData.propertyType = Property_Type;
          propertyData.propDrafting = PropDrafting;
          propertyData.vacancy = Vacancy;
          propertyData.isPublished = IsPublished;
          propertyData.createdOn = CreatedOn;
          propertyData.updatedOn = UpdatedOn;

          propertylist.add(propertyData);
        }

        /* propertylist.sort((a, b) =>
            b.createdOn!.toLowerCase().compareTo(a.createdOn!.toLowerCase()));*/

        if (ftime == 0) {
          if (propertylist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdatePropertyListTotalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdatePropertyListTotalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdatePropertyListTotalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdatePropertyListTotalpage(1));
          }
          _store.dispatch(UpdatePropertyListPageNo(1));
        }

        _store.dispatch(UpdatePropertyListIsloding(false));
        _store.dispatch(UpdatePropertyList(propertylist));
      } else {
        // loader.remove();
        _store.dispatch(UpdatePropertyListIsloding(false));
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getAllPropertyOnboadingListCSV(BuildContext context, String json) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    /* var myjson = {
      "DSQID": Weburl.DSQ_PropertyOnBoardingList,
      "Reqtokens": {"Owner_ID": ownerid, "Name": ""},
      "LoadLookUpValues": true,
      "LoadRecordInfo": true,
      "Sort": [
        {"FieldID": "ID", "SortSequence": 1}
      ]
    };

    String json = jsonEncode(myjson);*/

    Helper.Log("Property", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          String csv;

          List<List<dynamic>> csvList = [];

          List csvHeaderTitle = [];
          csvHeaderTitle.add("Property Name");
          csvHeaderTitle.add("# of Unit");
          csvHeaderTitle.add("City");
          csvHeaderTitle.add("Country");
          csvHeaderTitle.add("Property Type");
          csvHeaderTitle.add("Vacancy");
          csvHeaderTitle.add("Active/Inactive");
          csvHeaderTitle.add("Publish");

          csvList.add(csvHeaderTitle);

          List<PropertyDataList> propertylist = <PropertyDataList>[];

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

            String PropertyName = myobject['PropertyName'] != null
                ? myobject['PropertyName'].toString()
                : "";

            String Other_Property_Type = myobject['Other_Property_Type'] != null
                ? myobject['Other_Property_Type'].toString()
                : "";

            String Suite_Unit = myobject['Suite_Unit'] != null
                ? myobject['Suite_Unit'].toString()
                : "";

            bool IsActive =
                myobject['IsActive'] != null ? myobject['IsActive'] : false;

            bool IsAgreed_TandC = myobject['IsAgreed_TandC'] != null
                ? myobject['IsAgreed_TandC']
                : false;

            String City =
                myobject['City'] != null ? myobject['City'].toString() : "";

            String Country = myobject['Country'] != null
                ? myobject['Country'].toString()
                : "";

            int PropDrafting =
                myobject['PropDrafting'] != null ? myobject['PropDrafting'] : 0;

            bool Vacancy =
                myobject['Vacancy'] != null ? myobject['Vacancy'] : false;

            bool IsPublished = myobject['IsPublished'] != null
                ? myobject['IsPublished']
                : false;

            SystemEnumDetails? Property_Type = myobject['Property_Type'] != null
                ? SystemEnumDetails.fromJson(myobject['Property_Type'])
                : null;

            /*RecordInfo*/

            var objRecordInfo = myobject["RecordInfo"];

            String CreatedOn = objRecordInfo['CreatedOn'] != null
                ? objRecordInfo['CreatedOn'].toString()
                : "0";

            String UpdatedOn = objRecordInfo['UpdatedOn'] != null
                ? objRecordInfo['UpdatedOn'].toString()
                : "0";

            PropertyDataList propertyData = new PropertyDataList();
            propertyData.id = ID;
            propertyData.propertyName = PropertyName;
            propertyData.otherPropertyType = Other_Property_Type;
            propertyData.isActive = IsActive;
            propertyData.isAgreedTandC = IsAgreed_TandC;
            propertyData.city = City;
            propertyData.country = Country;
            propertyData.suiteUnit = Suite_Unit;
            propertyData.propertyType = Property_Type;
            propertyData.propDrafting = PropDrafting;
            propertyData.vacancy = Vacancy;
            propertyData.isPublished = IsPublished;
            propertyData.createdOn = CreatedOn;
            propertyData.updatedOn = UpdatedOn;

            List row = [];
            row.add(PropertyName);
            row.add(Suite_Unit);
            row.add(City);
            row.add(Country);
            if (Property_Type != null) {
              if (Property_Type.EnumDetailID == 6) {
                row.add(Other_Property_Type);
              } else {
                row.add(Property_Type.displayValue);
              }
            } else {
              row.add("");
            }

            row.add(Vacancy);
            row.add(IsActive ? "Active" : "Inactive");
            row.add(IsPublished ? "true" : "false");

            csvList.add(row);
          }

          csv = const ListToCsvConverter().convert(csvList);

          String filename = "property_" +
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

          //property.csv

          html.document.body!.children.add(anchor);

          anchor.click();
        } else {
          ToastUtils.showCustomToast(
              context, GlobleString.Blank_Landloadview, false);
        }

        loader.remove();
      } else {
        loader.remove();

        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getPropertyDetails(BuildContext context, String id,
      CallBackPropertyDetails CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_PropertyDetails,
      "LoadLookUpValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("getPropertyDetails", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        //Helper.Log("getPropertyDetails", respoce);

        PropertyData propertyData = new PropertyData();

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

          bool IsPublished =
              myobject['IsPublished'] != null ? myobject['IsPublished'] : false;

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
          propertyData.IsPublished = IsPublished;
        }
        CallBackQuesy(true, respoce, propertyData);
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        CallBackQuesy(false, respoce, null);
      }
    });
  }

  getPropertyAmanityUtility(BuildContext context, String Id,
      CallBackAmntUtltlist CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_Property_AM_UT,
      "LoadLookUpValues": true,
      "Reqtokens": {"Prop_ID": Id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("getPropertyDetails", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        //Helper.Log("getPropertyDetails", respoce);

        List<PropertyAmenitiesUtility> amenitieslist =
            <PropertyAmenitiesUtility>[];

        List<PropertyAmenitiesUtility> utilitylist =
            <PropertyAmenitiesUtility>[];

        if (data['Result'] != null && data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            var Feature_ID =
                myobject['Feature_ID'] != null ? myobject['Feature_ID'] : null;

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

            SystemEnumDetails? Feature_Value = myobject['Feature_Value'] != null
                ? SystemEnumDetails.fromJson(myobject['Feature_Value'])
                : null;

            propertyAmenitiesUtility.value =
                Feature_Value!.EnumDetailID.toString();

            if (propertyAmenitiesUtility.Feature_Type == 1) {
              amenitieslist.add(propertyAmenitiesUtility);
            } else if (propertyAmenitiesUtility.Feature_Type == 2) {
              utilitylist.add(propertyAmenitiesUtility);
            }

            amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));

            utilitylist.sort((a, b) => a.id!.compareTo(b.id!));
          }
          CallBackQuesy(true, respoce, amenitieslist, utilitylist);
        } else {
          CallBackQuesy(false, respoce, [], []);
        }
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        CallBackQuesy(false, respoce, [], []);
      }
    });
  }

  getPropertyRestriction(BuildContext context, String Id,
      CallBackRestriction CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_Property_Restrictions,
      "LoadLookUpValues": true,
      "Reqtokens": {"Prop_ID": Id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("getPropertyRestriction", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        //Helper.Log("getPropertyDetails", respoce);

        List<SystemEnumDetails> restrictionlist = [];

        restrictionlist =
            await QueryFilter().PlainValues(eSystemEnums().Restrictions);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          SystemEnumDetails? Restrictions = myobject['Restrictions'] != null
              ? SystemEnumDetails.fromJson(myobject['Restrictions'])
              : null;

          for (int d = 0; d < restrictionlist.length; d++) {
            SystemEnumDetails restric = restrictionlist[d];

            if (restric.EnumDetailID == Restrictions!.EnumDetailID) {
              restrictionlist[d].ischeck = true;
            }
          }
        }
        CallBackQuesy(true, respoce, List.from(restrictionlist));
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        CallBackQuesy(false, respoce, []);
      }
    });
  }

  getPropertyRestriction_Customer(BuildContext context, String Id,
      CallBackRestriction CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_Property_Restrictions,
      "LoadLookUpValues": true,
      "Reqtokens": {"Prop_ID": Id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("getPropertyRestriction", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        //Helper.Log("getPropertyDetails", respoce);

        List<SystemEnumDetails> restrictionlist = [];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          SystemEnumDetails? Restrictions = myobject['Restrictions'] != null
              ? SystemEnumDetails.fromJson(myobject['Restrictions'])
              : null;

          Restrictions!.ischeck = true;
          restrictionlist.add(Restrictions);
        }
        CallBackQuesy(true, respoce, List.from(restrictionlist));
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        CallBackQuesy(false, respoce, []);
      }
    });
  }

  getPropertyImagesDSQ(BuildContext context, String Id,
      CallBackPropertyImages CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_Property_Images,
      "LoadLookUpValues": true,
      "Reqtokens": {"ID": Id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("getPropertyDetails", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        //Helper.Log("getPropertyDetails", respoce);

        List<PropertyImageMediaInfo> PropertyImageMediaInfolist = [];

        for (int i = 0; i < data['Result'].length; i++) {
          var PImages = data['Result'][i];

          String PID = PImages['ID'] != null ? PImages['ID'].toString() : "";

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

        CallBackQuesy(true, respoce, PropertyImageMediaInfolist);
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        CallBackQuesy(false, respoce, []);
      }
    });
  }

  UpdatePropertyActive(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, Result);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  TenantAvailableInProperty(BuildContext context, String Ownerid,
      String propertyid, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICATIONLIST_OWNERWISE,
      "LoadLookupValues": true,
      "Reqtokens": {"Owner_ID": Ownerid, "Prop_ID": propertyid, "IsArchived": 0}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          callBackQuesy(true, "1");
        } else {
          callBackQuesy(true, "2");
        }
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  bindPropertyData(PropertyData propertyData) {
    _store.dispatch(UpdateProperTytypeValue(propertyData.propertyType));
    _store.dispatch(
        UpdatePropertyTypeOtherValue(propertyData.otherPropertyType!));

    //DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(propertyData.dateAvailable);

    DateTime tempDate = DateTime.parse(propertyData.dateAvailable!);

    _store.dispatch(UpdateDateofavailable(tempDate));
    _store.dispatch(UpdateRentalSpaceValue(propertyData.rentalSpace));
    _store.dispatch(UpdatePropertyName(propertyData.propertyName!));
    _store.dispatch(UpdatePropertyAddress(propertyData.propertyAddress!));
    _store
        .dispatch(UpdatePropertyDescription(propertyData.propertyDescription!));
    _store.dispatch(UpdateSuiteunit(propertyData.suiteUnit!));
    _store.dispatch(UpdateBuildingname(propertyData.buildingName!));
    _store.dispatch(UpdatePropertyCity(propertyData.city!));
    _store.dispatch(UpdatePropertyCountryCode(propertyData.countryCode!));
    _store.dispatch(UpdatePropertyCountryName(propertyData.country!));
    _store.dispatch(UpdatePropertyProvince(propertyData.province!));
    _store.dispatch(UpdatePropertyPostalcode(propertyData.postalCode!));
    _store.dispatch(UpdatePropertyRentAmount(propertyData.rentAmount!));
    _store.dispatch(
        UpdateRentPaymentFrequencyValue(propertyData.rentPaymentFrequency));
    _store.dispatch(UpdateLeaseTypeValue(propertyData.leaseType));
    _store.dispatch(
        UpdateMinimumLeasedurationValue(propertyData.minLeaseDuration));
    _store.dispatch(UpdateMinimumleasedurationNumber(
        propertyData.minLeaseNumber.toString()));

    _store.dispatch(UpdatePropertyBedrooms(propertyData.bedrooms.toString()));
    _store.dispatch(UpdatePropertyBathrooms(propertyData.bathrooms.toString()));
    _store
        .dispatch(UpdatePropertySizeinsquarefeet(propertyData.size.toString()));
    _store.dispatch(UpdatePropertyMaxoccupancy(propertyData.maxOccupancy!));
    _store.dispatch(UpdateFurnishingValue(propertyData.furnishing));
    _store.dispatch(UpdateParkingstalls(propertyData.parkingStalls!));
    _store.dispatch(UpdateStorageAvailableValue(propertyData.storageAvailable));
    _store.dispatch(UpdateAgreeTCPP(propertyData.isAgreedTandC!));
    _store.dispatch(UpdatePropertyDrafting(propertyData.PropDrafting!));
    _store.dispatch(UpdatePropertyVacancy(propertyData.Vacancy!));

    String address = propertyData.propertyName! +
        ": " +
        propertyData.suiteUnit! +
        " - " +
        propertyData.propertyAddress! +
        ", " +
        propertyData.city! +
        ", " +
        propertyData.province! +
        ", " +
        propertyData.postalCode! +
        ", " +
        propertyData.country!;

    _store.dispatch(UpdatePropertyFormAddress(address));

    _store.dispatch(UpdateErrorParkingstalls(false));
    _store.dispatch(UpdateErrorStorageavailable(false));
    _store.dispatch(UpdateErrorOther_Partial_Furniture(false));
    _store.dispatch(UpdateErrorFurnishing(false));
    _store.dispatch(UpdateErrorPropertyMaxoccupancy(false));
    _store.dispatch(UpdateErrorPropertyBathrooms(false));
    _store.dispatch(UpdateErrorPropertyBedrooms(false));
    _store.dispatch(UpdateErrorPropertySizeinsquarefeet(false));
    _store.dispatch(UpdateErrorPropertytype(false));
    _store.dispatch(UpdateErrorPropertytypeOther(false));
    _store.dispatch(UpdateErrorPropertyName(false));
    _store.dispatch(UpdateErrorPropertyAddress(false));
    _store.dispatch(UpdateErrorRentpaymentFrequency(false));
    _store.dispatch(UpdateErrorRentAmount(false));
    _store.dispatch(UpdateErrorRentalspace(false));
    _store.dispatch(UpdateErrorDateofavailable(false));
    _store.dispatch(UpdateErrorMinimumleaseduration(false));
    _store.dispatch(UpdateErrorMinimumleasedurationnumber(false));
    _store.dispatch(UpdateErrorLeasetype(false));
    _store.dispatch(UpdateErrorPostalcode(false));
    _store.dispatch(UpdateErrorCity(false));
    _store.dispatch(UpdateErrorCountryName(false));
    _store.dispatch(UpdateErrorProvince(false));

    /*Summery*/

    _store.dispatch(UpdateSummeryProperTytypeValue(propertyData.propertyType));
    _store.dispatch(
        UpdateSummeryPropertyTypeOtherValue(propertyData.otherPropertyType!));
    _store.dispatch(UpdateSummeryDateofavailable(tempDate));
    _store.dispatch(UpdateSummeryRentalSpaceValue(propertyData.rentalSpace));
    _store.dispatch(UpdateSummeryPropertyName(propertyData.propertyName!));
    _store
        .dispatch(UpdateSummeryPropertyAddress(propertyData.propertyAddress!));
    _store.dispatch(
        UpdateSummeryPropertyDescription(propertyData.propertyDescription!));
    _store.dispatch(UpdateSummerySuiteunit(propertyData.suiteUnit!));
    _store.dispatch(UpdateSummeryBuildingname(propertyData.buildingName!));
    _store.dispatch(UpdateSummeryPropertyCity(propertyData.city!));
    _store
        .dispatch(UpdateSummeryPropertyCountryCode(propertyData.countryCode!));
    _store.dispatch(UpdateSummeryPropertyCountryName(propertyData.country!));
    _store.dispatch(UpdateSummeryPropertyProvince(propertyData.province!));
    _store.dispatch(UpdateSummeryPropertyPostalcode(propertyData.postalCode!));
    _store.dispatch(UpdateSummeryPropertyRentAmount(propertyData.rentAmount!));
    _store.dispatch(UpdateSummeryRentPaymentFrequencyValue(
        propertyData.rentPaymentFrequency));
    _store.dispatch(UpdateSummeryLeaseTypeValue(propertyData.leaseType));
    _store.dispatch(
        UpdateSummeryMinimumLeasedurationValue(propertyData.minLeaseDuration));
    _store.dispatch(UpdateSummeryMinimumleasedurationNumber(
        propertyData.minLeaseNumber.toString()));
    _store.dispatch(UpdateSummeryPropertyImage(propertyData.propertyImage));
    _store.dispatch(UpdateSummeryPropertyUint8List(null));
    _store.dispatch(
        UpdateSummeryPropertyBedrooms(propertyData.bedrooms.toString()));
    _store.dispatch(
        UpdateSummeryPropertyBathrooms(propertyData.bathrooms.toString()));
    _store.dispatch(
        UpdateSummeryPropertySizeinsquarefeet(propertyData.size.toString()));
    _store.dispatch(
        UpdateSummeryPropertyMaxoccupancy(propertyData.maxOccupancy!));
    _store.dispatch(UpdateSummeryFurnishingValue(propertyData.furnishing));
    _store.dispatch(UpdateSummeryOtherPartialFurniture(
        propertyData.otherPartialFurniture.toString()));
    _store.dispatch(UpdateSummeryParkingstalls(propertyData.parkingStalls!));
    _store.dispatch(
        UpdateSummeryStorageAvailableValue(propertyData.storageAvailable));
    _store.dispatch(UpdateSummeryAgreeTCPP(propertyData.isAgreedTandC!));
    _store.dispatch(UpdateSummeryPropertyDrafting(propertyData.PropDrafting!));
    _store.dispatch(UpdateSummeryPropertyVacancy(propertyData.Vacancy!));
  }

  deletePropertyImage(BuildContext context, Object PIMPOJO, Object MIPoJO,
      CallBackQuesy CallBackQuesy) {
    List<QueryObject> queryList = <QueryObject>[];

    String query = QueryFilter().DeleteQuery(PIMPOJO, etableName.PropertyImages,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);
    var querydecode = jsonDecode(query);
    QueryObject PropertyImagesquery = QueryObject.fromJson(querydecode);

    queryList.add(PropertyImagesquery);

    String query2 = QueryFilter().DeleteQuery(MIPoJO, etableName.MediaInfo,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);
    var querycode2 = jsonDecode(query2);
    QueryObject MediaInfoquery = QueryObject.fromJson(querycode2);

    queryList.add(MediaInfoquery);

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

  PropertyImagesUpload(
      BuildContext context,
      List<PropertyImageMediaInfo> propertyimagelist,
      CallBackListQuesy CallBackQuesy) async {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    var multipartRequest =
        new http.MultipartRequest("POST", Uri.parse(Weburl.FileUpload_Api));
    multipartRequest.headers.addAll(headers);

    for (int i = 0; i < propertyimagelist.length; i++) {
      List<int> _selectedFile = propertyimagelist[i].appImage!;
      String filepath = propertyimagelist[i].fileName!;

      multipartRequest.files.add(await http.MultipartFile.fromBytes(
          'file[' + i.toString() + ']', _selectedFile,
          contentType: new MediaType('application', 'png'),
          filename: filepath));
    }

    await multipartRequest.send().then((result) {
      //print('PropertyImagesUpload');
      if (result.statusCode == 200) {
        http.Response.fromStream(result).then((response) {
          if (response.statusCode == 200) {
            if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
              var data = jsonDecode(response.body);

              if (data != null) {
                List<String> mediaString = [];
                for (int i = 0; i < data['Result'].length; i++) {
                  var myobject = data['Result'][i];

                  String MediaID = myobject['MediaID'] != null
                      ? "" + myobject['MediaID'].toString()
                      : "";

                  String url = myobject['url'] != null
                      ? "" + myobject['url'].toString()
                      : "";

                  mediaString.add(MediaID);

                  if (data['Result'].length - 1 == i) {
                    CallBackQuesy(true, mediaString, "");
                  }
                }
              } else {
                CallBackQuesy(false, [], GlobleString.Error);
              }
            } else {
              CallBackQuesy(false, [], GlobleString.Error);
            }
          } else if (response.statusCode == 401) {
            CallBackQuesy(false, [], GlobleString.Error_401);
          } else {
            CallBackQuesy(false, [], GlobleString.Error);
          }
        });
      } else if (result.statusCode == 401) {
        CallBackQuesy(false, [], GlobleString.Error_401);
      } else {
        CallBackQuesy(false, [], GlobleString.Error);
      }
    });
  }

  InsetPropertyImages(
      BuildContext context, List<Object> POJO, CallBackQuesy CallBackQuesy) {
    String json = QueryFilter().InsertQueryArray(
        POJO,
        etableName.PropertyImages,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

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
            CallBackQuesy(false, respoce);
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

  getPropertyImages(
      BuildContext context, Object POJO, CallBackQuesy callbackquery) async {
    String query = await QueryFilter().SelectQuery(
        POJO,
        etableName.PropertyImages,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo,
        true);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data["Result"].length > 0) {
          List<PropertyImageMediaInfo> PropertyImageMediaInfolist = [];

          for (int k = 0; k < data["Result"].length; k++) {
            var PImages = data["Result"][k];

            String PID = PImages['ID'] != null ? PImages['ID'].toString() : "";

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

          bool findfavorite = false;
          for (int j = 0; j < PropertyImageMediaInfolist.length; j++) {
            PropertyImageMediaInfo minfo = PropertyImageMediaInfolist[j];

            if (minfo.IsFavorite!) {
              findfavorite = true;
            }

            if (PropertyImageMediaInfolist.length - 1 == j && !findfavorite) {
              ApiManager().setFeaturedImage(
                  context,
                  Prefs.getString(PrefsName.PropertyID),
                  PropertyImageMediaInfolist[0].id.toString(),
                  (error, responce) async {
                if (error) {
                  PropertyImageMediaInfolist[0].IsFavorite = true;
                } else {
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            }
          }

          _store.dispatch(UpdatePropertyImageList(PropertyImageMediaInfolist));
          _store.dispatch(
              UpdateSummeryPropertyImageList(PropertyImageMediaInfolist));
        } else {
          _store.dispatch(UpdatePropertyImageList(<PropertyImageMediaInfo>[]));
          _store.dispatch(
              UpdateSummeryPropertyImageList(<PropertyImageMediaInfo>[]));
        }

        callbackquery(true, "");
      } else {
        callbackquery(false, respoce);
      }
    });
  }

  setFeaturedImage(BuildContext context, String PropID, String MediaID,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Featured_image,
      "Reqtokens": {"Property_ID": PropID, "Media_ID": MediaID}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        //var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*==============================================================================*/
/*========================  Lendlord and Applicant  =============================*/
/*==============================================================================*/

  getCommonLeadList(BuildContext context, String myjson) async {
    HttpClientCall().DSQAPICall(context, myjson, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }

        tenancyleadlist.sort((a, b) =>
            b.CreatedOn!.toLowerCase().compareTo(a.CreatedOn!.toLowerCase()));

        _store.dispatch(UpdateLLTALeadleadList(tenancyleadlist));
        _store.dispatch(UpdateLLTLeadFilterleadList(tenancyleadlist));
        _store.dispatch(UpdateLLTALeadisNameSort(false));
        _store.dispatch(UpdateLLTALeadisPropertySort(false));
        _store.dispatch(UpdateLLTALeadisRatingSort(false));
        _store.dispatch(UpdateLLTALeadisEmailSort(false));
        _store.dispatch(UpdateLLTALeadisPhoneSort(false));
        _store.dispatch(UpdateLLTALeadisDatecreateSort(false));
        _store.dispatch(UpdateLLTALeadisAppStatusSort(false));
        _store.dispatch(UpdateLLTALeadisloding(false));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  getCommonApplicantList(BuildContext context, String myjson) async {
    HttpClientCall().DSQAPICall(context, myjson, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }

        tenancyleadlist.sort((a, b) =>
            b.CreatedOn!.toLowerCase().compareTo(a.CreatedOn!.toLowerCase()));

        _store.dispatch(UpdateLLTAApplicantleadList(tenancyleadlist));
        _store.dispatch(UpdateLLTAFilterApplicantleadList(tenancyleadlist));
        _store.dispatch(UpdateLLTAApplicantisNameSort(false));
        _store.dispatch(UpdateLLTAApplicantisPropertySort(false));
        _store.dispatch(UpdateLLTAApplicantisRatingSort(false));
        _store.dispatch(UpdateLLTAApplicantisDateSentSort(false));
        _store.dispatch(UpdateLLTAApplicantisDateReceiveSort(false));
        _store.dispatch(UpdateLLTAApplicantisAppStatusSort(false));
        _store.dispatch(UpdateLLTAApplicantisloding(false));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  terminateTenancyWorkflow(BuildContext context, String applicantId,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Terminate_Tenancy,
      "Reqtokens": {
        "Applicant_ID": applicantId,
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        //var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*==============================================================================*/
/*========================  Lendlord and Applicant  =============================*/
/*==============================================================================*/

  getTenancyStatusCount(BuildContext context, String Ownerid) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_TenancyStatusCount,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": Ownerid}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        Helper.Log("getTenancyStatusCount", respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          int TotalLeads =
              myobject['Total Leads'] != null ? myobject['Total Leads'] : 0;

          int TotalApplications = myobject['Total Applications'] != null
              ? myobject['Total Applications']
              : 0;

          int TotalDocuments = myobject['Total Documents'] != null
              ? myobject['Total Documents']
              : 0;

          int TotalReferences = myobject['Total References'] != null
              ? myobject['Total References']
              : 0;

          int TotalLeases =
              myobject['Total Leases'] != null ? myobject['Total Leases'] : 0;

          int TotalActiveTenants = myobject['Total Active Tenants'] != null
              ? myobject['Total Active Tenants']
              : 0;

          _store.dispatch(UpdateLandlordApplication_Lead_Count(TotalLeads));
          _store.dispatch(UpdateLandlordApplications_count(TotalApplications));
          _store.dispatch(
              UpdateLandlordApplication_verification_documents_count(
                  TotalDocuments));
          _store.dispatch(UpdateLandlordApplication_references_check_count(
              TotalReferences));
          _store.dispatch(UpdateLandlordApplication_leases_count(TotalLeases));
          _store.dispatch(UpdateLandlordApplication_Active_Tenants_Count(
              TotalActiveTenants));
        }
      } else {
        //loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  PropertyListInDropDownApi(
      BuildContext context, Object POJO, PropertyListCallback CallBack) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().SelectQuery(POJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, true);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
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
          propertyData.createdOn = CreatedOn;
          propertyData.updatedOn = UpdatedOn;

          propertylist.add(propertyData);
        }

        propertylist.sort((a, b) =>
            b.createdOn!.toLowerCase().compareTo(a.createdOn!.toLowerCase()));
        loader.remove();
        CallBack(propertylist, true);
      } else {
        loader.remove();
        CallBack(<PropertyData>[], false);
      }
    });
  }

  InsetNewLeadAPI(
      BuildContext context, List<Object> POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQueryArray(POJO, etableName.Application,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().QueryAPICall(context, query, (error, respoce) async {
      if (error) {
        List data = jsonDecode(respoce) as List;

        bool issuccess = false;
        for (int i = 0; i < data.length; i++) {
          var myobject = data[i];

          String StatusCode = myobject['StatusCode'] != null
              ? myobject['StatusCode'].toString()
              : "";

          if (StatusCode.isEmpty || StatusCode != "200") {
            loader.remove();
            issuccess = true;
            CallBackQuesy(false, "");
            break;
          }

          if ((data.length - 1) == i && !issuccess) {
            CallBackQuesy(true, "");
          }
        }
      } else {
        CallBackQuesy(false, "");
      }
    });
  }

  checkEmailAddressExit(BuildContext context, String Propertyid, String Email,
      CallBackQuesyEmailExit callBackQuesyEmailExit) async {
    var myjson = {
      "DSQID": Weburl.DSQ_TenantEmail_already_Property,
      "LoadLookupValues": true,
      "Reqtokens": {"Prop_ID": Propertyid, "Email": Email}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        if (data['Result'].length > 0) {
          List<EmailExit> emailexitlist = <EmailExit>[];

          emailexitlist = (data['Result'] as List)
              .map((p) => EmailExit.fromJson(p))
              .toList();

          callBackQuesyEmailExit(false, "1", emailexitlist);
        } else {
          callBackQuesyEmailExit(true, "1", []);
        }
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        callBackQuesyEmailExit(false, respoce, []);
      }
    });
  }

  getEditLeadDataAPI(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_DETAILS,
      "LoadLookupValues": true,
      "LoadRecordInfo": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        Helper.Log("getEditLeadDataAPI", respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          String NumberOfOccupant = myobject['NumberOfOccupant'] != null
              ? myobject['NumberOfOccupant'].toString()
              : "0";

          String NumberOfChildren = myobject['NumberOfChildren'] != null
              ? myobject['NumberOfChildren'].toString()
              : "0";

          /*===============*/
          /* Personal Info */
          /*===============*/
          var PersonalInfo = myobject["Person_ID"];

          String PersonID =
              PersonalInfo['ID'] != null ? PersonalInfo['ID'].toString() : "0";

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

          _store.dispatch(UpdateEditLeadPersionId(PersonID));
          _store.dispatch(UpdateEditLeadFirstname(FirstName));
          _store.dispatch(UpdateEditLeadLastname(LastName));
          _store.dispatch(UpdateEditLeadEmail(Email));
          _store.dispatch(UpdateEditLeadPhoneNumber(MobileNumber));
          _store.dispatch(UpdateEditLeadCountryCode(Country_Code));
          _store.dispatch(UpdateEditLeadCountryDialCode(Dial_Code));
          _store.dispatch(UpdateEditLeadNotes(note));
          _store.dispatch(UpdateEditLeadApplicantid(id));

          _store.dispatch(UpdateEditLead_Occupant(NumberOfOccupant));
          _store.dispatch(UpdateEditLead_Children(NumberOfChildren));
        }
        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  UpdateLead(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        loader.remove();
        CallBackQuesy(true, "");
      } else {
        loader.remove();
        CallBackQuesy(false, "");
      }
    });
  }

  UpdateStatusApplication(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
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

  UpdateRatingApplication(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Applicant,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        loader.remove();
        callBackQuesy(true, "");
      } else {
        loader.remove();
        callBackQuesy(false, "");
      }
    });
  }

  UpdateArchiveApplication(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        loader.remove();
        callBackQuesy(true, "");
      } else {
        loader.remove();
        callBackQuesy(false, "");
      }
    });
  }

  funUpdateStatus(BuildContext context, String Id, String status,
      String propertyid, CallBackQuesy callbackquery) {
    TenancyApplicationID updateid = new TenancyApplicationID();
    updateid.ID = Id;

    TenancyApplicationUpdateStatus updatestatus =
        new TenancyApplicationUpdateStatus();
    updatestatus.ApplicationStatus = status;

    ApiManager().UpdatestatusAPIFunnelView(
        context, updateid, updatestatus, propertyid, callbackquery);
  }

  UpdatestatusAPIFunnelView(BuildContext context, Object CPOJO, Object UpPOJO,
      String propertyid, CallBackQuesy callbackquery) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        FilterReqtokens reqtokens = new FilterReqtokens();
        reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
        reqtokens.IsArchived = "0";
        reqtokens.Prop_ID = propertyid;

        FilterData filterData = new FilterData();
        filterData.DSQID = Weburl.DSQ_CommonView;
        filterData.LoadLookupValues = true;
        filterData.LoadRecordInfo = true;
        filterData.Reqtokens = reqtokens;

        String filterjson = jsonEncode(filterData);

        await ApiManager().getPropertyWiseFunnel(context, filterjson);

        callbackquery(true, "");
        loader.remove();
      } else {
        callbackquery(false, "");
        loader.remove();
      }
    });
  }

  getPropertyWiseFunnel(BuildContext context, String json) async {
    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        Helper.Log("getPropertyWiseFunnel", respoce);

        List<TenancyApplication> allListData = <TenancyApplication>[];
        List<TenancyApplication> leadlist = <TenancyApplication>[];
        List<TenancyApplication> applicatntlist = <TenancyApplication>[];
        List<TenancyApplication> documentlist = <TenancyApplication>[];
        List<TenancyApplication> referencelist = <TenancyApplication>[];
        List<TenancyApplication> leasesentlist = <TenancyApplication>[];
        List<TenancyApplication> activetenantlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          allListData.add(tenancyApplication);

          if (ApplicationStatus!.EnumDetailID == 1) {
            leadlist.add(tenancyApplication);
          } else if (ApplicationStatus.EnumDetailID == 2) {
            applicatntlist.add(tenancyApplication);
          } else if (ApplicationStatus.EnumDetailID == 3) {
            documentlist.add(tenancyApplication);
          } else if (ApplicationStatus.EnumDetailID == 4) {
            referencelist.add(tenancyApplication);
          } else if (ApplicationStatus.EnumDetailID == 5) {
            leasesentlist.add(tenancyApplication);
          } else if (ApplicationStatus.EnumDetailID == 6) {
            activetenantlist.add(tenancyApplication);
          }
        }

        _store.dispatch(UpdateFunnelAllListData(allListData));

        _store.dispatch(UpdateFunnelLeadCount(leadlist.length));
        _store.dispatch(UpdateFunnelLeadList(leadlist));

        _store.dispatch(UpdateFunnelApplicantCount(applicatntlist.length));
        _store.dispatch(UpdateFunnelApplicantList(applicatntlist));

        _store.dispatch(UpdateFunnelDocumentVarifyCount(documentlist.length));
        _store.dispatch(UpdateFunnelDocumentVarifyList(documentlist));

        _store.dispatch(UpdateFunnelReferenceCheckCount(referencelist.length));
        _store.dispatch(UpdateFunnelReferenceList(referencelist));

        _store.dispatch(UpdateFunnelLeaseCount(leasesentlist.length));
        _store.dispatch(UpdateFunnelLeassentList(leasesentlist));

        _store.dispatch(UpdateFunnelActiveTenantCount(activetenantlist.length));
        _store.dispatch(UpdateFunnelActiveTenantList(activetenantlist));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  getPropertyWiseLead(BuildContext context, String Ownerid, String propertyid,
      CallBackLeadList callBackLeadList) async {
    var myjson = {
      "DSQID": Weburl.DSQ_CommonView,
      "LoadLookupValues": true,
      "LoadRecordInfo": true,
      "Reqtokens": {"Owner_ID": Ownerid, "Prop_ID": propertyid, "IsArchived": 0}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }
        callBackLeadList(true, "", tenancyleadlist);
      } else {
        Helper.Log("respoce", respoce);
        callBackLeadList(false, "", <TenancyApplication>[]);
      }
    });
  }

/*==============================================================================*/
/*========================  Tenancy Application Details  =============================*/
/*==============================================================================*/

  getTenancyDetails_Applicant(BuildContext context, String id,
      CallBackApplicantDetails callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_DETAILS,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          ApplicantDetails applicantDetails = new ApplicantDetails();

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

            String YourStory = myobject['YourStory'] != null
                ? myobject['YourStory'].toString()
                : "";

            String Note =
                myobject['Note'] != null ? myobject['Note'].toString() : "";

            double Rating = myobject['Rating'] != null ? myobject['Rating'] : 0;

            String IntendedTenancyStartDate =
                myobject['IntendedTenancyStartDate'] != null
                    ? myobject['IntendedTenancyStartDate'].toString()
                    : "";

            SystemEnumDetails? IntendedLenth = myobject['IntendedLenth'] != null
                ? SystemEnumDetails.fromJson(myobject['IntendedLenth'])
                : null;

            SystemEnumDetails? IntendedPeriod =
                myobject['IntendedPeriod'] != null
                    ? SystemEnumDetails.fromJson(myobject['IntendedPeriod'])
                    : null;

            String IntendedPeriodNo = myobject['IntendedPeriodNo'] != null
                ? myobject['IntendedPeriodNo'].toString()
                : "";

            ApplicantPersonId personID = new ApplicantPersonId();

            /*===============*/
            /* Personal Info */
            /*===============*/

            if (myobject["Person_ID"] != null) {
              var PersonalInfo = myobject["Person_ID"];

              String PersonID = PersonalInfo['ID'] != null
                  ? PersonalInfo['ID'].toString()
                  : "";

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

              String DOB = PersonalInfo['DOB'] != null
                  ? PersonalInfo['DOB'].toString()
                  : "";

              personID.id = PersonID;
              personID.firstName = FirstName;
              personID.lastName = LastName;
              personID.email = Email;
              personID.mobileNumber = MobileNumber;
              personID.countryCode = Country_Code;
              personID.dialCode = Dial_Code;
              personID.DOB = DOB;
            }

            applicantDetails.id = ApplicantID;
            applicantDetails.isSmoking = IsSmoking;
            applicantDetails.isPet = IsPet;
            applicantDetails.isVehicle = IsVehicle;
            applicantDetails.rating = Rating;
            applicantDetails.smokingDesc = SmokingDesc;
            applicantDetails.intendedLenth = IntendedLenth;
            applicantDetails.intendedPeriod = IntendedPeriod;
            applicantDetails.intendedPeriodNo = IntendedPeriodNo;
            applicantDetails.intendedTenancyStartDate =
                IntendedTenancyStartDate;
            applicantDetails.yourStory = YourStory;
            applicantDetails.note = Note;
            applicantDetails.personId = personID;
          }
          callBackQuesy(true, "", applicantDetails);
        } else {
          callBackQuesy(false, respoce, null);
        }
      } else {
        callBackQuesy(false, respoce, null);
      }
    });
  }

  getTenancyDetails_Application(BuildContext context, String id,
      CallBackApplicationDetails callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_Application,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          ApplicationDetails applicationDetails = new ApplicationDetails();
          OwnerData ownerdata = new OwnerData();
          PropertyData propertyData = new PropertyData();

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

            String ApplicationSentDate = myobject['ApplicationSentDate'] != null
                ? myobject['ApplicationSentDate']
                : "";

            String AgreementSentDate = myobject['AgreementSentDate'] != null
                ? myobject['AgreementSentDate']
                : "";

            String DocRequestSentDate = myobject['DocRequestSentDate'] != null
                ? myobject['DocRequestSentDate']
                : "";

            String ApplicationReceivedDate =
                myobject['ApplicationReceivedDate'] != null
                    ? myobject['ApplicationReceivedDate']
                    : "";

            String AgreementReceivedDate =
                myobject['AgreementReceivedDate'] != null
                    ? myobject['AgreementReceivedDate']
                    : "";

            String DocReceivedDate = myobject['DocReceivedDate'] != null
                ? myobject['DocReceivedDate']
                : "";

            bool IsAgreedTerms = myobject['IsAgreedTerms'] != null
                ? myobject['IsAgreedTerms']
                : false;

            bool IsAuthorized = myobject['IsAuthorized'] != null
                ? myobject['IsAuthorized']
                : false;

            SystemEnumDetails? ApplicationStatus =
                myobject['ApplicationStatus'] != null
                    ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                    : null;

            SystemEnumDetails? DocReviewStatus =
                myobject['DocReviewStatus'] != null
                    ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                    : null;

            SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
                ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
                : null;

            bool IsNotApplicableAddOccupant =
                myobject['IsNotApplicableAddOccupant'] != null
                    ? myobject['IsNotApplicableAddOccupant']
                    : false;

            applicationDetails.id = ID;
            applicationDetails.applicationSentDate = ApplicationSentDate;
            applicationDetails.agreementSentDate = AgreementSentDate;
            applicationDetails.isAuthorized = IsAuthorized;
            applicationDetails.applicationStatus = ApplicationStatus;
            applicationDetails.docReviewStatus = DocReviewStatus;
            applicationDetails.docRequestSentDate = DocRequestSentDate;
            applicationDetails.applicationReceivedDate =
                ApplicationReceivedDate;
            applicationDetails.isAgreedTerms = IsAgreedTerms;
            applicationDetails.leaseStatus = LeaseStatus;
            applicationDetails.agreementReceivedDate = AgreementReceivedDate;
            applicationDetails.docReceivedDate = DocReceivedDate;
            applicationDetails.IsNotApplicableAddOccupant =
                IsNotApplicableAddOccupant;

            if (myobject['Prop_ID'] != null) {
              var myobject1 = myobject['Prop_ID'];

              String ID =
                  myobject1['ID'] != null ? myobject1['ID'].toString() : "";

              String PropertyName = myobject1['PropertyName'] != null
                  ? myobject1['PropertyName'].toString()
                  : "";

              String Other_Property_Type =
                  myobject1['Other_Property_Type'] != null
                      ? myobject1['Other_Property_Type'].toString()
                      : "";

              String Building_Name = myobject1['Building_Name'] != null
                  ? myobject1['Building_Name'].toString()
                  : "";

              String Property_Address = myobject1['Property_Address'] != null
                  ? myobject1['Property_Address'].toString()
                  : "";

              bool IsActive =
                  myobject1['IsActive'] != null ? myobject1['IsActive'] : false;

              String Postal_Code = myobject1['Postal_Code'] != null
                  ? myobject1['Postal_Code'].toString()
                  : "";

              String Country_Code = myobject1['Country_Code'] != null
                  ? myobject1['Country_Code'].toString()
                  : "";

              int Size = myobject1['Size'] != null ? myobject1['Size'] : 0;

              String Other_Partial_Furniture =
                  myobject1['Other_Partial_Furniture'] != null
                      ? myobject1['Other_Partial_Furniture'].toString()
                      : "";

              String Max_Occupancy = myobject1['Max_Occupancy'] != null
                  ? myobject1['Max_Occupancy'].toString()
                  : "";

              String Date_Available = myobject1['Date_Available'] != null
                  ? myobject1['Date_Available'].toString()
                  : "";

              bool IsAgreed_TandC = myobject1['IsAgreed_TandC'] != null
                  ? myobject1['IsAgreed_TandC']
                  : false;

              String City =
                  myobject1['City'] != null ? myobject1['City'].toString() : "";

              String Rent_Amount = myobject1['Rent_Amount'] != null
                  ? myobject1['Rent_Amount'].toString()
                  : "";

              int Min_Lease_Number = myobject1['Min_Lease_Number'] != null
                  ? myobject1['Min_Lease_Number']
                  : "";

              String Parking_Stalls = myobject1['Parking_Stalls'] != null
                  ? myobject1['Parking_Stalls'].toString()
                  : "";

              String Country = myobject1['Country'] != null
                  ? myobject1['Country'].toString()
                  : "";

              int Bedrooms =
                  myobject1['Bedrooms'] != null ? myobject1['Bedrooms'] : 0;

              String Suite_Unit = myobject1['Suite_Unit'] != null
                  ? myobject1['Suite_Unit'].toString()
                  : "";

              String Province = myobject1['Province'] != null
                  ? myobject1['Province'].toString()
                  : "";

              String Property_Description =
                  myobject1['Property_Description'] != null
                      ? myobject1['Property_Description'].toString()
                      : "";

              int Bathrooms =
                  myobject1['Bathrooms'] != null ? myobject1['Bathrooms'] : 0;

              int PropDrafting = myobject1['PropDrafting'] != null
                  ? myobject1['PropDrafting']
                  : 0;

              bool Vacancy =
                  myobject1['Vacancy'] != null ? myobject1['Vacancy'] : false;

              bool IsPublished = myobject1['IsPublished'] != null
                  ? myobject1['IsPublished']
                  : false;

              MediaInfo? Property_Image = myobject1['Property_Image'] != null
                  ? MediaInfo.fromJson(myobject1['Property_Image'])
                  : null;

              SystemEnumDetails? Property_Type =
                  myobject1['Property_Type'] != null
                      ? SystemEnumDetails.fromJson(myobject1['Property_Type'])
                      : null;

              SystemEnumDetails? Min_Lease_Duration =
                  myobject1['Min_Lease_Duration'] != null
                      ? SystemEnumDetails.fromJson(
                          myobject1['Min_Lease_Duration'])
                      : null;

              SystemEnumDetails? Lease_Type = myobject1['Lease_Type'] != null
                  ? SystemEnumDetails.fromJson(myobject1['Lease_Type'])
                  : null;

              SystemEnumDetails? Furnishing = myobject1['Furnishing'] != null
                  ? SystemEnumDetails.fromJson(myobject1['Furnishing'])
                  : null;

              SystemEnumDetails? Rent_Payment_Frequency =
                  myobject1['Rent_Payment_Frequency'] != null
                      ? SystemEnumDetails.fromJson(
                          myobject1['Rent_Payment_Frequency'])
                      : null;

              SystemEnumDetails? StorageAvailable =
                  myobject1['StorageAvailable'] != null
                      ? SystemEnumDetails.fromJson(
                          myobject1['StorageAvailable'])
                      : null;

              SystemEnumDetails? Rental_Space =
                  myobject1['Rental_Space'] != null
                      ? SystemEnumDetails.fromJson(myobject1['Rental_Space'])
                      : null;

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
              propertyData.IsPublished = IsPublished;

              if (myobject1["Owner_ID"] != null) {
                var Owner_IDInfo = myobject1["Owner_ID"];

                String OwnerID = Owner_IDInfo['ID'] != null
                    ? Owner_IDInfo['ID'].toString()
                    : "";

                String CompanyName = Owner_IDInfo['CompanyName'] != null
                    ? Owner_IDInfo['CompanyName'].toString()
                    : "";

                String HomePageLink = Owner_IDInfo['HomePageLink'] != null
                    ? Owner_IDInfo['HomePageLink'].toString()
                    : "";

                String CustomerFeatureListingURL =
                    Owner_IDInfo['CustomerFeatureListingURL'] != null
                        ? Owner_IDInfo['CustomerFeatureListingURL'].toString()
                        : "";

                MediaInfo? Company_logo = Owner_IDInfo['Company_logo'] != null
                    ? MediaInfo.fromJson(Owner_IDInfo['Company_logo'])
                    : null;

                ownerdata.id = OwnerID;
                ownerdata.CompanyName = CompanyName;
                ownerdata.HomePageLink = HomePageLink;
                ownerdata.CustomerFeatureListingURL = CustomerFeatureListingURL;
                ownerdata.Company_logo = Company_logo;
              }
            }
          }
          callBackQuesy(true, "", applicationDetails, propertyData, ownerdata);
        } else {
          callBackQuesy(false, respoce, null, null, null);
        }
      } else {
        callBackQuesy(false, respoce, null, null, null);
      }
    });
  }

  getTenancyDetails_AdditionalOccupant(BuildContext context, String id,
      CallBackAdditionalOccupant callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_AdditionalOccupant,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          List<TenancyAdditionalOccupant> occupantlist =
              <TenancyAdditionalOccupant>[];

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            String AOID =
                myobject['ID'] != null ? myobject['ID'].toString() : "";

            String AORelationWithApplicant =
                myobject['RelationWithApplicant'] != null
                    ? myobject['RelationWithApplicant'].toString()
                    : "";

            /*===============*/
            /*  Occupant */
            /*===============*/
            var Occupant = myobject["Occupant"];

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
            tenancyAdditionalOccupant.errro_firstname = false;
            tenancyAdditionalOccupant.errro_lastname = false;
            tenancyAdditionalOccupant.errro_primaryApplicant = false;

            occupantlist.add(tenancyAdditionalOccupant);
          }
          callBackQuesy(true, "", occupantlist);
        } else {
          callBackQuesy(false, respoce, []);
        }
      } else {
        callBackQuesy(false, respoce, []);
      }
    });
  }

  getTenancyDetails_AdditionalReference(BuildContext context, String id,
      CallBackAdditionalReference callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_AdditionalReference,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          List<TenancyAdditionalReference> referencelist =
              <TenancyAdditionalReference>[];

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            String ARID =
                myobject['ID'] != null ? myobject['ID'].toString() : "";

            String ARRelationWithApplicant =
                myobject['RelationWithApplicant'] != null
                    ? myobject['RelationWithApplicant'].toString()
                    : "";

            String QuestionnaireReceivedDate =
                myobject['QuestionnaireReceivedDate'] != null
                    ? myobject['QuestionnaireReceivedDate'].toString()
                    : "";

            String QuestionnaireSentDate =
                myobject['QuestionnaireSentDate'] != null
                    ? myobject['QuestionnaireSentDate'].toString()
                    : "";

            /*===============*/
            /*  Reference */
            /*===============*/
            var Reference = myobject["ReferenceID"];

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

            String Reference_Email =
                Reference['Email'] != null ? Reference['Email'].toString() : "";

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
            tenancyAdditionalReference.QuestionnaireSentDate =
                QuestionnaireSentDate;
            tenancyAdditionalReference.QuestionnaireReceivedDate =
                QuestionnaireReceivedDate;

            tenancyAdditionalReference.error_firstname = false;
            tenancyAdditionalReference.error_lastname = false;
            tenancyAdditionalReference.error_reletionshipprimaryApplicant =
                false;
            tenancyAdditionalReference.error_phonenumber = false;
            tenancyAdditionalReference.error_email = false;

            referencelist.add(tenancyAdditionalReference);
          }
          callBackQuesy(true, "", referencelist);
        } else {
          callBackQuesy(false, respoce, []);
        }
      } else {
        callBackQuesy(false, respoce, []);
      }
    });
  }

  getTenancyDetails_CurrentTenancy(BuildContext context, String id,
      CallBackApplicatCurrentTenancy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_CurrentTenancy,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          ApplicatCurrentTenancy applicatCurrentTenancy =
              new ApplicatCurrentTenancy();

          for (int i = 0; i < data['Result'].length; i++) {
            var objectCurrentTenancy = data['Result'][i];

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

            String CurrentTenancy_Suite = objectCurrentTenancy['Suite'] != null
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
                ? objectCurrentTenancy['CurrentLandLordIschecked_As_Reference']
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

            String CurrentLandLord_Email = CurrentLandLordInfo['Email'] != null
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

            applicatCurrentTenancy.id = CurrentTenancy_ID;
            applicatCurrentTenancy.startDate = CurrentTenancy_Start_Date;
            applicatCurrentTenancy.endDate = CurrentTenancy_End_Date;
            applicatCurrentTenancy.city = CurrentTenancy_City;
            applicatCurrentTenancy.postalCode = CurrentTenancy_PostalCode;
            applicatCurrentTenancy.province = CurrentTenancy_Province;
            applicatCurrentTenancy.suite = CurrentTenancy_Suite;
            applicatCurrentTenancy.address = CurrentTenancy_Address;
            applicatCurrentTenancy.currentLandLordIscheckedAsReference =
                CurrentTenancy_As_Reference;
            applicatCurrentTenancy.CurrentLandLord_ID = CurrentLandLord_ID;
            applicatCurrentTenancy.CurrentLandLord_FirstName =
                CurrentLandLord_FirstName;
            applicatCurrentTenancy.CurrentLandLord_LastName =
                CurrentLandLord_LastName;
            applicatCurrentTenancy.CurrentLandLord_Email =
                CurrentLandLord_Email;
            applicatCurrentTenancy.CurrentLandLord_MobileNumber =
                CurrentLandLord_MobileNumber;
            applicatCurrentTenancy.CurrentLandLord_Country_Code =
                CurrentLandLord_Country_Code;
            applicatCurrentTenancy.CurrentLandLord_Dial_Code =
                CurrentLandLord_Dial_Code;
          }
          callBackQuesy(true, "", applicatCurrentTenancy);
        } else {
          callBackQuesy(false, respoce, null);
        }
      } else {
        callBackQuesy(false, respoce, null);
      }
    });
  }

  getTenancyDetails_Employemant(BuildContext context, String id,
      CallBackEmployemantDetails callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_Employemant,
      "LoadLookupValues": true,
      "LoadChildren": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          EmployemantDetails employemantDetails = new EmployemantDetails();

          for (int a = 0; a < data['Result'].length; a++) {
            var objectEmployment = data['Result'][a];

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

            /*===============*/
            /* Occupation Info */
            /*===============*/

            List<TenancyEmploymentInformation> listoccupation =
                <TenancyEmploymentInformation>[];

            if (objectEmployment['Occupation'] != null) {
              for (int b = 0; b < objectEmployment['Occupation'].length; b++) {
                var OccupationInfo = objectEmployment['Occupation'][b];

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

                /* if (Occupation_IsCurrentOccupation) {
                  _store.dispatch(UpdateTADetailAnualincomestatus(
                      Occupation_Annual_Income_Status));
                }
*/
                TenancyEmploymentInformation tenancyEmploymentInformation =
                    new TenancyEmploymentInformation();
                tenancyEmploymentInformation.id = Occupation_ID;
                tenancyEmploymentInformation.occupation = Occupation;
                tenancyEmploymentInformation.organization =
                    Occupation_Organization;
                tenancyEmploymentInformation.lenthofemp =
                    Occupation_LegthofEmpoyment;
                tenancyEmploymentInformation.IsCurrentOccupation =
                    Occupation_IsCurrentOccupation;
                tenancyEmploymentInformation.anualIncome =
                    Occupation_Annual_Income_Status;
                tenancyEmploymentInformation.error_occupation = false;
                tenancyEmploymentInformation.error_organization = false;
                tenancyEmploymentInformation.error_lenthofemp = false;
                tenancyEmploymentInformation.error_anualIncome = false;

                listoccupation.add(tenancyEmploymentInformation);
              }
            }
            employemantDetails.id = Employment_ID;
            employemantDetails.LinkedIn = Employment_LinkedIn;
            employemantDetails.otherSourceIncome = Employment_OtherSourceIncome;
            employemantDetails.empStatusId = Employment_Emp_Status_ID;
            employemantDetails.annualIncomeStatus =
                Employment_Annual_Income_Status;
            employemantDetails.occupation = listoccupation;
          }

          callBackQuesy(true, "", employemantDetails);
        } else {
          callBackQuesy(false, respoce, null);
        }
      } else {
        callBackQuesy(false, respoce, null);
      }
    });
  }

  getTenancyDetails_PetInfo(
      BuildContext context, String id, CallBackPetslist callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_PetInfo,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          List<Pets> petslist = <Pets>[];

          for (int c = 0; c < data['Result'].length; c++) {
            var objectPetInfo = data['Result'][c];

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
            pets.error_typeofpets = false;
            pets.error_size = false;
            pets.error_age = false;

            petslist.add(pets);
          }

          callBackQuesy(true, "", petslist);
        } else {
          callBackQuesy(false, respoce, []);
        }
      } else {
        callBackQuesy(false, respoce, []);
      }
    });
  }

  getTenancyDetails_Vehicallist(BuildContext context, String id,
      CallBackVehicallist callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_APPLICANT_VehicleInfo,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          List<Vehical> vehicallist = <Vehical>[];

          for (int d = 0; d < data['Result'].length; d++) {
            var objectVehicleInfo = data['Result'][d];

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
            vehical.error_make = false;
            vehical.error_model = false;
            vehical.error_year = false;

            vehicallist.add(vehical);
          }

          callBackQuesy(true, "", vehicallist);
        } else {
          callBackQuesy(false, respoce, []);
        }
      } else {
        callBackQuesy(false, respoce, []);
      }
    });
  }

  UpdateTenancyApplicationScore(
      BuildContext context, Object CPOJO, Object UpPOJO) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        await Prefs.setBool(PrefsName.IsApplyFilterList, false);
        _store.dispatch(UpdateLLTALeadleadList(<TenancyApplication>[]));
        _store.dispatch(UpdateLLTLeadFilterleadList(<TenancyApplication>[]));

        FilterReqtokens reqtokens = new FilterReqtokens();
        reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
        reqtokens.IsArchived = "0";
        reqtokens.ApplicationStatus = "1";

        FilterData filterData = new FilterData();
        filterData.DSQID = Weburl.DSQ_CommonView;
        filterData.LoadLookupValues = true;
        filterData.LoadRecordInfo = true;
        filterData.Reqtokens = reqtokens;

        String filterjson = jsonEncode(filterData);

        await ApiManager().getCommonLeadList(context, filterjson);

        loader.remove();
      } else {
        loader.remove();
        Helper.Log("respoce", respoce);
      }
    });
  }

/*==============================================================================*/
/*========================  Varification Document list  ========================*/
/*==============================================================================*/

/*Check Varification Document*/
  getVarificationDocumentList(BuildContext context, String filterjson) async {
    HttpClientCall().DSQAPICall(context, filterjson, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }

        tenancyleadlist.sort((a, b) =>
            b.CreatedOn!.toLowerCase().compareTo(a.CreatedOn!.toLowerCase()));

        _store.dispatch(UpdateLLVDvarificationdoclist(<TenancyApplication>[]));
        _store.dispatch(
            UpdateLLVDfiltervarificationdoclist(<TenancyApplication>[]));
        _store.dispatch(UpdateLLVDvarificationdoclist(tenancyleadlist));
        _store.dispatch(UpdateLLVDfiltervarificationdoclist(tenancyleadlist));
        _store.dispatch(UpdateLLVDapplicationisloding(false));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  UpdateReviewstatusVarificationDocumentList(BuildContext context, Object CPOJO,
      Object UpPOJO, CallBackQuesy callBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        await Prefs.setBool(PrefsName.IsApplyFilterList, false);

        FilterReqtokens reqtokens = new FilterReqtokens();
        reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
        reqtokens.IsArchived = "0";
        reqtokens.ApplicationStatus = "3";

        FilterData filterData = new FilterData();
        filterData.DSQID = Weburl.DSQ_CommonView;
        filterData.LoadLookupValues = true;
        filterData.LoadRecordInfo = true;
        filterData.Reqtokens = reqtokens;

        String filterjson = jsonEncode(filterData);
        _store.dispatch(UpdateLLVDapplicationisloding(true));
        await ApiManager().getVarificationDocumentList(context, filterjson);

        loader.remove();
        callBackQuesy(true, "");
      } else {
        loader.remove();
        callBackQuesy(false, "");
        Helper.Log("respoce", respoce);
      }
    });
  }

  getPriviewDocumentData(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_VARIFICATION_DOCUMENTData,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"ApplicantID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          var IDobj = myobject["ID"];

          var Prop_ID = IDobj["Prop_ID"];

          String PropID = Prop_ID['ID'] != null ? Prop_ID['ID'].toString() : "";

          String ApplicantID = myobject['ApplicantID'] != null
              ? myobject['ApplicantID'].toString()
              : "";

          String ID = IDobj['ID'] != null ? IDobj['ID'].toString() : "";

          SystemEnumDetails? ApplicationStatus =
              IDobj['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(IDobj['ApplicationStatus'])
                  : null;

          SystemEnumDetails? DocReviewStatus = IDobj['DocReviewStatus'] != null
              ? SystemEnumDetails.fromJson(IDobj['DocReviewStatus'])
              : null;

          var Applicant_IDobj = IDobj["Applicant_ID"];

          double Rating =
              Applicant_IDobj['Rating'] != null ? Applicant_IDobj['Rating'] : 0;

          String Note = Applicant_IDobj['Note'] != null
              ? Applicant_IDobj['Note'].toString()
              : "";

          var Person_IDObj = Applicant_IDobj["Person_ID"];

          String FirstName = Person_IDObj['FirstName'] != null
              ? Person_IDObj['FirstName'].toString()
              : "";

          String LastName = Person_IDObj['LastName'] != null
              ? Person_IDObj['LastName'].toString()
              : "";

          _store.dispatch(UpdatePDProp_ID(PropID));
          _store.dispatch(UpdatePDApplicantID(ApplicantID));
          _store.dispatch(UpdatePDApplicantionID(ID));
          _store.dispatch(UpdatePDApplicationName(FirstName + " " + LastName));
          _store.dispatch(UpdatePDApplicationStatus(ApplicationStatus));
          _store.dispatch(UpdatePDDocReviewStatus(DocReviewStatus));
          _store.dispatch(UpdatePDRatingReview(Note));
          _store.dispatch(UpdatePDRating(Rating));
        }
        //loader.remove();
        callBackQuesy(true, "");
      } else {
        //loader.remove();
        Helper.Log("respoce", respoce);
        callBackQuesy(false, respoce);
      }
    });
  }

  getPriviewDocumentList(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_VARIFICATION_DOCUMENTLIST,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"ApplicantID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          for (int j = 0; j < data['Result'].length; j++) {
            var objectApplicationDocument = data['Result'][j];

            String ID = objectApplicationDocument['ID'] != null
                ? objectApplicationDocument['ID'].toString()
                : "";

            /*===============*/
            /*  Media Info */
            /*===============*/
            var Media_ID = objectApplicationDocument["Media_ID"];

            int Type = Media_ID['Type'] != null ? Media_ID['Type'] : 0;

            MediaInfo? mediaInfo = objectApplicationDocument['Media_ID'] != null
                ? MediaInfo.fromJson(objectApplicationDocument['Media_ID'])
                : null;

            if (Type == eMediaType().CopyofID) {
              _store.dispatch(UpdatePDMIDDoc1(ID));
              _store.dispatch(UpdatePDMediaInfo1(mediaInfo));
            } else if (Type == eMediaType().Proofoffunds) {
              _store.dispatch(UpdatePDMIDDoc2(ID));
              _store.dispatch(UpdatePDMediaInfo2(mediaInfo));
            } else if (Type == eMediaType().Employmentverification) {
              _store.dispatch(UpdatePDMIDDoc3(ID));
              _store.dispatch(UpdatePDMediaInfo3(mediaInfo));
            } else if (Type == eMediaType().Creditrecord) {
              _store.dispatch(UpdatePDMIDDoc4(ID));
              _store.dispatch(UpdatePDMediaInfo4(mediaInfo));
            }
          }
        } else {}
        //loader.remove();
        callBackQuesy(true, "");
      } else {
        //loader.remove();
        Helper.Log("respoce", respoce);
        callBackQuesy(false, respoce);
      }
    });
  }

  UpdateTenancyVarificationDoc(BuildContext context, Object CPOJO,
      Object UpPOJO, CallBackQuesy callBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        loader.remove();
        callBackQuesy(true, "");
      } else {
        loader.remove();
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

/*==============================================================================*/
/*========================  Tenant Varification Document  ======================*/
/*==============================================================================*/

  getTenancyVarificationDocumentData(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_VARIFICATION_DOCUMENTData,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"ApplicantID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        bool? IsActive;

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          var ApplicantionIDobj = myobject["ID"];

          /*===============*/
          /*  PropertyInfo */
          /*===============*/
          var PropertyInfo = ApplicantionIDobj["Prop_ID"];

          String Property_ID =
              PropertyInfo['ID'] != null ? PropertyInfo['ID'].toString() : "";

          IsActive = PropertyInfo['IsActive'] != null
              ? PropertyInfo['IsActive']
              : "false";

          String Property_name = PropertyInfo['PropertyName'] != null
              ? PropertyInfo['PropertyName'].toString()
              : "";

          String Property_Suite_Unit = PropertyInfo['Suite_Unit'] != null
              ? PropertyInfo['Suite_Unit'].toString()
              : "";

          String Property_Address = PropertyInfo['Property_Address'] != null
              ? PropertyInfo['Property_Address'].toString()
              : "";

          String Property_Postal_Code = PropertyInfo['Postal_Code'] != null
              ? PropertyInfo['Postal_Code'].toString()
              : "";

          String Property_City = PropertyInfo['City'] != null
              ? PropertyInfo['City'].toString()
              : "";

          String Property_Province = PropertyInfo['Province'] != null
              ? PropertyInfo['Province'].toString()
              : "";

          String Property_Country = PropertyInfo['Country'] != null
              ? PropertyInfo['Country'].toString()
              : "";

          var Owner_IDInfo = PropertyInfo["Owner_ID"];

          String CompanyName = Owner_IDInfo['CompanyName'] != null
              ? Owner_IDInfo['CompanyName'].toString()
              : "";

          String HomePageLink = Owner_IDInfo['HomePageLink'] != null
              ? Owner_IDInfo['HomePageLink'].toString()
              : "";

          String CustomerFeatureListingURL =
              Owner_IDInfo['CustomerFeatureListingURL'] != null
                  ? Owner_IDInfo['CustomerFeatureListingURL'].toString()
                  : "";

          MediaInfo? Company_logo = Owner_IDInfo['Company_logo'] != null
              ? MediaInfo.fromJson(Owner_IDInfo['Company_logo'])
              : null;

          _store.dispatch(UpdateTVDCompanyName(CompanyName));
          _store.dispatch(UpdateTVDHomePagelink(HomePageLink));
          _store.dispatch(
              UpdateTVDCustomerFeatureListingURL(CustomerFeatureListingURL));
          _store.dispatch(UpdateTVDCompanyLogo(Company_logo));

          String Address = Property_name +
              (Property_Suite_Unit.isNotEmpty
                  ? " - " + Property_Suite_Unit
                  : "") +
              " - " +
              Property_Address +
              ", " +
              Property_Postal_Code +
              ", " +
              Property_City +
              ", " +
              Property_Province +
              ", " +
              Property_Country;

          _store.dispatch(UpdateTVDPropertyAddress(Address));
          _store.dispatch(UpdateTVDApplicantID(id));

          String ID = ApplicantionIDobj['ID'] != null
              ? ApplicantionIDobj['ID'].toString()
              : "";

          await Prefs.setString(PrefsName.TCF_ApplicationID, ID);

          /* if (myobject['ApplicationDocument'].length > 0) {
            for (int j = 0; j < myobject['ApplicationDocument'].length; j++) {
              var objectApplicationDocument =
                  myobject['ApplicationDocument'][j];

              String ID = objectApplicationDocument['ID'] != null
                  ? objectApplicationDocument['ID'].toString()
                  : "";

              */ /*===============*/ /*
              */ /*  Media Info */ /*
              */ /*===============*/ /*
              var Media_ID = objectApplicationDocument["Media_ID"];

              int Type = Media_ID['Type'] != null ? Media_ID['Type'] : 0;

              MediaInfo? mediaInfo = objectApplicationDocument['Media_ID'] !=
                      null
                  ? MediaInfo.fromJson(objectApplicationDocument['Media_ID'])
                  : null;

              if (Type == eMediaType().CopyofID) {
                _store.dispatch(UpdateTVDMIDDoc1(ID));
                _store.dispatch(UpdateTVDMediaInfo1(mediaInfo));
              } else if (Type == eMediaType().Proofoffunds) {
                _store.dispatch(UpdateTVDMIDDoc2(ID));
                _store.dispatch(UpdateTVDMediaInfo2(mediaInfo));
              } else if (Type == eMediaType().Employmentverification) {
                _store.dispatch(UpdateTVDMIDDoc3(ID));
                _store.dispatch(UpdateTVDMediaInfo3(mediaInfo));
              } else if (Type == eMediaType().Creditrecord) {
                _store.dispatch(UpdateTVDMIDDoc4(ID));
                _store.dispatch(UpdateTVDMediaInfo4(mediaInfo));
              }
            }

            _store.dispatch(UpdateTVDIsDocAvailable(true));
          } else {
            _store.dispatch(UpdateTVDIsDocAvailable(false));
          }*/
        }

        if (IsActive != null && IsActive) {
          callBackQuesy(true, "");
        } else {
          callBackQuesy(false, "1");
        }
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  getTenancyVarificationDocumentList(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_VARIFICATION_DOCUMENTData,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"ApplicantID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        bool? IsActive;

        if (data['Result'].length > 0) {
          for (int j = 0; j < data['Result'].length; j++) {
            var objectApplicationDocument = data['Result'][j];

            String ID = objectApplicationDocument['ID'] != null
                ? objectApplicationDocument['ID'].toString()
                : "";

            /*===============*/
            /*  Media Info */
            /*===============*/
            var Media_ID = objectApplicationDocument["Media_ID"];

            int Type = Media_ID['Type'] != null ? Media_ID['Type'] : 0;

            MediaInfo? mediaInfo = objectApplicationDocument['Media_ID'] != null
                ? MediaInfo.fromJson(objectApplicationDocument['Media_ID'])
                : null;

            if (Type == eMediaType().CopyofID) {
              _store.dispatch(UpdateTVDMIDDoc1(ID));
              _store.dispatch(UpdateTVDMediaInfo1(mediaInfo));
            } else if (Type == eMediaType().Proofoffunds) {
              _store.dispatch(UpdateTVDMIDDoc2(ID));
              _store.dispatch(UpdateTVDMediaInfo2(mediaInfo));
            } else if (Type == eMediaType().Employmentverification) {
              _store.dispatch(UpdateTVDMIDDoc3(ID));
              _store.dispatch(UpdateTVDMediaInfo3(mediaInfo));
            } else if (Type == eMediaType().Creditrecord) {
              _store.dispatch(UpdateTVDMIDDoc4(ID));
              _store.dispatch(UpdateTVDMediaInfo4(mediaInfo));
            }
          }
          _store.dispatch(UpdateTVDIsDocAvailable(true));
        } else {
          _store.dispatch(UpdateTVDIsDocAvailable(false));
        }

        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  TVDMediaInfoDelete(
      BuildContext context,
      Object? M1POJO,
      Object? M2POJO,
      Object? M3POJO,
      Object? M4POJO,
      Object OPOJO,
      CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    /*ApplicationDocument table*/
    String Occ_query = QueryFilter().DeleteQuery(
        OPOJO,
        etableName.ApplicationDocument,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);
    var Occ_querydecode = jsonDecode(Occ_query);
    QueryObject Occ_deletequery = QueryObject.fromJson(Occ_querydecode);
    query_list.add(Occ_deletequery);

    /*MediaInfo table*/
    if (M1POJO != null) {
      String Empquery = QueryFilter().DeleteQuery(M1POJO, etableName.MediaInfo,
          eConjuctionClause().AND, eRelationalOperator().EqualTo);
      var Emp_querydecode = jsonDecode(Empquery);
      QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);
      query_list.add(Emp_deletequery);
    }

    if (M2POJO != null) {
      String Empquery = QueryFilter().DeleteQuery(M2POJO, etableName.MediaInfo,
          eConjuctionClause().AND, eRelationalOperator().EqualTo);
      var Emp_querydecode = jsonDecode(Empquery);
      QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);
      query_list.add(Emp_deletequery);
    }

    if (M3POJO != null) {
      String Empquery = QueryFilter().DeleteQuery(M3POJO, etableName.MediaInfo,
          eConjuctionClause().AND, eRelationalOperator().EqualTo);
      var Emp_querydecode = jsonDecode(Empquery);
      QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);
      query_list.add(Emp_deletequery);
    }

    if (M4POJO != null) {
      String Empquery = QueryFilter().DeleteQuery(M4POJO, etableName.MediaInfo,
          eConjuctionClause().AND, eRelationalOperator().EqualTo);
      var Emp_querydecode = jsonDecode(Empquery);
      QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);
      query_list.add(Emp_deletequery);
    }

    String json = jsonEncode(query_list);

    HttpClientCall().QueryAPICall(context, json, (error, respoce) async {
      if (error) {
        if (respoce != "") {
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
          CallBackQuesy(true, "");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  //Multifile 4 simples
  VarificationDocumentUpload(
      BuildContext context,
      String applicantid,
      String mfilename1,
      Uint8List? mdata1,
      String mfileExten1,
      String mfilename2,
      Uint8List? mdata2,
      String mfileExten2,
      String mfilename3,
      Uint8List? mdata3,
      String mfileExten3,
      String mfilename4,
      Uint8List? mdata4,
      String mfileExten4,
      CallBackListQuesy CallBackQuesy) async {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    var multipartRequest =
        new http.MultipartRequest("POST", Uri.parse(Weburl.FileUpload_Api));
    multipartRequest.headers.addAll(headers);

    if (mdata1 != null) {
      List<int> _selectedFile = mdata1;

      //String filepath = '${DateTime.now().millisecondsSinceEpoch}.png';

      String filepath = "", extenson = "";
      int filetype;
      if (mfileExten1 == "pdf") {
        extenson = "pdf";
        filetype = eMediaFileType().PDF;
        filepath = mfilename1;
      } else if (mfileExten1 == "doc") {
        extenson = "doc";
        filetype = eMediaFileType().Word;
        filepath = mfilename1;
      } else {
        //extenson = "png";
        extenson = mfileExten1;
        filetype = eMediaFileType().Image;
        //filepath = '${DateTime.now().millisecondsSinceEpoch}.png';
        filepath = mfilename1;
      }

      String name = eMediaType().CopyofID.toString() +
          ";" +
          applicantid +
          ";" +
          "0" +
          ";" +
          filetype.toString();

      multipartRequest.files.add(await http.MultipartFile.fromBytes(
          name, _selectedFile,
          contentType: new MediaType('application', extenson),
          filename: filepath));
    }

    if (mdata2 != null) {
      List<int> _selectedFile = mdata2;

      String filepath = "", extenson = "";
      int filetype;
      if (mfileExten2 == "pdf") {
        extenson = "pdf";
        filetype = eMediaFileType().PDF;
        filepath = mfilename2;
      } else if (mfileExten2 == "doc") {
        extenson = "doc";
        filetype = eMediaFileType().Word;
        filepath = mfilename2;
      } else {
        //extenson = "png";
        extenson = mfileExten2;
        filetype = eMediaFileType().Image;
        //filepath = '${DateTime.now().millisecondsSinceEpoch}.png';
        filepath = mfilename2;
      }

      String name = eMediaType().Proofoffunds.toString() +
          ";" +
          applicantid +
          ";" +
          "0" +
          ";" +
          filetype.toString();

      multipartRequest.files.add(await http.MultipartFile.fromBytes(
          name, _selectedFile,
          contentType: new MediaType('application', extenson),
          filename: filepath));
    }

    if (mdata3 != null) {
      List<int> _selectedFile = mdata3;

      String filepath = "", extenson = "";
      int filetype;
      if (mfileExten3 == "pdf") {
        extenson = "pdf";
        filetype = eMediaFileType().PDF;
        filepath = mfilename3;
      } else if (mfileExten3 == "doc") {
        extenson = "doc";
        filetype = eMediaFileType().Word;
        filepath = mfilename3;
      } else {
        //extenson = "png";
        extenson = mfileExten3;
        filetype = eMediaFileType().Image;
        //filepath = '${DateTime.now().millisecondsSinceEpoch}.png';
        filepath = mfilename3;
      }

      String name = eMediaType().Employmentverification.toString() +
          ";" +
          applicantid +
          ";" +
          "0" +
          ";" +
          filetype.toString();

      multipartRequest.files.add(await http.MultipartFile.fromBytes(
          name, _selectedFile,
          contentType: new MediaType('application', extenson),
          filename: filepath));
    }

    if (mdata4 != null) {
      List<int> _selectedFile = mdata4;

      String filepath = "", extenson = "";
      int filetype;
      if (mfileExten4 == "pdf") {
        extenson = "pdf";
        filetype = eMediaFileType().PDF;
        filepath = mfilename4;
      } else if (mfileExten4 == "doc") {
        extenson = "doc";
        filetype = eMediaFileType().Word;
        filepath = mfilename4;
      } else {
        //extenson = "png";
        extenson = mfileExten4;
        filetype = eMediaFileType().Image;
        //filepath = '${DateTime.now().millisecondsSinceEpoch}.png';
        filepath = mfilename4;
      }

      String name = eMediaType().Creditrecord.toString() +
          ";" +
          applicantid +
          ";" +
          "0" +
          ";" +
          filetype.toString();

      multipartRequest.files.add(await http.MultipartFile.fromBytes(
          name, _selectedFile,
          contentType: new MediaType('application', extenson),
          filename: filepath));
    }

    await multipartRequest.send().then((result) {
      if (result.statusCode == 200) {
        http.Response.fromStream(result).then((response) {
          if (response.statusCode == 200) {
            if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
              var data = jsonDecode(response.body);

              if (data != null) {
                List<String> mediaString = [];
                for (int i = 0; i < data['Result'].length; i++) {
                  var myobject = data['Result'][i];

                  String MediaID = myobject['MediaID'] != null
                      ? "" + myobject['MediaID'].toString()
                      : "";

                  String url = myobject['url'] != null
                      ? "" + myobject['url'].toString()
                      : "";

                  mediaString.add(MediaID);

                  if (data['Result'].length - 1 == i) {
                    CallBackQuesy(true, mediaString, "");
                  }
                }
              } else {
                CallBackQuesy(false, [], GlobleString.Error);
              }
            } else {
              CallBackQuesy(false, [], GlobleString.Error);
            }
          } else if (response.statusCode == 401) {
            CallBackQuesy(false, [], GlobleString.Error_401);
          } else {
            CallBackQuesy(false, [], GlobleString.Error);
          }
        });
      } else if (result.statusCode == 401) {
        CallBackQuesy(false, [], GlobleString.Error_401);
      } else {
        CallBackQuesy(false, [], GlobleString.Error);
      }
    });
  }

  InsetApplicantDocument(
      BuildContext context, List<Object> POJO, CallBackQuesy CallBackQuesy) {
    String json = QueryFilter().InsertQueryArray(
        POJO,
        etableName.ApplicationDocument,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

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
            CallBackQuesy(false, respoce);
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

  UapdateApplicantDocumentReceiveDate(BuildContext context, Object CPOJO,
      Object UpPOJO, CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        callBackQuesy(true, Result);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*==============================================================================*/
/*========================  Reference check list  ========================*/
/*==============================================================================*/

  getApplicantReferenceCheckList(BuildContext context, String json) async {
    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }

        tenancyleadlist.sort((a, b) =>
            b.CreatedOn!.toLowerCase().compareTo(a.CreatedOn!.toLowerCase()));

        _store.dispatch(UpdateLLRCReferenceCheckslist(tenancyleadlist));
        _store.dispatch(UpdateLLRCfilterReferenceCheckslist(tenancyleadlist));
        _store.dispatch(UpdateLLRCisloding(false));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  getReferenceListApplicantWise(BuildContext context, String applicationd,
      CallBackReferenceQuery callBackReferenceQuery) async {
    var myjson = {
      "DSQID": Weburl.DSQ_REFERENCE_LIST_APPLICANT_WISE,
      "LoadLookupValues": true,
      "Reqtokens": {
        "ID": applicationd,
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<LeadReference> referencelist = <LeadReference>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ID =
              myobject['ID'] != null ? "" + myobject['ID'].toString() : "";

          String ReferenceFirstName = myobject['ReferenceFirstName'] != null
              ? "" + myobject['ReferenceFirstName'].toString()
              : "";

          String ReferenceLastName = myobject['ReferenceLastName'] != null
              ? "" + myobject['ReferenceLastName'].toString()
              : "";

          String QuestionnaireReceivedDate =
              myobject['QuestionnaireReceivedDate'] != null
                  ? "" + myobject['QuestionnaireReceivedDate'].toString()
                  : "";

          String QuestionnaireSentDate =
              myobject['QuestionnaireSentDate'] != null
                  ? "" + myobject['QuestionnaireSentDate'].toString()
                  : "";

          String ReferenceID = myobject['ReferenceID'] != null
              ? "" + myobject['ReferenceID'].toString()
              : "";

          String Relationship = myobject['Relationship'] != null
              ? "" + myobject['Relationship'].toString()
              : "";

          String ToEmail = myobject['ToEmail'] != null
              ? "" + myobject['ToEmail'].toString()
              : "";

          String PhoneNumber = myobject['PhoneNumber'] != null
              ? "" + myobject['PhoneNumber'].toString()
              : "";

          String LandlordFirstName = myobject['LandlordFirstName'] != null
              ? "" + myobject['LandlordFirstName'].toString()
              : "";

          String LandlordLastName = myobject['LandlordLastName'] != null
              ? "" + myobject['LandlordLastName'].toString()
              : "";

          String PersonID = myobject['PersonID'] != null
              ? "" + myobject['PersonID'].toString()
              : "";

          String Applicant_ID = myobject['Applicant_ID'] != null
              ? "" + myobject['Applicant_ID'].toString()
              : "";

          String ApplicantFirstName = myobject['ApplicantFirstName'] != null
              ? "" + myobject['ApplicantFirstName'].toString()
              : "";

          String ApplicantLastName = myobject['ApplicantLastName'] != null
              ? "" + myobject['ApplicantLastName'].toString()
              : "";

          String PropertyID = myobject['PropertyID'] != null
              ? "" + myobject['PropertyID'].toString()
              : "";

          String PropertyName = myobject['PropertyName'] != null
              ? "" + myobject['PropertyName'].toString()
              : "";

          String Property_Address = myobject['Property_Address'] != null
              ? "" + myobject['Property_Address'].toString()
              : "";

          LeadReference doclead = new LeadReference();
          doclead.id = ID;
          doclead.applicationid = applicationd;
          doclead.personId = PersonID;
          doclead.applicantName = doclead.toEmail = ToEmail;
          doclead.phoneNumber = PhoneNumber;
          doclead.propertyId = PropertyID;
          doclead.propertyName = PropertyName;
          doclead.propertyAddress = Property_Address;
          doclead.referenceId = ReferenceID;
          doclead.referenceName = ReferenceFirstName.toString() +
              " " +
              ReferenceLastName.toString();
          doclead.questionnaireSentDate = QuestionnaireSentDate;
          doclead.questionnaireReceivedDate = QuestionnaireReceivedDate;
          doclead.relationship = Relationship;
          doclead.landlordName =
              LandlordFirstName.toString() + " " + LandlordLastName.toString();
          doclead.applicantId = Applicant_ID;
          doclead.applicantName = ApplicantFirstName.toString() +
              " " +
              ApplicantLastName.toString();
          doclead.check = false;

          referencelist.add(doclead);
        }

        callBackReferenceQuery(true, referencelist, "");
      } else {
        callBackReferenceQuery(false, <LeadReference>[], "");
        Helper.Log("respoce", respoce);
      }
    });
  }

  InsertReferenceAnswere(
      BuildContext context, Object POJO, CallBackQuesy callBackQuesy) {
    String query = QueryFilter().InsertQuery(POJO, etableName.ReferenceAnswers,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        callBackQuesy(true, Result);
      } else {
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

  UpdateReferenceAnswere(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.ReferenceAnswers,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";

        callBackQuesy(true, Result);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  UpdateReferenceReceiveDate(BuildContext context, String applicationid,
      String referenceid, String date, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_ReferenceRequestReceivedDate,
      "Reqtokens": {
        "ID": applicationid,
        "ReceivedDate": date,
        "ReferenceID": referenceid,
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  getReferenceDetailsAPi(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_REFERENCE_Details,
      "LoadLookUpValues": true,
      "Reqtokens": {
        "AdditionalReferencesID": id,
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        Helper.Log("getReferenceDetailsAPi", respoce);

        bool? IsActive;

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String RelationWithApplicant =
              myobject['RelationWithApplicant'] != null
                  ? "" + myobject['RelationWithApplicant'].toString()
                  : "";

          bool? IsRecommendedTenant = myobject['IsRecommendedTenant'] != null
              ? myobject['IsRecommendedTenant']
              : null;

          double Communication =
              myobject['Communication'] != null ? myobject['Communication'] : 0;

          String OtherComments = myobject['OtherComments'] != null
              ? myobject['OtherComments'].toString()
              : "";

          double PaymentPunctuality = myobject['PaymentPunctuality'] != null
              ? myobject['PaymentPunctuality']
              : 0;

          double Cleanliness =
              myobject['Cleanliness'] != null ? myobject['Cleanliness'] : 0;

          String Reason_For_Departure = myobject['Reason_For_Departure'] != null
              ? myobject['Reason_For_Departure'].toString()
              : "";

          int Length_Of_Tenancy = myobject['Length_Of_Tenancy'] != null
              ? myobject['Length_Of_Tenancy']
              : 0;

          double Respectfulness = myobject['Respectfulness'] != null
              ? myobject['Respectfulness']
              : 0;

          String QuestionnaireSentDate =
              myobject['QuestionnaireSentDate'] != null
                  ? myobject['QuestionnaireSentDate'].toString()
                  : "";

          String QuestionnaireReceivedDate =
              myobject['QuestionnaireReceivedDate'] != null
                  ? myobject['QuestionnaireReceivedDate'].toString()
                  : "";

          String AdditionalReferencesID =
              myobject['AdditionalReferencesID'] != null
                  ? myobject['AdditionalReferencesID'].toString()
                  : "";

          /*ReferenceID*/
          var objReferenceID = myobject["ReferenceID"];

          String RefFirstName = objReferenceID['FirstName'] != null
              ? objReferenceID['FirstName'].toString()
              : "";

          String RefLastName = objReferenceID['LastName'] != null
              ? objReferenceID['LastName'].toString()
              : "";

          /*ApplicationID*/
          var objApplicationID = myobject["ID"];

          String ApplicationID = objApplicationID['ID'] != null
              ? objApplicationID['ID'].toString()
              : "";

          /*Property Id*/
          /*====================================================*/
          var Prop_ID = myobject["Prop_ID"];

          var Owner_IDInfo = Prop_ID['Owner_ID'];

          String CompanyName = Owner_IDInfo['CompanyName'] != null
              ? Owner_IDInfo['CompanyName'].toString()
              : "";

          String HomePageLink = Owner_IDInfo['HomePageLink'] != null
              ? Owner_IDInfo['HomePageLink'].toString()
              : "";

          String CustomerFeatureListingURL =
              Owner_IDInfo['CustomerFeatureListingURL'] != null
                  ? Owner_IDInfo['CustomerFeatureListingURL'].toString()
                  : "";

          MediaInfo? Company_logo = Owner_IDInfo['Company_logo'] != null
              ? MediaInfo.fromJson(Owner_IDInfo['Company_logo'])
              : null;

          _store.dispatch(UpdateRQCompanyName(CompanyName));
          _store.dispatch(UpdateRQHomePagelink(HomePageLink));
          _store.dispatch(
              UpdateRQCustomerFeatureListingURL(CustomerFeatureListingURL));
          _store.dispatch(UpdateRQCompanyLogo(Company_logo));

          /*====================================================*/
          var objApplicant_ID = myobject["Applicant_ID"];

          String ApplicantID = objApplicant_ID['ID'] != null
              ? objApplicant_ID['ID'].toString()
              : "";

          /*------------------------------------------------*/

          var objPerson_ID = objApplicant_ID['Person_ID'];

          String PersonID =
              objPerson_ID['ID'] != null ? objPerson_ID['ID'].toString() : "";

          String AppFirstName = objPerson_ID['FirstName'] != null
              ? objPerson_ID['FirstName'].toString()
              : "";
          String AppLastName = objPerson_ID['LastName'] != null
              ? objPerson_ID['LastName'].toString()
              : "";

          /*====================================================*/

          /*===============*/
          /*  PropertyInfo */
          /*===============*/
          var PropertyInfo = myobject["Prop_ID"];

          String Property_ID =
              PropertyInfo['ID'] != null ? PropertyInfo['ID'].toString() : "";

          IsActive = PropertyInfo['IsActive'] != null
              ? PropertyInfo['IsActive']
              : "false";

          if (Cleanliness == 0 &&
              Communication == 0 &&
              Respectfulness == 0 &&
              PaymentPunctuality == 0 &&
              Reason_For_Departure == "" &&
              OtherComments == "") {
            _store.dispatch(UpdateRQisUpdate(false));
          } else {
            _store.dispatch(UpdateRQisUpdate(true));
          }

          _store.dispatch(UpdateRQLenthTenancy(Length_Of_Tenancy));
          _store.dispatch(UpdateRQCleanlinessRating(Cleanliness));
          _store.dispatch(UpdateRQCommunicationRating(Communication));
          _store.dispatch(UpdateRQRespectfulnessRating(Respectfulness));
          _store.dispatch(UpdateRQPaymentPunctualityRating(PaymentPunctuality));
          _store.dispatch(UpdateRQYesNo(IsRecommendedTenant));
          _store.dispatch(UpdateRQReasonDeparture(Reason_For_Departure));
          _store.dispatch(UpdateRQOtherComments(OtherComments));
          _store.dispatch(
              UpdateRQApplicantName(AppFirstName + " " + AppLastName));
          _store.dispatch(UpdateRQApplicantId(ApplicantID));
          _store.dispatch(
              UpdateRQReferenceName(RefFirstName + " " + RefLastName));
          _store.dispatch(UpdateRQReferenceId(AdditionalReferencesID));
          _store.dispatch(UpdateRQApplicationId(ApplicationID));

          if (IsActive != null && IsActive) {
            callBackQuesy(true, "");
          } else {
            callBackQuesy(false, "1");
          }
        }
      } else {
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

  getReferenceDetailsAPISingle(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_REFERENCE_Details,
      "LoadLookUpValues": true,
      "Reqtokens": {
        "AdditionalReferencesID": id,
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String RelationWithApplicant =
              myobject['RelationWithApplicant'] != null
                  ? "" + myobject['RelationWithApplicant'].toString()
                  : "";

          bool IsRecommendedTenant = myobject['IsRecommendedTenant'] != null
              ? myobject['IsRecommendedTenant']
              : false;

          double Communication =
              myobject['Communication'] != null ? myobject['Communication'] : 0;

          String OtherComments = myobject['OtherComments'] != null
              ? myobject['OtherComments'].toString()
              : "";

          double PaymentPunctuality = myobject['PaymentPunctuality'] != null
              ? myobject['PaymentPunctuality']
              : 0;

          double Cleanliness =
              myobject['Cleanliness'] != null ? myobject['Cleanliness'] : 0;

          String Reason_For_Departure = myobject['Reason_For_Departure'] != null
              ? myobject['Reason_For_Departure'].toString()
              : "";

          int Length_Of_Tenancy = myobject['Length_Of_Tenancy'] != null
              ? myobject['Length_Of_Tenancy']
              : 1;

          double Respectfulness = myobject['Respectfulness'] != null
              ? myobject['Respectfulness']
              : 0;

          String QuestionnaireSentDate =
              myobject['QuestionnaireSentDate'] != null
                  ? myobject['QuestionnaireSentDate'].toString()
                  : "";

          String QuestionnaireReceivedDate =
              myobject['QuestionnaireReceivedDate'] != null
                  ? myobject['QuestionnaireReceivedDate'].toString()
                  : "";

          String AdditionalReferencesID =
              myobject['AdditionalReferencesID'] != null
                  ? myobject['AdditionalReferencesID'].toString()
                  : "";

          /*ReferenceID*/
          var objReferenceID = myobject["ReferenceID"];

          String RefFirstName = objReferenceID['FirstName'] != null
              ? objReferenceID['FirstName'].toString()
              : "";

          String RefLastName = objReferenceID['LastName'] != null
              ? objReferenceID['LastName'].toString()
              : "";

          String RefEmail = objReferenceID['Email'] != null
              ? objReferenceID['Email'].toString()
              : "";

          String RefMobileNumber = objReferenceID['MobileNumber'] != null
              ? objReferenceID['MobileNumber'].toString()
              : "";

          /*ApplicationID*/
          var objApplicationID = myobject["ID"];

          String ApplicationID = objApplicationID['ID'] != null
              ? objApplicationID['ID'].toString()
              : "";

          /*====================================================*/
          var objApplicant_ID = myobject["Applicant_ID"];

          String ApplicantID = objApplicant_ID['ID'] != null
              ? objApplicant_ID['ID'].toString()
              : "";

          /*------------------------------------------------*/

          var objPerson_ID = objApplicant_ID['Person_ID'];

          String PersonID =
              objPerson_ID['ID'] != null ? objPerson_ID['ID'].toString() : "";

          String AppFirstName = objPerson_ID['FirstName'] != null
              ? objPerson_ID['FirstName'].toString()
              : "";
          String AppLastName = objPerson_ID['LastName'] != null
              ? objPerson_ID['LastName'].toString()
              : "";

          /*====================================================*/

          /*====================================================*/
          var objProp_ID = myobject["Prop_ID"];

          String PropertyName = objProp_ID['PropertyName'] != null
              ? objProp_ID['PropertyName'].toString()
              : "";

          String Suite_Unit = objProp_ID['Suite_Unit'] != null
              ? objProp_ID['Suite_Unit'].toString()
              : "";

          _store.dispatch(UpdateRQDetailsLenthTenancy(Length_Of_Tenancy));
          _store.dispatch(UpdateRQDetailsCleanlinessRating(Cleanliness));
          _store.dispatch(UpdateRQDetailsCommunicationRating(Communication));
          _store.dispatch(UpdateRQDetailsRespectfulnessRating(Respectfulness));
          _store.dispatch(
              UpdateRQDetailsPaymentPunctualityRating(PaymentPunctuality));
          _store.dispatch(UpdateRQDetailsYesNo(IsRecommendedTenant));
          _store.dispatch(UpdateRQDetailsReasonDeparture(Reason_For_Departure));
          _store.dispatch(UpdateRQDetailsOtherComments(OtherComments));
          _store.dispatch(
              UpdateRQDetailsApplicantName(AppFirstName + " " + AppLastName));
          _store.dispatch(UpdateRQDetailsPropertyName(
              PropertyName + " Unit - " + Suite_Unit));
          _store.dispatch(
              UpdateRQDetailsReferenceName(RefFirstName + " " + RefLastName));
          _store.dispatch(UpdateRQDetailsReferenceEmail(RefEmail));
          _store.dispatch(UpdateRQDetailsReferencePhone(RefMobileNumber));
          _store.dispatch(
              UpdateRQDetailsReferenceRelationShip(RelationWithApplicant));

          callBackQuesy(true, "");
        }
      } else {
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

/*==============================================================================*/
/*==============================  Lease list  ================================*/
/*==============================================================================*/

  getLeaseLeadList(BuildContext context, String json) async {
    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("respoce", respoce);
        var data = jsonDecode(respoce);

        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }

        tenancyleadlist.sort((a, b) =>
            b.CreatedOn!.toLowerCase().compareTo(a.CreatedOn!.toLowerCase()));

        _store.dispatch(UpdateLLTLleaseleadlist(tenancyleadlist));
        _store.dispatch(UpdateLLTLfilterleaseleadlist(tenancyleadlist));
        _store.dispatch(UpdateLLTLleaseisloding(false));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

  UpdateReviewstatusLeaseList(
      BuildContext context, Object CPOJO, Object UpPOJO) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        Helper.Log("UpdateAppstatusVarificationDocumentList", respoce);

        await Prefs.setBool(PrefsName.IsApplyFilterList, false);
        FilterReqtokens reqtokens = new FilterReqtokens();
        reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
        reqtokens.IsArchived = "0";
        reqtokens.ApplicationStatus = "5";

        FilterData filterData = new FilterData();
        filterData.DSQID = Weburl.DSQ_CommonView;
        filterData.LoadLookupValues = true;
        filterData.LoadRecordInfo = true;
        filterData.Reqtokens = reqtokens;

        String filterjson = jsonEncode(filterData);
        _store.dispatch(UpdateLLTLleaseisloding(true));
        await ApiManager().getLeaseLeadList(context, filterjson);

        loader.remove();
      } else {
        loader.remove();
        Helper.Log("respoce", respoce);
        ;
      }
    });
  }

  //Multifile
  AddLeaseDocument(BuildContext context, Uint8List data, String filename,
      CallBackQuesy CallBackQuesy) async {
    List<int> _selectedFile = data;

    String filepath;

    if (filename.isNotEmpty) {
      filepath = filename;
    } else {
      filepath = 'Lease_' + '${DateTime.now().millisecondsSinceEpoch}.pdf';
    }

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    var multipartRequest =
        new http.MultipartRequest("POST", Uri.parse(Weburl.FileUpload_Api));
    multipartRequest.headers.addAll(headers);

    multipartRequest.files.add(await http.MultipartFile.fromBytes(
        'file[]', _selectedFile,
        contentType: new MediaType('application', 'pdf'), filename: filepath));

    await multipartRequest.send().then((result) {
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

  TLAMediaInfoDelete(BuildContext context, Object? M1POJO, Object OPOJO,
      CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    /*ApplicationDocument table*/
    String Occ_query = QueryFilter().DeleteQuery(
        OPOJO,
        etableName.PropertyDocument,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    var Occ_querydecode = jsonDecode(Occ_query);
    QueryObject Occ_deletequery = QueryObject.fromJson(Occ_querydecode);
    query_list.add(Occ_deletequery);

    /*MediaInfo table*/
    if (M1POJO != null) {
      String Empquery = QueryFilter().DeleteQuery(M1POJO, etableName.MediaInfo,
          eConjuctionClause().AND, eRelationalOperator().EqualTo);
      var Emp_querydecode = jsonDecode(Empquery);
      QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);
      query_list.add(Emp_deletequery);
    }

    String json = jsonEncode(query_list);

    HttpClientCall().QueryAPICall(context, json, (error, respoce) async {
      if (error) {
        if (respoce != "") {
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
          CallBackQuesy(true, "");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  //Multifile
  TenantLeaseAgreementUpload(BuildContext context, Uint8List? mdata1,
      String filename1, CallBackQuesy callBackQuesy) async {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    var multipartRequest =
        new http.MultipartRequest("POST", Uri.parse(Weburl.FileUpload_Api));
    multipartRequest.headers.addAll(headers);

    List<int> _selectedFile = mdata1!;

    /* String filepath = '${DateTime
        .now()
        .millisecondsSinceEpoch}.pdf';*/

    multipartRequest.files.add(await http.MultipartFile.fromBytes(
        "file[]", _selectedFile,
        contentType: new MediaType('application', "pdf"), filename: filename1));

    await multipartRequest.send().then((result) {
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

                  callBackQuesy(true, MediaID);
                }
              } else {
                callBackQuesy(false, GlobleString.Error);
              }
            } else {
              callBackQuesy(false, GlobleString.Error);
            }
          } else if (response.statusCode == 401) {
            callBackQuesy(false, GlobleString.Error_401);
          } else {
            callBackQuesy(false, GlobleString.Error);
          }
        });
      } else if (result.statusCode == 401) {
        callBackQuesy(false, GlobleString.Error_401);
      } else {
        callBackQuesy(false, GlobleString.Error);
      }
    });
  }

  InsetPropertyDocument(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String json = QueryFilter().InsertQuery(POJO, etableName.PropertyDocument,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, "");
      } else {
        CallBackQuesy(false, "");
      }
    });
  }

  UpdateApplicantAggreementReceiveDate(BuildContext context, Object CPOJO,
      Object UpPOJO, CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        callBackQuesy(true, Result);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  getLeaseDetailsView(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_LEASE_DETAILS,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        bool? IsActive;

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          /*===============*/
          /*  PropertyInfo */
          /*===============*/
          var PropertyInfo = myobject["Prop_ID"];

          String Property_ID =
              PropertyInfo['ID'] != null ? PropertyInfo['ID'].toString() : "";

          String PropertyName = PropertyInfo['PropertyName'] != null
              ? PropertyInfo['PropertyName'].toString()
              : "";

          IsActive = PropertyInfo['IsActive'] != null
              ? PropertyInfo['IsActive']
              : "false";

          String Property_Suite_Unit = PropertyInfo['Suite_Unit'] != null
              ? PropertyInfo['Suite_Unit'].toString()
              : "";

          String Property_Address = PropertyInfo['Property_Address'] != null
              ? PropertyInfo['Property_Address'].toString()
              : "";

          String Property_Postal_Code = PropertyInfo['Postal_Code'] != null
              ? PropertyInfo['Postal_Code'].toString()
              : "";

          String Property_City = PropertyInfo['City'] != null
              ? PropertyInfo['City'].toString()
              : "";

          String Property_Province = PropertyInfo['Province'] != null
              ? PropertyInfo['Province'].toString()
              : "";

          String Property_Country = PropertyInfo['Country'] != null
              ? PropertyInfo['Country'].toString()
              : "";

          var Owner_IDInfo = PropertyInfo["Owner_ID"];

          String CompanyName = Owner_IDInfo['CompanyName'] != null
              ? Owner_IDInfo['CompanyName'].toString()
              : "";

          String HomePageLink = Owner_IDInfo['HomePageLink'] != null
              ? Owner_IDInfo['HomePageLink'].toString()
              : "";

          String CustomerFeatureListingURL =
              Owner_IDInfo['CustomerFeatureListingURL'] != null
                  ? Owner_IDInfo['CustomerFeatureListingURL'].toString()
                  : "";

          MediaInfo? Company_logo = Owner_IDInfo['Company_logo'] != null
              ? MediaInfo.fromJson(Owner_IDInfo['Company_logo'])
              : null;

          _store.dispatch(UpdateTLACompanyName(CompanyName));
          _store.dispatch(UpdateTLAHomePagelink(HomePageLink));
          _store.dispatch(
              UpdateTLACustomerFeatureListingURL(CustomerFeatureListingURL));
          _store.dispatch(UpdateTLACompanyLogo(Company_logo));

          String Address = PropertyName +
              (Property_Suite_Unit != null && Property_Suite_Unit.isNotEmpty
                  ? " - " + Property_Suite_Unit
                  : "") +
              " - " +
              Property_Address +
              ", " +
              Property_Postal_Code +
              ", " +
              Property_City +
              ", " +
              Property_Province +
              ", " +
              Property_Country;

          _store.dispatch(UpdateTLAPropertyAddress(Address));
          _store.dispatch(UpdateTLAProp_ID(Property_ID));
          _store.dispatch(UpdateTLAApplication_ID(id));

          String ApplicantID = myobject['ApplicantID'] != null
              ? myobject['ApplicantID'].toString()
              : "";

          await Prefs.setString(PrefsName.TCF_ApplicantID, ApplicantID);

          _store.dispatch(UpdateTLAApplicantID(ApplicantID));

          /*if (myobject['PropertyDocument'].length > 0) {
            for (int j = 0; j < myobject['PropertyDocument'].length; j++) {
              var objectPropertyDocument = myobject['PropertyDocument'][j];

              String ID = objectPropertyDocument['ID'] != null
                  ? objectPropertyDocument['ID'].toString()
                  : "";

              bool IsOwneruploaded =
                  objectPropertyDocument['IsOwneruploaded'] != null
                      ? objectPropertyDocument['IsOwneruploaded']
                      : false;

              String Owner_ID = objectPropertyDocument['Owner_ID'] != null
                  ? objectPropertyDocument['Owner_ID'].toString()
                  : "";

              */ /*===============*/ /*
              */ /*  Media Info */ /*
              */ /*===============*/ /*

              MediaInfo? mediaInfo = objectPropertyDocument['Media_ID'] != null
                  ? MediaInfo.fromJson(objectPropertyDocument['Media_ID'])
                  : null;

              if (IsOwneruploaded) {
                _store.dispatch(UpdateTLAIsDocAvailable(false));
                _store.dispatch(UpdateTLAMIDDoc1(ID));
                _store.dispatch(UpdateTLAMediaInfo1(mediaInfo));
              } else {
                _store.dispatch(UpdateTLAIsDocAvailable(true));
                _store.dispatch(UpdateTLAMIDDoc2(ID));
                _store.dispatch(UpdateTLAMediaInfo2(mediaInfo));
              }

              _store.dispatch(UpdateTLAOwner_ID(Owner_ID));
            }
          } else {
            _store.dispatch(UpdateTLAIsDocAvailable(false));
          }*/
        }

        if (IsActive != null && IsActive) {
          callBackQuesy(true, "");
        } else {
          callBackQuesy(false, "1");
        }
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  LeaseAgreementDoc(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_LEASE_Document,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"Application_ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var objectPropertyDocument = data['Result'][i];

            String ID = objectPropertyDocument['ID'] != null
                ? objectPropertyDocument['ID'].toString()
                : "";

            bool IsOwneruploaded =
                objectPropertyDocument['IsOwneruploaded'] != null
                    ? objectPropertyDocument['IsOwneruploaded']
                    : false;

            String Owner_ID = objectPropertyDocument['Owner_ID'] != null
                ? objectPropertyDocument['Owner_ID'].toString()
                : "";

            /*===============*/
            /*  Media Info */
            /*===============*/

            MediaInfo? mediaInfo = objectPropertyDocument['Media_ID'] != null
                ? MediaInfo.fromJson(objectPropertyDocument['Media_ID'])
                : null;

            if (IsOwneruploaded) {
              _store.dispatch(UpdateTLAIsDocAvailable(false));
              _store.dispatch(UpdateTLAMIDDoc1(ID));
              _store.dispatch(UpdateTLAMediaInfo1(mediaInfo));
            } else {
              _store.dispatch(UpdateTLAIsDocAvailable(true));
              _store.dispatch(UpdateTLAMIDDoc2(ID));
              _store.dispatch(UpdateTLAMediaInfo2(mediaInfo));
            }

            _store.dispatch(UpdateTLAOwner_ID(Owner_ID));
          }
        } else {
          _store.dispatch(UpdateTLAIsDocAvailable(false));
        }
        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  PreviewLeaseAgreement(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_LEASE_DETAILS,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          /*===============*/
          /*  ApplicantionInfo */
          /*===============*/
          var ApplicantionObj = myobject["ID"];

          String Applicantion_ID = ApplicantionObj['ID'] != null
              ? ApplicantionObj['ID'].toString()
              : "";

          String AgreementReceivedDate =
              ApplicantionObj['AgreementReceivedDate'] != null
                  ? ApplicantionObj['AgreementReceivedDate'].toString()
                  : "";

          var Applicant_IDobj = ApplicantionObj["Applicant_ID"];

          var Person_IDobj = Applicant_IDobj["Person_ID"];

          String FirstName = Person_IDobj['FirstName'] != null
              ? Person_IDobj['FirstName'].toString()
              : "";

          String LastName = Person_IDobj['LastName'] != null
              ? Person_IDobj['LastName'].toString()
              : "";

          _store.dispatch(UpdatePLApplicantionID(Applicantion_ID));
          _store.dispatch(UpdatePLApplicationName(FirstName + " " + LastName));
          _store.dispatch(UpdatePLAgreementReceiveDate(AgreementReceivedDate));

          String ApplicantID = myobject['ApplicantID'] != null
              ? myobject['ApplicantID'].toString()
              : "";

          _store.dispatch(UpdatePLApplicantID(ApplicantID));

          /* if (myobject['PropertyDocument'].length > 0) {
            for (int j = 0; j < myobject['PropertyDocument'].length; j++) {
              var objectPropertyDocument = myobject['PropertyDocument'][j];

              String ID = objectPropertyDocument['ID'] != null
                  ? objectPropertyDocument['ID'].toString()
                  : "";

              bool IsOwneruploaded =
                  objectPropertyDocument['IsOwneruploaded'] != null
                      ? objectPropertyDocument['IsOwneruploaded']
                      : false;

              String Owner_ID = objectPropertyDocument['Owner_ID'] != null
                  ? objectPropertyDocument['Owner_ID'].toString()
                  : "";

              */ /*===============*/ /*
              */ /*  Media Info */ /*
              */ /*===============*/ /*

              MediaInfo? mediaInfo = objectPropertyDocument['Media_ID'] != null
                  ? MediaInfo.fromJson(objectPropertyDocument['Media_ID'])
                  : null;

              if (!IsOwneruploaded) {
                _store.dispatch(UpdatePLMIDDoc1(ID));
                _store.dispatch(UpdatePLMediaInfo1(mediaInfo));
              }
            }
          }*/
        }

        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  PreviewLeaseAgreementDoc(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_LEASE_Document,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"Application_ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var objectPropertyDocument = data['Result'][i];

            String ID = objectPropertyDocument['ID'] != null
                ? objectPropertyDocument['ID'].toString()
                : "";

            bool IsOwneruploaded =
                objectPropertyDocument['IsOwneruploaded'] != null
                    ? objectPropertyDocument['IsOwneruploaded']
                    : false;

            String Owner_ID = objectPropertyDocument['Owner_ID'] != null
                ? objectPropertyDocument['Owner_ID'].toString()
                : "";

            /*===============*/
            /*  Media Info */
            /*===============*/

            MediaInfo? mediaInfo = objectPropertyDocument['Media_ID'] != null
                ? MediaInfo.fromJson(objectPropertyDocument['Media_ID'])
                : null;

            if (!IsOwneruploaded) {
              _store.dispatch(UpdatePLMIDDoc1(ID));
              _store.dispatch(UpdatePLMediaInfo1(mediaInfo));
            }
          }
        }
        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*==============================================================================*/
/*==============================  Active Tenant list  ================================*/
/*==============================================================================*/

  getActiveTenantLeadList(BuildContext context, String json) async {
    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }

        tenancyleadlist.sort((a, b) =>
            b.CreatedOn!.toLowerCase().compareTo(a.CreatedOn!.toLowerCase()));

        _store.dispatch(UpdateLLActiveTenantleadlist(tenancyleadlist));
        _store.dispatch(UpdateLLActiveTenantfilterleadlist(tenancyleadlist));
        _store.dispatch(UpdateLLActiveTenantisloding(false));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

/*==============================================================================*/
/*==============================  Archive list  ================================*/
/*==============================================================================*/

  getTenancyArchiveList(BuildContext context, String json) async {
    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String MobileNumber = myobject['MobileNumber'] != null
              ? myobject['MobileNumber'].toString()
              : "";

          String Dial_Code = myobject['Dial_Code'] != null
              ? myobject['Dial_Code'].toString()
              : "+1";

          int QuestionnairesSentCount =
              myobject['Questionnaires Sent Count'] != null
                  ? myobject['Questionnaires Sent Count']
                  : 0;

          int QuestionnairesReceivedCount =
              myobject['Questionnaires Received Count'] != null
                  ? myobject['Questionnaires Received Count']
                  : 0;

          bool IsAuthorized = myobject['IsAuthorized'] != null
              ? myobject['IsAuthorized']
              : false;

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          int AnnualIncome =
              myobject['Annual Income'] != null ? myobject['Annual Income'] : 0;

          int ReferenceStatus = myobject['ReferenceStatus'] != null
              ? myobject['ReferenceStatus']
              : 0;

          int NumberofOccupants = myobject['Number of Occupants'] != null
              ? myobject['Number of Occupants']
              : 0;

          int IsArchived =
              myobject['IsArchived'] != null ? myobject['IsArchived'] : 0;

          bool Pets = myobject['Pets'] != null ? myobject['Pets'] : false;

          int ReferencesCount = myobject['References Count'] != null
              ? myobject['References Count']
              : 0;

          String PropertyName = myobject['Property Name'] != null
              ? myobject['Property Name'].toString()
              : "";

          String Prop_ID =
              myobject['Prop_ID'] != null ? myobject['Prop_ID'].toString() : "";

          bool Smoking =
              myobject['Smoking'] != null ? myobject['Smoking'] : false;

          bool Vehicle =
              myobject['Vehicle'] != null ? myobject['Vehicle'] : false;

          String Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          bool IsAgreedTerms =
              myobject['Note'] != null ? myobject['IsAgreedTerms'] : false;

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          int Owner_ID =
              myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;

          String Country_Code = myobject['Country_Code'] != null
              ? myobject['Country_Code'].toString()
              : "CA";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String ApplicantName = myobject['Applicant Name'] != null
              ? myobject['Applicant Name'].toString()
              : "";

          int EmploymentStatus = myobject['Employment Status'] != null
              ? myobject['Employment Status']
              : 0;

          String Email =
              myobject['Email'] != null ? myobject['Email'].toString() : "";

          int ApplicationReceived = myobject['Application Received'] != null
              ? myobject['Application Received']
              : 0;

          int Applicant_ID =
              myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;

          double Rating = myobject['Rating'] != null
              ? double.parse(myobject['Rating'].toString())
              : 0;

          String RatingReview = myobject['RatingReview'] != null
              ? myobject['RatingReview'].toString()
              : "";

          /*====================================================*/

          String ApplicationSentDate = myobject['ApplicationSentDate'] != null
              ? myobject['ApplicationSentDate'].toString()
              : "";

          String ApplicationReceivedDate =
              myobject['ApplicationReceivedDate'] != null
                  ? myobject['ApplicationReceivedDate'].toString()
                  : "";

          String DocRequestSentDate = myobject['DocRequestSentDate'] != null
              ? myobject['DocRequestSentDate'].toString()
              : "";

          String DocReceivedDate = myobject['DocReceivedDate'] != null
              ? myobject['DocReceivedDate'].toString()
              : "";

          String ReferenceRequestSentDate =
              myobject['ReferenceRequestSentDate'] != null
                  ? myobject['ReferenceRequestSentDate'].toString()
                  : "";

          String ReferenceRequestReceivedDate =
              myobject['ReferenceRequestReceivedDate'] != null
                  ? myobject['ReferenceRequestReceivedDate'].toString()
                  : "";

          String AgreementSentDate = myobject['AgreementSentDate'] != null
              ? myobject['AgreementSentDate'].toString()
              : "";

          String AgreementReceivedDate =
              myobject['AgreementReceivedDate'] != null
                  ? myobject['AgreementReceivedDate'].toString()
                  : "";

          /*=======================================================================*/

          SystemEnumDetails? ApplicationStatus =
              myobject['ApplicationStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['ApplicationStatus'])
                  : null;

          SystemEnumDetails? LeaseStatus = myobject['LeaseStatus'] != null
              ? SystemEnumDetails.fromJson(myobject['LeaseStatus'])
              : null;

          SystemEnumDetails? DocReviewStatus =
              myobject['DocReviewStatus'] != null
                  ? SystemEnumDetails.fromJson(myobject['DocReviewStatus'])
                  : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          TenancyApplication tenancyApplication = new TenancyApplication();
          tenancyApplication.id = ID;
          tenancyApplication.applicantId = Applicant_ID;
          tenancyApplication.personId = PersonID;
          tenancyApplication.applicantName = ApplicantName.toString();
          tenancyApplication.email = Email;
          tenancyApplication.mobileNumber = MobileNumber;
          tenancyApplication.dialCode = Dial_Code;
          tenancyApplication.countryCode = Country_Code;
          tenancyApplication.ownerId = Owner_ID;
          tenancyApplication.propId = Prop_ID;
          tenancyApplication.propertyName = PropertyName;
          tenancyApplication.rating = Rating;
          tenancyApplication.ratingReview = RatingReview;
          tenancyApplication.note = Note;
          tenancyApplication.applicationStatus = ApplicationStatus;
          tenancyApplication.leaseStatus = LeaseStatus;
          tenancyApplication.docReviewStatus = DocReviewStatus;
          tenancyApplication.ischeck = false;
          tenancyApplication.isexpand = false;
          tenancyApplication.applicationSentDate = ApplicationSentDate;
          tenancyApplication.applicationReceivedDate = ApplicationReceivedDate;
          tenancyApplication.agreementSentDate = AgreementSentDate;
          tenancyApplication.agreementReceivedDate = AgreementReceivedDate;
          tenancyApplication.docRequestSentDate = DocRequestSentDate;
          tenancyApplication.docReceivedDate = DocReceivedDate;
          tenancyApplication.referenceRequestSentDate =
              ReferenceRequestSentDate;
          tenancyApplication.referenceRequestReceivedDate =
              ReferenceRequestReceivedDate;
          tenancyApplication.CreatedOn = CreatedOn;
          tenancyApplication.UpdatedOn = UpdatedOn;
          tenancyApplication.questionnairesSentCount = QuestionnairesSentCount;
          tenancyApplication.questionnairesReceivedCount =
              QuestionnairesReceivedCount;
          tenancyApplication.referencesCount = ReferencesCount;
          tenancyApplication.isAuthorized = IsAuthorized;
          tenancyApplication.annualIncome = AnnualIncome;
          tenancyApplication.referenceStatus = ReferenceStatus;
          tenancyApplication.numberOfOccupants = NumberofOccupants;
          tenancyApplication.isArchived = IsArchived;
          tenancyApplication.isAgreedTerms = IsAgreedTerms;
          tenancyApplication.pets = Pets;
          tenancyApplication.smoking = Smoking;
          tenancyApplication.vehicle = Vehicle;
          tenancyApplication.city = City;
          tenancyApplication.employmentStatus = EmploymentStatus;
          tenancyApplication.applicationReceived = ApplicationReceived;

          tenancyleadlist.add(tenancyApplication);
        }

        tenancyleadlist.sort((a, b) =>
            b.CreatedOn!.toLowerCase().compareTo(a.CreatedOn!.toLowerCase()));

        _store.dispatch(UpdateArchiveleadList(tenancyleadlist));
        _store.dispatch(UpdateArchiveFilterArchiveleadlist(tenancyleadlist));
        _store.dispatch(UpdateArchiveisloding(false));
      } else {
        Helper.Log("respoce", respoce);
      }
    });
  }

/*==============================================================================*/
/*==============================  Archive list  ================================*/
/*==============================================================================*/

  updateTenancyStatusCount(BuildContext context) async {
    _store.dispatch(UpdateLandlordApplication_Lead_Count(0));
    _store.dispatch(UpdateLandlordApplications_count(0));
    _store.dispatch(UpdateLandlordApplication_verification_documents_count(0));
    _store.dispatch(UpdateLandlordApplication_references_check_count(0));
    _store.dispatch(UpdateLandlordApplication_leases_count(0));
    _store.dispatch(UpdateLandlordApplication_Active_Tenants_Count(0));

    await ApiManager()
        .getTenancyStatusCount(context, Prefs.getString(PrefsName.OwnerID));
  }

  updatePropertyStatusCount(BuildContext context) async {
    _store.dispatch(UpdatePropertyStatus_UnitsHeld(0));
    _store.dispatch(UpdatePropertyStatus_UnitsRented(0));
    _store.dispatch(UpdatePropertyStatus_VacantUnits(0));

    await ApiManager()
        .getPropertyStatusCount(context, Prefs.getString(PrefsName.OwnerID));
  }

  RemoveActiveTenant(BuildContext context, Object CPOJO1, Object UpPOJO1,
      Object CPOJO2, Object UpPOJO2, CallBackQuesy callBackQuesy) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    List<QueryObject> queryList = <QueryObject>[];

    String query1 = QueryFilter().UpdateQuery(
        CPOJO1,
        UpPOJO1,
        etableName.Property,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);
    var querydecode1 = jsonDecode(query1);
    QueryObject updatequery1 = QueryObject.fromJson(querydecode1);

    String query2 = QueryFilter().UpdateQuery(
        CPOJO2,
        UpPOJO2,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);
    var querydecode2 = jsonDecode(query2);
    QueryObject updatequery2 = QueryObject.fromJson(querydecode2);

    queryList.add(updatequery1);
    queryList.add(updatequery2);

    String json = jsonEncode(queryList);

    HttpClientCall().QueryAPICall(context, json, (error, respoce) async {
      if (error) {
        loader.remove();
        callBackQuesy(true, "");

        /* List data = jsonDecode(respoce) as List;

        bool issuccess = false;

        for (int i = 0; i < data.length; i++) {
          var myobject = data[i];

          String StatusCode = myobject['StatusCode'] != null
              ? myobject['StatusCode'].toString()
              : "";

          if (StatusCode.isEmpty || StatusCode != "200") {
            issuccess = true;
            loader.remove();
            callBackQuesy(false, "");
            break;
          }

          if ((data.length - 1) == i && !issuccess) {
            loader.remove();
            callBackQuesy(true, "");
          }
        }*/
      } else {
        loader.remove();
        callBackQuesy(false, respoce);
      }
    });
  }

  CheckTenantActiveOrNot(BuildContext context, String Prop_ID,
      String ApplicantID, CallBackQuesy callBackQuesy) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    CheckPropertyActiveTenant checkPropertyActiveTenant =
        new CheckPropertyActiveTenant();
    checkPropertyActiveTenant.ApplicationStatus =
        eApplicationStatus().ActiveTenent.toString();
    checkPropertyActiveTenant.Prop_ID = Prop_ID;

    ApiManager().CheckActiveTenant(context, checkPropertyActiveTenant,
        (status1, responce1) async {
      if (status1) {
        ApiManager().ActiveTenant(context, Prop_ID, ApplicantID,
            (status, responce) async {
          if (status) {
            loader.remove();
            callBackQuesy(true, "");
          } else {
            loader.remove();
            //ToastUtils.showCustomToast(context, GlobleString.Error1, false);
            callBackQuesy(false, GlobleString.Error1);
          }
        });
      } else {
        loader.remove();
        if (responce1 == "1") {
          //ToastUtils.showCustomToast(context, GlobleString.already_active_tenant, false);

          callBackQuesy(false, "1");
        } else {
          //ToastUtils.showCustomToast(context, GlobleString.DCR_No_reference, false);
          callBackQuesy(false, responce1);
        }
      }
    });
  }

  CheckActiveTenant(
      BuildContext context, Object POJO, CallBackQuesy callbackquery) async {
    String query = await QueryFilter().SelectQuery(POJO, etableName.Application,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, true);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        //var rest = data["Result"] as List;

        if (data['Result'].length > 0) {
          callbackquery(false, "1");
        } else {
          callbackquery(true, "");
        }
      } else {
        callbackquery(false, respoce);
      }
    });
  }

  ActiveTenant(BuildContext context, String PropID, String ApplicantID,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_ActiveTenant,
      "Reqtokens": {"Prop_ID": PropID, "Applicant_ID": ApplicantID}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        //var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*==============================================================================*/
/*========================  Tenancy Signup Flow Api  =============================*/
/*==============================================================================*/

/*Personal Info*/
  UpdateTFPersonalInfo(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Applicant,
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

/*Employement*/

  TFEmployementDelete(BuildContext context, Object EPOJO, Object OPOJO,
      CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    /*Occupation table*/
    String Occ_query = QueryFilter().DeleteQuery(OPOJO, etableName.Occupation,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);
    var Occ_querydecode = jsonDecode(Occ_query);
    QueryObject Occ_deletequery = QueryObject.fromJson(Occ_querydecode);
    query_list.add(Occ_deletequery);

    /*Employment table*/
    String Empquery = QueryFilter().DeleteQuery(EPOJO, etableName.Employment,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);
    var Emp_querydecode = jsonDecode(Empquery);
    QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);
    query_list.add(Emp_deletequery);

    String json = jsonEncode(query_list);

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

  TFEmployementOnly(
      BuildContext context, Object iPOJO, CallBackQuesy CallBackQuesy) {
    String json = QueryFilter().InsertQuery(iPOJO, etableName.Employment,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, Result);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  TFEmployementOccuapation(
      BuildContext context, List<Object> POJO, CallBackQuesy CallBackQuesy) {
    String json = QueryFilter().InsertQueryArray(POJO, etableName.Occupation,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

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
            CallBackQuesy(false, respoce);
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

/*Current Tenancy Info*/
  InsetTFCurrentTenancy(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().InsertQuery(POJO, etableName.CurrentTenancy,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
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

  UpdateTFCurrentTenancy(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.CurrentTenancy,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        loader.remove();
        CallBackQuesy(true, "");
      } else {
        loader.remove();
        CallBackQuesy(false, respoce);
      }
    });
  }

/*Additional OCcupant Info*/

  TFAdditionalOCcupantDelete(BuildContext context, List<Object> OccuPOJOlist,
      Object OPOJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    String Empquery = QueryFilter().DeleteQuery(
        OPOJO,
        etableName.AdditionalOccupants,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    var Emp_querydecode = jsonDecode(Empquery);
    QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);

    query_list.add(Emp_deletequery);

    for (int i = 0; i < OccuPOJOlist.length; i++) {
      String queryinsert = QueryFilter().DeleteQuery(
          OccuPOJOlist[i],
          etableName.Person,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      query_list.add(insetquery);
    }

    String json = jsonEncode(query_list);

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

  InsetTFAdditionalOCcupant(BuildContext context, List<Object> POJO,
      Object CPOJO, Object UPOJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    for (int i = 0; i < POJO.length; i++) {
      String queryinsert = QueryFilter().InsertQuery(
          POJO[i],
          etableName.AdditionalOccupants,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      query_list.add(insetquery);
    }

    String Empquery = QueryFilter().UpdateQuery(
        CPOJO,
        UPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    var Emp_querydecode = jsonDecode(Empquery);
    QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);

    query_list.add(Emp_deletequery);

    String json = jsonEncode(query_list);

    HttpClientCall().QueryAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        //String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, "");
      } else {
        CallBackQuesy(false, "");
      }
    });
  }

/*Additional Info */

  TFAdditionalInfoDelete(BuildContext context, Object petPOJO,
      Object vehicalPOJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    String petquery = QueryFilter().DeleteQuery(petPOJO, etableName.PetInfo,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    var pet_querydecode = jsonDecode(petquery);
    QueryObject pet_deletequery = QueryObject.fromJson(pet_querydecode);

    String vehiquery = QueryFilter().DeleteQuery(
        vehicalPOJO,
        etableName.VehicleInfo,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    var vehi_querydecode = jsonDecode(vehiquery);
    QueryObject vehi_deletequery = QueryObject.fromJson(vehi_querydecode);

    query_list.add(pet_deletequery);
    query_list.add(vehi_deletequery);

    String json = jsonEncode(query_list);

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

  InsetTFAdditionalInfo(
      BuildContext context,
      List<Object> PetPOJO,
      List<Object> VehiPOJO,
      Object CPOJO,
      Object UPOJO,
      CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    if (PetPOJO.length > 0) {
      for (int i = 0; i < PetPOJO.length; i++) {
        String queryinsert = QueryFilter().InsertQuery(
            PetPOJO[i],
            etableName.PetInfo,
            eConjuctionClause().AND,
            eRelationalOperator().EqualTo);

        var queryinsetdecode = jsonDecode(queryinsert);
        QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
        query_list.add(insetquery);
      }
    }
    if (VehiPOJO.length > 0) {
      for (int j = 0; j < VehiPOJO.length; j++) {
        String queryinsert = QueryFilter().InsertQuery(
            VehiPOJO[j],
            etableName.VehicleInfo,
            eConjuctionClause().AND,
            eRelationalOperator().EqualTo);

        var queryinsetdecode = jsonDecode(queryinsert);
        QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
        query_list.add(insetquery);
      }
    }

    String Empquery = QueryFilter().UpdateQuery(
        CPOJO,
        UPOJO,
        etableName.Applicant,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    var Emp_querydecode = jsonDecode(Empquery);
    QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);

    query_list.add(Emp_deletequery);

    String json = jsonEncode(query_list);

    HttpClientCall().QueryAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        //String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, "");
      } else {
        Helper.Log("respoce", respoce);
        CallBackQuesy(false, "");
      }
    });
  }

/*Additional Reference Info*/
  TFAdditionalReferenceDelete(BuildContext context, List<Object> OccuPOJOlist,
      Object deleteAddreference, CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    List<int> relational = [
      eRelationalOperator().EqualTo,
      eRelationalOperator().ISNULL,
      eRelationalOperator().ISNULL
    ];

    String Empquery = QueryFilter().DeleteQueryFilterArray(
      deleteAddreference,
      etableName.AdditionalReferences,
      eConjuctionClause().AND,
      relational,
    );

    var Emp_querydecode = jsonDecode(Empquery);
    QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);

    query_list.add(Emp_deletequery);

    for (int i = 0; i < OccuPOJOlist.length; i++) {
      String queryinsert = QueryFilter().DeleteQuery(
          OccuPOJOlist[i],
          etableName.Person,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      query_list.add(insetquery);
    }

    String json = jsonEncode(query_list);

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

  InsetTFAdditionalReference(BuildContext context, List<Object> POJO,
      Object CPOJO, Object UPOJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> query_list = <QueryObject>[];

    for (int i = 0; i < POJO.length; i++) {
      String queryinsert = QueryFilter().InsertQuery(
          POJO[i],
          etableName.AdditionalReferences,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      query_list.add(insetquery);
    }

    String Empquery = QueryFilter().UpdateQuery(
        CPOJO,
        UPOJO,
        etableName.Application,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    var Emp_querydecode = jsonDecode(Empquery);
    QueryObject Emp_deletequery = QueryObject.fromJson(Emp_querydecode);

    query_list.add(Emp_deletequery);

    String json = jsonEncode(query_list);

    HttpClientCall().QueryAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        //String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, "");
      } else {
        Helper.Log("respoce", respoce);
        CallBackQuesy(false, "");
      }
    });
  }

  getCurrentLandLordIDinTenancy(
      BuildContext context, Object POJO, CallBackQuesy callBackQuesy) {
    String query = QueryFilter().SelectQuery(POJO, etableName.CurrentTenancy,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          int ID = myobject['ID'] != null ? myobject['ID'] : 0;

          String CurrentLandLord = myobject['CurrentLandLord'] != null
              ? myobject['CurrentLandLord'].toString()
              : "";

          callBackQuesy(true, CurrentLandLord);
        }
      } else {
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

  InsertCurrentLandLordAsReference(
      BuildContext context, Object POJO, CallBackQuesy callBackQuesy) {
    String query = QueryFilter().InsertQuery(
        POJO,
        etableName.AdditionalReferences,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        callBackQuesy(true, Result);
      } else {
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

  CheckReferenceCurrentLandLord(
      BuildContext context, Object POJO, CallBackQuesy callBackQuesy) {
    String query = QueryFilter().SelectQuery(
        POJO,
        etableName.AdditionalReferences,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo,
        false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            int ID = myobject['ID'] != null ? myobject['ID'] : 0;

            String ReferenceID = myobject['ReferenceID'] != null
                ? myobject['ReferenceID'].toString()
                : "";

            callBackQuesy(true, ReferenceID);
          }
        } else {
          callBackQuesy(false, "");
        }
      } else {
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

  DeleteReferenceCurrentLandLord(
      BuildContext context, Object POJO, CallBackQuesy callBackQuesy) {
    String query = QueryFilter().DeleteQuery(
        POJO,
        etableName.AdditionalReferences,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().deleteAPICall(context, query, (error, respoce) async {
      if (error) {
        callBackQuesy(true, respoce);
      } else {
        Helper.Log("respoce", respoce);
        callBackQuesy(false, "");
      }
    });
  }

/*==============================================================================*/
/*========================  Forgot / Reset Passowrd  =============================*/
/*==============================================================================*/

  checkEmailalreadyExit(BuildContext context, Object CPOJO,
      CallBackUserInfo CallBackQuesy) async {
    String query = await QueryFilter().SelectQuery(CPOJO, etableName.Users,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        UserInfo? userInfo = null;

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String Roles =
              myobject['Roles'] != null ? myobject['Roles'].toString() : "";

          int ID = myobject['ID'] != null ? myobject['ID'] : "";

          String UserID =
              myobject['UserID'] != null ? myobject['UserID'].toString() : "";

          String UserName = myobject['UserName'] != null
              ? myobject['UserName'].toString()
              : "";

          int PersonID =
              myobject['PersonID'] != null ? myobject['PersonID'] : 0;

          userInfo = new UserInfo(
              id: ID,
              personId: PersonID,
              roles: Roles,
              userId: UserID,
              userName: UserName);
        }

        CallBackQuesy(true, userInfo);
      } else {
        Helper.Log("respoce", respoce);
        CallBackQuesy(false, null);
      }
    });
  }

  ResetPasswordAPI(BuildContext context, String email, String password,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "Email": email,
      "CurrentPassword": "",
      "NewPassword": password,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().ChangePassword(context, json, (error, respoce) async {
      if (error) {
        var responce = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

/*==============================================================================*/
/*========================  Filter Property Data  =============================*/
/*==============================================================================*/

  getActivePropertyData(BuildContext context, Object POJO,
      CallBackFilterProperty CallBackQuesy) async {
    String query = await QueryFilter().SelectQuery(POJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        List<FilterPropertyItem> propertylist = <FilterPropertyItem>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

          String PropertyName = myobject['PropertyName'] != null
              ? myobject['PropertyName'].toString()
              : "";

          FilterPropertyItem filterPropertyItem = new FilterPropertyItem();
          filterPropertyItem.propertyId = ID;
          filterPropertyItem.propertyName = PropertyName;
          filterPropertyItem.isSelected = false;
          propertylist.add(filterPropertyItem);
        }

        CallBackQuesy(true, "", propertylist);
      } else {
        CallBackQuesy(false, respoce, []);
      }
    });
  }

  getCityinProperty(BuildContext context, Object POJO,
      CallBackFilterCity CallBackQuesy) async {
    String query = await QueryFilter().SelectQuery(POJO, etableName.Property,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        List<FilterCityItem> citylist = <FilterCityItem>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          FilterCityItem filterCityItem = new FilterCityItem();
          filterCityItem.cityName = City;
          filterCityItem.isSelected = false;
          citylist.add(filterCityItem);
        }

        final jsonList = citylist.map((item) => jsonEncode(item)).toList();

        // using toSet - toList strategy
        final uniqueJsonList = jsonList.toSet().toList();

        // convert each item back to the original form using JSON decoding
        final resultdata =
            uniqueJsonList.map((item) => jsonDecode(item)).toList();

        List<FilterCityItem> listDistinct = uniqueJsonList
            .map((item) => FilterCityItem.fromJson(jsonDecode(item)))
            .toList();

        CallBackQuesy(true, "", listDistinct);
      } else {
        CallBackQuesy(false, respoce, []);
      }
    });
  }

/*==============================================================================*/
/*========================  WorkFlow Execute Api  =============================*/
/*==============================================================================*/

/*Duplicat Property*/
  DuplicatPropertyGenerate(BuildContext context, String propertyid,
      CallBackQuesy callBackQuesy) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_DuplicatProperty,
      "Reqtokens": {"ID": propertyid}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        loader.remove();
        callBackQuesy(true, respoce);
      } else {
        loader.remove();
        callBackQuesy(false, respoce);
      }
    });
  }

  Emailworkflow(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String json = jsonEncode(POJO);

    Helper.Log("Emailworkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        CallBackQuesy(true, respoce);
        loader.remove();
      } else {
        loader.remove();
        CallBackQuesy(false, respoce);
      }
    });
  }

  ResetPassWordAPIworkflow(
      BuildContext context, String userid, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_ResetPassWordMain,
      "Reqtokens": {
        "UserID": userid,
        "HostURL": Weburl.Email_URL,
        "DbAppCode": Weburl.API_CODE,
      }
    };

    String json = jsonEncode(myjson);

    Helper.Log("welcomeMailWorkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*Archive lead in Property*/
  ArchiveLeadInProperty(BuildContext context, String propertyid,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Property_Archive,
      "Reqtokens": {"Prop_ID": propertyid}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*Archive lead restore in Property*/
  ArchiveLeadRestoreInProperty(BuildContext context, String propertyid,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Property_Archive_Restore,
      "Reqtokens": {"Prop_ID": propertyid}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*All Archive*/
  AllArchivePropertyWise(BuildContext context, String propertyid,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_All_Archive_Property,
      "Reqtokens": {"Prop_ID": propertyid}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*Restore All Archive*/
  AllArchiveRestore(
      BuildContext context, String OwnerID, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_RestoreAllArchive,
      "Reqtokens": {"Owner_ID": OwnerID}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*==============================================================================*/
/*========================  Notification Execute Api  =============================*/
/*==============================================================================*/

  NotificationAppReceive(BuildContext context, String applicationID,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Notifi_Application,
      "Reqtokens": {
        "ID": applicationID,
        "ReceivedDate": new DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now())
            .toString()
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        //var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  NotificationDocReceive(BuildContext context, String applicationID,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Notifi_Document,
      "Reqtokens": {
        "ID": applicationID,
        "ReceivedDate": new DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now())
            .toString()
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        //var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  NotificationReferenceReceive(BuildContext context, String applicationid,
      String referenceid, String date, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Notifi_Reference,
      "Reqtokens": {
        "ID": applicationid,
        "ReceivedDate": date,
        "ReferenceID": referenceid,
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  NotificationLeaseReceive(BuildContext context, String applicationID,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_Notifi_lease,
      "Reqtokens": {
        "ID": applicationID,
        "ReceivedDate": new DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(DateTime.now())
            .toString()
      }
    };

    String json = jsonEncode(myjson);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        //var data = jsonDecode(respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  getNotificationList(BuildContext context, String id, int pageno,
      CallBackNotificationQuery callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_Notification,
      "LoadLookUpValues": true,
      "Pager": {"PageNo": pageno, "NoOfRecords": 10},
      "Reqtokens": {"Owner_ID": id, "TypeOfNotification": "1,2,3,4,5,7,8"},
      /*"Sort": [
        {"FieldID": "IsRead", "SortSequence": 1}
      ]*/
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        List<NotificationData> notificationlist = <NotificationData>[];

        if (data['Result'].length > 0) {
          /* notificationlist = (data['Result'] as List)
              .map((p) => NotificationData.fromJson(p))
              .toList();*/

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            NotificationData notification = new NotificationData();

            notification.id = myobject['ID'] != null ? myobject['ID'] : 0;
            notification.applicantName = myobject['ApplicantName'] != null
                ? myobject['ApplicantName'].toString()
                : "";
            notification.ownerId =
                myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;
            notification.applicantId =
                myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;
            notification.notificationDate = myobject['NotificationDate'] != null
                ? myobject['NotificationDate'].toString()
                : "";
            notification.isRead =
                myobject['IsRead'] != null ? myobject['IsRead'] : false;
            notification.typeOfNotification =
                myobject['TypeOfNotification'] != null
                    ? myobject['TypeOfNotification']
                    : 0;
            notification.MaintenanceID = myobject['MaintenanceID'] != null
                ? myobject['MaintenanceID']
                : 0;
            notification.applicationId = myobject['Application_ID'] != null
                ? myobject['Application_ID']
                : 0;

            if (myobject['Prop_ID'] != null) {
              var Prop_IDobject = myobject['Prop_ID'];

              notification.PropID = Prop_IDobject['ID'] != null
                  ? Prop_IDobject['ID'].toString()
                  : "";
              notification.propertyName = Prop_IDobject['PropertyName'] != null
                  ? Prop_IDobject['PropertyName'].toString()
                  : "";
              notification.suiteUnit = Prop_IDobject['Suite_Unit'] != null
                  ? Prop_IDobject['Suite_Unit'].toString()
                  : "";
            }
            notificationlist.add(notification);
          }
        }
        //loader.remove();
        callBackQuesy(true, notificationlist, "");
      } else {
        //loader.remove();
        callBackQuesy(false, <NotificationData>[], respoce);
      }
    });
  }

  NotificationCount(BuildContext context) {
    var myjson = {
      "DSQID": Weburl.DSQ_Notification,
      "LoadLookUpValues": true,
      "Reqtokens": {
        "TypeOfNotification": "1,2,3,4,5,7,8",
        "Owner_ID": Prefs.getString(PrefsName.OwnerID),
        "IsRead": false
      },
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        int TotalRecords =
            data['TotalRecords'] != null ? data['TotalRecords'] : 0;
        _store.dispatch(UpdateNotificationCount(TotalRecords));
      } else {
        _store.dispatch(UpdateNotificationCount(0));
      }
    });
  }

  UpdateNotificationRead(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Notification,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        callBackQuesy(true, Result);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

/*==========================================================================*/
/*=============================== Customer =================================*/
/*==========================================================================*/

  Customer_bindPropertyData(PropertyData propertyData) {
    /*Summery*/

    _store.dispatch(UpdateCPDPropID(propertyData.ID!));
    _store.dispatch(UpdateCPDProperTytypeValue(propertyData.propertyType));
    _store.dispatch(
        UpdateCPDPropertyTypeOtherValue(propertyData.otherPropertyType!));
    _store.dispatch(UpdateCPDDateofavailable(propertyData.dateAvailable!));
    _store.dispatch(UpdateCPDRentalSpaceValue(propertyData.rentalSpace));
    _store.dispatch(UpdateCPDPropertyName(propertyData.propertyName!));
    _store.dispatch(UpdateCPDPropertyAddress(propertyData.propertyAddress!));
    _store.dispatch(
        UpdateCPDPropertyDescription(propertyData.propertyDescription!));
    _store.dispatch(UpdateCPDSuiteunit(propertyData.suiteUnit!));
    _store.dispatch(UpdateCPDBuildingname(propertyData.buildingName!));
    _store.dispatch(UpdateCPDPropertyCity(propertyData.city!));
    _store.dispatch(UpdateCPDPropertyCountryCode(propertyData.countryCode!));
    _store.dispatch(UpdateCPDPropertyCountryName(propertyData.country!));
    _store.dispatch(UpdateCPDPropertyProvince(propertyData.province!));
    _store.dispatch(UpdateCPDPropertyPostalcode(propertyData.postalCode!));
    _store.dispatch(UpdateCPDPropertyRentAmount(propertyData.rentAmount!));
    _store.dispatch(
        UpdateCPDRentPaymentFrequencyValue(propertyData.rentPaymentFrequency));
    _store.dispatch(UpdateCPDLeaseTypeValue(propertyData.leaseType));
    _store.dispatch(
        UpdateCPDMinimumLeasedurationValue(propertyData.minLeaseDuration));
    _store.dispatch(UpdateCPDMinimumleasedurationNumber(
        propertyData.minLeaseNumber.toString()));
    _store.dispatch(UpdateCPDPropertyImage(propertyData.propertyImage));
    _store.dispatch(UpdateCPDPropertyUint8List(null));
    _store
        .dispatch(UpdateCPDPropertyBedrooms(propertyData.bedrooms.toString()));
    _store.dispatch(
        UpdateCPDPropertyBathrooms(propertyData.bathrooms.toString()));
    _store.dispatch(
        UpdateCPDPropertySizeinsquarefeet(propertyData.size.toString()));
    _store.dispatch(UpdateCPDPropertyMaxoccupancy(propertyData.maxOccupancy!));
    _store.dispatch(UpdateCPDFurnishingValue(propertyData.furnishing));
    _store.dispatch(UpdateCPDOtherPartialFurniture(
        propertyData.otherPartialFurniture.toString()));
    _store.dispatch(UpdateCPDParkingstalls(propertyData.parkingStalls!));
    _store.dispatch(
        UpdateCPDStorageAvailableValue(propertyData.storageAvailable));
    _store.dispatch(UpdateCPDAgreeTCPP(propertyData.isAgreedTandC!));
    _store.dispatch(UpdateCPDPropertyDrafting(propertyData.PropDrafting!));
    _store.dispatch(UpdateCPDPropertyVacancy(propertyData.Vacancy!));

    _store.dispatch(UpdateCPDLead_firstname(""));
    _store.dispatch(UpdateCPDLead_lastname(""));
    _store.dispatch(UpdateCPDLead_email(""));
    _store.dispatch(UpdateCPDLead_phone(""));
    _store.dispatch(UpdateCPDLead_occupant("0"));
    _store.dispatch(UpdateCPDLead_children("0"));
    _store.dispatch(UpdateCPDLead_additionalInfo(""));
  }

  userDetailsDSQCall(BuildContext context, String CustomerFeatureListingURL,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_UserLogin.toString(),
      "LoadLookupValues": true,
      "Reqtokens": {"CustomerFeatureListingURL": CustomerFeatureListingURL}
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("userLoginDSQCall", respoce);

        var data = jsonDecode(respoce);
        //var rest = data["Result"] as List;
        if (data["Result"].length > 0) {
          var myobject = data["Result"][0];

          bool IsActive =
              myobject["IsActive"] != null ? myobject["IsActive"] : false;

          bool adminsideIsActive = myobject["AdminsideIsActive"] != null
              ? myobject["AdminsideIsActive"]
              : false;

          if (IsActive) {
            if (adminsideIsActive) {
              var ID = myobject["ID"].toString();

              await Prefs.setString(PrefsName.Customer_OwnerID, ID);

              String CompanyName = myobject['CompanyName'] != null
                  ? myobject['CompanyName'].toString()
                  : "";

              String HomePageLink = myobject['HomePageLink'] != null
                  ? myobject['HomePageLink'].toString()
                  : "";

              String UserName = myobject['UserName'] != null
                  ? myobject['UserName'].toString()
                  : "";

              MediaInfo? Company_logo = myobject['Company_logo'] != null
                  ? MediaInfo.fromJson(myobject['Company_logo'])
                  : null;

              _store.dispatch(UpdateCustomerPortal_landlordemail(UserName));
              _store.dispatch(UpdateCustomerPortal_Companyname(CompanyName));
              _store.dispatch(UpdateCustomerPortal_Homepagelink(HomePageLink));
              _store
                  .dispatch(UpdateCustomerPortal_Companynamelogo(Company_logo));

              CallBackQuesy(true, ID);
            } else {
              CallBackQuesy(false, "2");
            }
          } else {
            CallBackQuesy(false, "1");
          }
        } else {
          CallBackQuesy(false, "3");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  getFeatuePropertyList(
      BuildContext context, String Ownerid, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_Featue_propertylist,
      "LoadLookupValues": true,
      "LoadRecordInfo": true,
      "Reqtokens": {"Owner_ID": Ownerid, "IsPublished": 1}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("getFeatuePropertyList", respoce);
        //loader.remove();
        var data = jsonDecode(respoce);

        List<PropertyData> propertylist = <PropertyData>[];

        if (data['Result'].length > 0) {
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
                : "0";

            int Min_Lease_Number = myobject['Min_Lease_Number'] != null
                ? myobject['Min_Lease_Number']
                : "";

            String Parking_Stalls = myobject['Parking_Stalls'] != null
                ? myobject['Parking_Stalls'].toString()
                : "";

            String Country = myobject['Country'] != null
                ? myobject['Country'].toString()
                : "";

            int Bedrooms =
                myobject['Bedrooms'] != null ? myobject['Bedrooms'] : 0;

            String Suite_Unit = myobject['Suite_Unit'] != null
                ? myobject['Suite_Unit'].toString()
                : "";

            String Province = myobject['Province'] != null
                ? myobject['Province'].toString()
                : "";

            String Property_Description =
                myobject['Property_Description'] != null
                    ? myobject['Property_Description'].toString()
                    : "";

            int Bathrooms =
                myobject['Bathrooms'] != null ? myobject['Bathrooms'] : 0;

            int PropDrafting =
                myobject['PropDrafting'] != null ? myobject['PropDrafting'] : 0;

            bool Vacancy =
                myobject['Vacancy'] != null ? myobject['Vacancy'] : false;

            String Media_ID = myobject['Media_ID'] != null
                ? myobject['Media_ID'].toString()
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
            propertyData.Media_ID = Media_ID;
            // propertyData.PropertyImageMediaInfolist = PropertyImageMediaInfolist;

            propertylist.add(propertyData);

            /*Owner Data*/

            if (i == 0) {
              var OwnerIDData = myobject["Owner_ID"];

              String CompanyName = OwnerIDData['CompanyName'] != null
                  ? OwnerIDData['CompanyName'].toString()
                  : "";

              String HomePageLink = OwnerIDData['HomePageLink'] != null
                  ? OwnerIDData['HomePageLink'].toString()
                  : "";

              String UserName = myobject['UserName'] != null
                  ? myobject['UserName'].toString()
                  : "";

              MediaInfo? Company_logo = OwnerIDData['Company_logo'] != null
                  ? MediaInfo.fromJson(OwnerIDData['Company_logo'])
                  : null;

              _store.dispatch(UpdateCustomerPortal_landlordemail(UserName));
              _store.dispatch(UpdateCustomerPortal_Companyname(CompanyName));
              _store.dispatch(UpdateCustomerPortal_Homepagelink(HomePageLink));
              _store
                  .dispatch(UpdateCustomerPortal_Companynamelogo(Company_logo));
            }
          }

          /* propertylist.sort((a, b) =>
            b.createdOn!.toLowerCase().compareTo(a.createdOn!.toLowerCase()));*/

          _store.dispatch(UpdateCustomer_propertylist(propertylist));
          callBackQuesy(true, "");
        } else {
          _store.dispatch(UpdateCustomer_propertylist(propertylist));
          callBackQuesy(false, "1");
        }
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        callBackQuesy(false, respoce);
      }
    });
  }

  insetCustomerLead(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQuery(POJO, etableName.Application,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, "");
      } else {
        Helper.Log("respoce", respoce);
        CallBackQuesy(false, "");
      }
    });
  }

  checkEmailAddressCustomer(BuildContext context, String Propertyid,
      String Email, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_TenantEmail_already_Property,
      "LoadLookupValues": true,
      "Reqtokens": {"Prop_ID": Propertyid, "Email": Email}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);
        if (data['Result'].length > 0) {
          callBackQuesy(false, "1");
        } else {
          callBackQuesy(true, "1");
        }
      } else {
        ToastUtils.showCustomToast(context, respoce, false);
        callBackQuesy(false, respoce);
      }
    });
  }

/*==========================================================================*/
/*======================== Landlord Mainatenace Module =====================*/
/*==========================================================================*/

  getMaintenaceCount(BuildContext context, CallBackQuesy callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    _store.dispatch(UpdateLLMaintenance_status_New(0));
    _store.dispatch(UpdateLLMaintenance_status_Approved(0));
    _store.dispatch(UpdateLLMaintenance_status_WorkinProgress(0));
    _store.dispatch(UpdateLLMaintenance_status_Resolved(0));
    _store.dispatch(UpdateLLMaintenance_status_Paid(0));

    var myjson = {
      "DSQID": Weburl.DSQ_landlord_Maintenance_Count,
      "Reqtokens": {
        "Owner_ID": Prefs.getString(PrefsName.OwnerID),
      },
      "LoadLookUpValues": false,
    };

    String json = jsonEncode(myjson);

    Helper.Log("getMaintenaceCount", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("getMaintenaceCount Responce", respoce);
        //loader.remove();
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          int news = 0,
              approv = 0,
              workprogress = 0,
              resolve = 0,
              paid = 0,
              cancle = 0;

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            String DisplayValue = myobject['DisplayValue'] != null
                ? myobject['DisplayValue'].toString()
                : "";

            int EnumDetailId =
                myobject['EnumDetailId'] != null ? myobject['EnumDetailId'] : 0;

            int MaintenenceRequestCount =
                myobject['MaintenenceRequestCount'] != null
                    ? myobject['MaintenenceRequestCount']
                    : 0;

            if (EnumDetailId == 1) {
              news = MaintenenceRequestCount;
            } else if (EnumDetailId == 2) {
              approv = MaintenenceRequestCount;
            } else if (EnumDetailId == 3) {
              workprogress = MaintenenceRequestCount;
            } else if (EnumDetailId == 4) {
              resolve = MaintenenceRequestCount;
            } else if (EnumDetailId == 5) {
              paid = MaintenenceRequestCount;
            } else if (EnumDetailId == 6) {
              cancle = MaintenenceRequestCount;
            }
          }

          _store.dispatch(UpdateLLMaintenance_status_New(news));
          _store.dispatch(UpdateLLMaintenance_status_Approved(approv));
          _store.dispatch(
              UpdateLLMaintenance_status_WorkinProgress(workprogress));
          _store.dispatch(UpdateLLMaintenance_status_Resolved(resolve));
          _store.dispatch(UpdateLLMaintenance_status_Paid(paid));
        }

        callback(true, "");
      } else {
        _store.dispatch(UpdateMER_logActivitylist([]));
        callback(false, "");
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getMaintenaceList(BuildContext context, String json, int ftime) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    Helper.Log("getMaintenaceList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<MaintenanceData> maintenanceDatalist = <MaintenanceData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          MaintenanceData maintenanceData = new MaintenanceData();

          maintenanceData.ID =
              myobject['ID'] != null ? myobject['ID'].toString() : "";

          maintenanceData.RequestName = myobject['RequestName'] != null
              ? myobject['RequestName'].toString()
              : "";
          maintenanceData.Date_Created = myobject['Date_Created'] != null
              ? myobject['Date_Created'].toString()
              : "";

          maintenanceData.CreatedBy = myobject['CreatedBy'] != null
              ? myobject['CreatedBy'].toString()
              : "";
          maintenanceData.IsLock =
              myobject['IsLock'] != null ? myobject['IsLock'] : false;
          maintenanceData.Describe_Issue = myobject['Describe_Issue'] != null
              ? myobject['Describe_Issue'].toString()
              : "";
          maintenanceData.Type_User = myobject['Type_User'] != null
              ? myobject['Type_User'].toString()
              : "1";

          if (myobject['Owner_ID'] != null) {
            var Owner_IDobj = myobject['Owner_ID'];

            var OPersonID = Owner_IDobj['PersonID'];

            maintenanceData.Owner_ID =
                Owner_IDobj['ID'] != null ? Owner_IDobj['ID'].toString() : "";
            String FirstName = OPersonID['FirstName'] != null
                ? OPersonID['FirstName'].toString()
                : "";
            String LastName = OPersonID['LastName'] != null
                ? OPersonID['LastName'].toString()
                : "";

            maintenanceData.OwnerName = FirstName + " " + LastName;
          }

          if (myobject['Applicant_ID'] != null) {
            var Applicant_IDobj = myobject['Applicant_ID'];

            var APersonID = Applicant_IDobj['Person_ID'];

            maintenanceData.Applicant_ID = Applicant_IDobj['ID'] != null
                ? Applicant_IDobj['ID'].toString()
                : "";
            String FirstName = APersonID['FirstName'] != null
                ? APersonID['FirstName'].toString()
                : "";
            String LastName = APersonID['LastName'] != null
                ? APersonID['LastName'].toString()
                : "";

            maintenanceData.ApplicantName = FirstName + " " + LastName;
          }

          if (myobject['Prop_ID'] != null) {
            var Prop_IDobj = myobject['Prop_ID'];

            maintenanceData.Prop_ID =
                Prop_IDobj['ID'] != null ? Prop_IDobj['ID'].toString() : "";
            maintenanceData.PropertyName = Prop_IDobj['PropertyName'] != null
                ? Prop_IDobj['PropertyName'].toString()
                : "";
          }

          maintenanceData.Category = myobject['Category'] != null
              ? SystemEnumDetails.fromJson(myobject['Category'])
              : null;

          maintenanceData.Status = myobject['Status'] != null
              ? SystemEnumDetails.fromJson(myobject['Status'])
              : null;

          maintenanceData.Priority = myobject['Priority'] != null
              ? SystemEnumDetails.fromJson(myobject['Priority'])
              : null;

          maintenanceDatalist.add(maintenanceData);
        }

        /* propertylist.sort((a, b) =>
            b.createdOn!.toLowerCase().compareTo(a.createdOn!.toLowerCase()));*/

        if (ftime == 0) {
          if (maintenanceDatalist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateLLMaintenance_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdateLLMaintenance_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdateLLMaintenance_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateLLMaintenance_totalpage(1));
          }
          _store.dispatch(UpdateLLMaintenance_pageNo(1));
        }

        _store.dispatch(UpdateLLMaintenance_isloding(false));
        _store.dispatch(UpdateLL_maintenancedatalist(maintenanceDatalist));
      } else {
        _store.dispatch(UpdateLLMaintenance_totalpage(0));
        _store.dispatch(UpdateLLMaintenance_totalRecord(0));
        _store.dispatch(UpdateLLMaintenance_pageNo(1));

        _store.dispatch(UpdateLLMaintenance_isloding(false));
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getAllMaintenaceListExportCSV(BuildContext context, String json) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    /* var myjson = {
      "DSQID": "08EC96E2-F319-463C-A0FB-9E44202CCC44",
      "Reqtokens": {"Owner_ID": ownerid, "Name": ""},
      "LoadLookUpValues": true,
      "LoadRecordInfo": false,
      "Sort": [
        {"FieldID": "ID", "SortSequence": 1}
      ]
    };*/

    // String json = jsonEncode(myjson);

    Helper.Log("getMaintenaceList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          String csv;
          List<List<dynamic>> csvList = [];

          List csvHeaderTitle = [];
          csvHeaderTitle.add("ID");
          csvHeaderTitle.add(GlobleString.LMR_Property_Name);
          csvHeaderTitle.add(GlobleString.LMR_RequestName);
          csvHeaderTitle.add(GlobleString.LMR_Category);
          csvHeaderTitle.add(GlobleString.LMR_Priority);
          csvHeaderTitle.add(GlobleString.LMR_DateCreated);
          csvHeaderTitle.add(GlobleString.LMR_CreatedBy);
          csvHeaderTitle.add(GlobleString.LMR_Status);
          csvHeaderTitle.add(GlobleString.LMR_Lock);

          csvList.add(csvHeaderTitle);

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            MaintenanceData maintenanceData = new MaintenanceData();

            maintenanceData.ID =
                myobject['ID'] != null ? myobject['ID'].toString() : "";

            maintenanceData.RequestName = myobject['RequestName'] != null
                ? myobject['RequestName'].toString()
                : "";
            maintenanceData.Date_Created = myobject['Date_Created'] != null
                ? myobject['Date_Created'].toString()
                : "";

            maintenanceData.CreatedBy = myobject['CreatedBy'] != null
                ? myobject['CreatedBy'].toString()
                : "";

            maintenanceData.IsLock =
                myobject['IsLock'] != null ? myobject['IsLock'] : false;
            maintenanceData.Describe_Issue = myobject['Describe_Issue'] != null
                ? myobject['Describe_Issue'].toString()
                : "";
            maintenanceData.Type_User = myobject['Type_User'] != null
                ? myobject['Type_User'].toString()
                : "1";

            if (myobject['Owner_ID'] != null) {
              var Owner_IDobj = myobject['Owner_ID'];

              var OPersonID = Owner_IDobj['PersonID'];

              maintenanceData.Owner_ID =
                  Owner_IDobj['ID'] != null ? Owner_IDobj['ID'].toString() : "";
              String FirstName = OPersonID['FirstName'] != null
                  ? OPersonID['FirstName'].toString()
                  : "";
              String LastName = OPersonID['LastName'] != null
                  ? OPersonID['LastName'].toString()
                  : "";

              maintenanceData.OwnerName = FirstName + " " + LastName;
            }

            if (myobject['Applicant_ID'] != null) {
              var Applicant_IDobj = myobject['Applicant_ID'];

              var APersonID = Applicant_IDobj['Person_ID'];

              maintenanceData.Applicant_ID = Applicant_IDobj['ID'] != null
                  ? Applicant_IDobj['ID'].toString()
                  : "";
              String FirstName = APersonID['FirstName'] != null
                  ? APersonID['FirstName'].toString()
                  : "";
              String LastName = APersonID['LastName'] != null
                  ? APersonID['LastName'].toString()
                  : "";

              maintenanceData.ApplicantName = FirstName + " " + LastName;
            }

            if (myobject['Prop_ID'] != null) {
              var Prop_IDobj = myobject['Prop_ID'];

              maintenanceData.Prop_ID =
                  Prop_IDobj['ID'] != null ? Prop_IDobj['ID'].toString() : "";
              maintenanceData.PropertyName = Prop_IDobj['PropertyName'] != null
                  ? Prop_IDobj['PropertyName'].toString()
                  : "";
            }

            maintenanceData.Category = myobject['Category'] != null
                ? SystemEnumDetails.fromJson(myobject['Category'])
                : null;

            maintenanceData.Status = myobject['Status'] != null
                ? SystemEnumDetails.fromJson(myobject['Status'])
                : null;

            maintenanceData.Priority = myobject['Priority'] != null
                ? SystemEnumDetails.fromJson(myobject['Priority'])
                : null;

            List row = [];

            row.add(maintenanceData.ID);
            row.add(maintenanceData.PropertyName);
            row.add(maintenanceData.RequestName);
            row.add(maintenanceData.Category != null
                ? maintenanceData.Category!.displayValue
                : "");
            row.add(maintenanceData.Priority != null
                ? maintenanceData.Priority!.displayValue
                : "");
            row.add(maintenanceData.Date_Created != null &&
                    maintenanceData.Date_Created != "0" &&
                    maintenanceData.Date_Created != ""
                ? new DateFormat("dd-MMM-yyyy")
                    .format(DateTime.parse(maintenanceData.Date_Created!))
                    .toString()
                : "");
            row.add(maintenanceData.CreatedBy);
            row.add(maintenanceData.Status != null
                ? maintenanceData.Status!.displayValue
                : "");
            row.add(maintenanceData.IsLock != null
                ? maintenanceData.IsLock
                : false);

            csvList.add(row);
          }

          csv = const ListToCsvConverter().convert(csvList);

          String filename = "Maintenance_Request_" +
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
          ToastUtils.showCustomToast(
              context, GlobleString.Blank_Landloadview, false);
        }

        loader.remove();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  duplicateMaintenaceworkflow(BuildContext context, String id, String typeuser,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.workflow_landlord_Maintenance_Duplicate,
      "Reqtokens": {"MaintenanceID": id, "Type_User": typeuser}
    };

    String json = jsonEncode(myjson);

    Helper.Log("duplicateMaintenaceworkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        String mid = data['Result'] != null ? data['Result'].toString() : "";

        Helper.Log("duplicateMaintenaceworkflow", respoce);
        callBackQuesy(true, mid);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  deleteMaintenace(
      BuildContext context, String id, CallBackQuesy CallBackQuesy) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String query = Weburl.RawSQL_Api +
        "query=DeleteMaintenanceAllData&Maintenance_ID=" +
        id;

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

  updateMaintenanceStatus(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Maintenance,
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

  checkMaintenanceExit(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) async {
    String query = await QueryFilter().SelectQuery(POJO, etableName.Maintenance,
        eConjuctionClause().AND, eRelationalOperator().EqualTo, false);

    HttpClientCall().selectAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data["Result"] != null && data["Result"].length > 0) {
          CallBackQuesy(true, "");
        } else {
          CallBackQuesy(false, "1");
        }
      } else {
        Helper.Log("userCheckActive respoce", respoce);
        CallBackQuesy(false, respoce);
      }
    });
  }

  maintenanceDetailsApi(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_landlord_Maintenance_Details,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("maintenanceDetailsApi", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            SystemEnumDetails? Category = myobject['Category'] != null
                ? SystemEnumDetails.fromJson(myobject['Category'])
                : null;

            SystemEnumDetails? Status = myobject['Status'] != null
                ? SystemEnumDetails.fromJson(myobject['Status'])
                : null;

            SystemEnumDetails? Priority = myobject['Priority'] != null
                ? SystemEnumDetails.fromJson(myobject['Priority'])
                : null;

            String mID =
                myobject['ID'] != null ? myobject['ID'].toString() : "";
            String Date_Created = myobject['Date_Created'] != null
                ? myobject['Date_Created'].toString()
                : "";
            bool IsLock =
                myobject['IsLock'] != null ? myobject['IsLock'] : false;
            String Describe_Issue = myobject['Describe_Issue'] != null
                ? myobject['Describe_Issue']
                : "";
            int Type_User =
                myobject['Type_User'] != null ? myobject['Type_User'] : 0;
            String RequestName =
                myobject['RequestName'] != null ? myobject['RequestName'] : "";

            _store.dispatch(UpdateMDA_mID(mID));
            _store.dispatch(UpdateMDA_Date_Created(Date_Created));
            _store.dispatch(UpdateMDA_IsLock(IsLock));
            _store.dispatch(UpdateMDA_Describe_Issue(Describe_Issue));
            _store.dispatch(UpdateMDA_Type_User(Type_User));
            _store.dispatch(UpdateMDA_RequestName(RequestName));
            _store.dispatch(UpdateMDA_Priority(Priority));
            _store.dispatch(UpdateMDA_Status(Status));
            _store.dispatch(UpdateMDA_Category(Category));

            if (myobject["Prop_ID"] != null) {
              var Prop_ID = myobject["Prop_ID"];

              String ID = Prop_ID['ID'] != null ? Prop_ID['ID'] : "";

              String PropertyName = Prop_ID['PropertyName'] != null
                  ? Prop_ID['PropertyName']
                  : "";
              String Suite_Unit =
                  Prop_ID['Suite_Unit'] != null ? Prop_ID['Suite_Unit'] : "";
              String Property_Address = Prop_ID['Property_Address'] != null
                  ? Prop_ID['Property_Address']
                  : "";
              String City = Prop_ID['City'] != null ? Prop_ID['City'] : "";
              String Province =
                  Prop_ID['Province'] != null ? Prop_ID['Province'] : "";
              String Country =
                  Prop_ID['Country'] != null ? Prop_ID['Country'] : "";
              String Postal_Code =
                  Prop_ID['Postal_Code'] != null ? Prop_ID['Postal_Code'] : "";

              String addrsss = Property_Address +
                  ", " +
                  City +
                  ", " +
                  Province +
                  ", " +
                  Postal_Code +
                  ", " +
                  Country;

              _store.dispatch(UpdateMDA_Prop_ID(ID));
              _store.dispatch(UpdateMDA_PropertyName(PropertyName));
              _store.dispatch(UpdateMDA_Suite_Unit(Suite_Unit));
              _store.dispatch(UpdateMDA_Property_Address(addrsss));
            }

            if (myobject["Applicant_ID"] != null) {
              var Applicant_ID = myobject["Applicant_ID"];

              String ID = Applicant_ID['ID'] != null
                  ? Applicant_ID['ID'].toString()
                  : "";

              String UserID = Applicant_ID['UserID'] != null
                  ? Applicant_ID['UserID'].toString()
                  : "";

              var Person_ID = Applicant_ID["Person_ID"];

              String Email = Person_ID['Email'] != null
                  ? Person_ID['Email'].toString()
                  : "";
              String FirstName = Person_ID['FirstName'] != null
                  ? Person_ID['FirstName'].toString()
                  : "";
              String LastName = Person_ID['LastName'] != null
                  ? Person_ID['LastName'].toString()
                  : "";
              String MobileNumber = Person_ID['MobileNumber'] != null
                  ? Person_ID['MobileNumber'].toString()
                  : "";
              String Dial_Code = Person_ID['Dial_Code'] != null
                  ? Person_ID['Dial_Code'].toString()
                  : "";

              _store.dispatch(UpdateMDA_Applicant_ID(ID));
              _store.dispatch(UpdateMDA_Applicant_UserID(UserID));
              _store.dispatch(UpdateMDA_Applicant_email(Email));
              _store.dispatch(UpdateMDA_Applicant_firstname(FirstName));
              _store.dispatch(UpdateMDA_Applicant_lastname(LastName));
              _store.dispatch(UpdateMDA_Applicant_mobile(MobileNumber));
              _store.dispatch(UpdateMDA_Applicant_dialcode(Dial_Code));
            }

            if (myobject["Owner_ID"] != null) {
              var OwnerIDobj = myobject["Owner_ID"];

              String Owner_ID =
                  OwnerIDobj['ID'] != null ? OwnerIDobj['ID'].toString() : "";
              String HomePageLink = OwnerIDobj['HomePageLink'] != null
                  ? OwnerIDobj['HomePageLink'].toString()
                  : "";
              String CompanyName = OwnerIDobj['CompanyName'] != null
                  ? OwnerIDobj['CompanyName'].toString()
                  : "";

              MediaInfo? Company_logo = OwnerIDobj['Company_logo'] != null
                  ? MediaInfo.fromJson(OwnerIDobj['Company_logo'])
                  : null;

              var PersonIDobj = OwnerIDobj["PersonID"];

              String Email = PersonIDobj['Email'] != null
                  ? PersonIDobj['Email'].toString()
                  : "";
              String FirstName = PersonIDobj['FirstName'] != null
                  ? PersonIDobj['FirstName'].toString()
                  : "";
              String LastName = PersonIDobj['LastName'] != null
                  ? PersonIDobj['LastName'].toString()
                  : "";
              String MobileNumber = PersonIDobj['MobileNumber'] != null
                  ? PersonIDobj['MobileNumber'].toString()
                  : "";
              String Dial_Code = PersonIDobj['Dial_Code'] != null
                  ? PersonIDobj['Dial_Code'].toString()
                  : "";

              _store.dispatch(UpdateMDA_Owner_ID(Owner_ID));
              _store.dispatch(UpdateMDA_HomePageLink(HomePageLink));
              _store.dispatch(UpdateMDA_CompanyName(CompanyName));
              _store.dispatch(UpdateMDA_Owner_email(Email));
              _store.dispatch(UpdateMDA_Owner_firstname(FirstName));
              _store.dispatch(UpdateMDA_Owner_lastname(LastName));
              _store.dispatch(UpdateMDA_Owner_mobile(MobileNumber));
              _store.dispatch(UpdateMDA_Owner_dialcode(Dial_Code));
              _store.dispatch(UpdateMDA_Company_logo(Company_logo));
            }
          }
          //loader.remove();
          callBackQuesy(true, "");
        } else {
          callBackQuesy(false, respoce);
        }
      } else {
        //loader.remove();
        Helper.Log("respoce", respoce);
        callBackQuesy(false, respoce);
      }
    });
  }

  MaintenanceImagesApi(BuildContext context, String id,
      CallBackMaintenanceImageslist callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_landlord_PropertyMaintenanceImages,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("maintenanceDetailsApi", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        List<PropertyMaintenanceImages> maintenanceImageslist =
            <PropertyMaintenanceImages>[];

        if (data['Result'].length > 0) {
          for (int j = 0; j < data['Result'].length; j++) {
            var objectPMImages = data['Result'][j];

            PropertyMaintenanceImages image = new PropertyMaintenanceImages();

            image.id = objectPMImages['ID'] != null ? objectPMImages['ID'] : 0;

            image.mediaId = objectPMImages['Media_ID'] != null
                ? MediaInfo.fromJson(objectPMImages['Media_ID'])
                : null;
            maintenanceImageslist.add(image);
          }

          //loader.remove();
          callBackQuesy(true, "", maintenanceImageslist);
        } else {
          callBackQuesy(false, respoce, []);
        }
      } else {
        //loader.remove();
        Helper.Log("respoce", respoce);
        callBackQuesy(false, respoce, []);
      }
    });
  }

  MaintenanceVendorDetailsApi(BuildContext context, String id,
      CallBackMaintenanceVendorlist callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_landlord_MaintenanceVendor_Details,
      "LoadLookupValues": true,
      "Reqtokens": {"ID": id}
    };

    String json = jsonEncode(myjson);

    Helper.Log("maintenanceDetailsApi", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        List<MaintenanceVendor> maintenanceVendorlist = <MaintenanceVendor>[];

        if (data['Result'].length > 0) {
          for (int j = 0; j < data['Result'].length; j++) {
            var objectMaintenanceVendor = data['Result'][j];

            MaintenanceVendor maintenanceVendor = new MaintenanceVendor();

            maintenanceVendor.ID = objectMaintenanceVendor['ID'] != null
                ? objectMaintenanceVendor['ID'].toString()
                : "";

            maintenanceVendor.Instruction =
                objectMaintenanceVendor['Instruction'] != null
                    ? objectMaintenanceVendor['Instruction'].toString()
                    : "";

            var VendorID = objectMaintenanceVendor["VendorID"];

            maintenanceVendor.province = VendorID['Province'] != null
                ? StateData.fromJson(VendorID['Province'])
                : null;

            maintenanceVendor.companyName = VendorID['CompanyName'] != null
                ? VendorID['CompanyName'].toString()
                : "";

            maintenanceVendor.rating =
                VendorID['Rating'] != null ? VendorID['Rating'] : "";

            maintenanceVendor.address = VendorID['Address'] != null
                ? VendorID['Address'].toString()
                : "";

            maintenanceVendor.vid = VendorID['ID'] != null ? VendorID['ID'] : 0;

            maintenanceVendor.suite =
                VendorID['Suite'] != null ? VendorID['Suite'].toString() : "";

            maintenanceVendor.city = VendorID['City'] != null
                ? CityData.fromJson(VendorID['City'])
                : null;

            maintenanceVendor.country = VendorID['Country'] != null
                ? CountryData.fromJson(VendorID['Country'])
                : null;

            maintenanceVendor.category = VendorID['Category'] != null
                ? SystemEnumDetails.fromJson(VendorID['Category'])
                : null;

            //maintenanceVendor.category = null;

            var PersonIDobj = VendorID["PersonID"];

            maintenanceVendor.PersonID =
                PersonIDobj['ID'] != null ? PersonIDobj['ID'].toString() : "";

            maintenanceVendor.email = PersonIDobj['Email'] != null
                ? PersonIDobj['Email'].toString()
                : "";

            maintenanceVendor.firstName = PersonIDobj['FirstName'] != null
                ? PersonIDobj['FirstName'].toString()
                : "";

            maintenanceVendor.lastName = PersonIDobj['LastName'] != null
                ? PersonIDobj['LastName'].toString()
                : "";

            maintenanceVendor.mobileNumber = PersonIDobj['MobileNumber'] != null
                ? PersonIDobj['MobileNumber'].toString()
                : "";
            String Dial_Code = PersonIDobj['Dial_Code'] != null
                ? PersonIDobj['Dial_Code'].toString()
                : "";

            maintenanceVendor.showInstruction = false;

            maintenanceVendorlist.add(maintenanceVendor);
          }
          //loader.remove();
          callBackQuesy(true, "", maintenanceVendorlist);
        } else {
          callBackQuesy(false, respoce, []);
        }
      } else {
        //loader.remove();
        Helper.Log("respoce", respoce);
        callBackQuesy(false, respoce, []);
      }
    });
  }

  maintenanceDetailsApiCallback(BuildContext context, String maintenanceid,
      int flag, CallBackMaintenanceDetails callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_landlord_Maintenance_Details,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"ID": maintenanceid}
    };

    String json = jsonEncode(myjson);

    Helper.Log("maintenanceDetailsApi", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        MaintenanceDetails maintenanceDetails = new MaintenanceDetails();

        if (data['Result'] != null && data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            SystemEnumDetails? Category = myobject['Category'] != null
                ? SystemEnumDetails.fromJson(myobject['Category'])
                : null;

            SystemEnumDetails? Status = myobject['Status'] != null
                ? SystemEnumDetails.fromJson(myobject['Status'])
                : null;

            SystemEnumDetails? Priority = myobject['Priority'] != null
                ? SystemEnumDetails.fromJson(myobject['Priority'])
                : null;

            String mID =
                myobject['ID'] != null ? myobject['ID'].toString() : "";
            String Date_Created = myobject['Date_Created'] != null
                ? myobject['Date_Created'].toString()
                : "";
            bool IsLock =
                myobject['IsLock'] != null ? myobject['IsLock'] : false;
            String Describe_Issue = myobject['Describe_Issue'] != null
                ? myobject['Describe_Issue']
                : "";
            int Type_User =
                myobject['Type_User'] != null ? myobject['Type_User'] : 0;
            String RequestName =
                myobject['RequestName'] != null ? myobject['RequestName'] : "";

            CountryData? Country = myobject['Country'] != null
                ? CountryData.fromJson(myobject['Country'])
                : null;

            StateData? State = myobject['State'] != null
                ? StateData.fromJson(myobject['State'])
                : null;

            String City = myobject['City'] != null ? myobject['City'] : "";

            maintenanceDetails.mID = mID;
            maintenanceDetails.Date_Created = Date_Created;
            maintenanceDetails.IsLock = IsLock;
            maintenanceDetails.Describe_Issue = Describe_Issue;
            maintenanceDetails.Type_User = Type_User;
            maintenanceDetails.RequestName = RequestName;
            maintenanceDetails.Priority = Priority;
            maintenanceDetails.Status = Status;
            maintenanceDetails.Category = Category;
            maintenanceDetails.Country = Country;
            maintenanceDetails.State = State;
            maintenanceDetails.City = City;

            if (myobject["Prop_ID"] != null) {
              var Prop_ID = myobject["Prop_ID"];

              String ID = Prop_ID['ID'] != null ? Prop_ID['ID'] : "";

              String PropertyName = Prop_ID['PropertyName'] != null
                  ? Prop_ID['PropertyName']
                  : "";
              String Suite_Unit =
                  Prop_ID['Suite_Unit'] != null ? Prop_ID['Suite_Unit'] : "";
              String Property_Address = Prop_ID['Property_Address'] != null
                  ? Prop_ID['Property_Address']
                  : "";
              String City = Prop_ID['City'] != null ? Prop_ID['City'] : "";
              String Province =
                  Prop_ID['Province'] != null ? Prop_ID['Province'] : "";
              String Country =
                  Prop_ID['Country'] != null ? Prop_ID['Country'] : "";
              String Postal_Code =
                  Prop_ID['Postal_Code'] != null ? Prop_ID['Postal_Code'] : "";

              String addrsss = Property_Address +
                  ", " +
                  City +
                  ", " +
                  Province +
                  ", " +
                  Postal_Code +
                  ", " +
                  Country;

              maintenanceDetails.Prop_ID = ID;
              maintenanceDetails.PropertyName = PropertyName;
              maintenanceDetails.Suite_Unit = Suite_Unit;
              maintenanceDetails.Property_Address = addrsss;
            }

            if (myobject["Applicant_ID"] != null) {
              var Applicant_ID = myobject["Applicant_ID"];

              String ID = Applicant_ID['ID'] != null
                  ? Applicant_ID['ID'].toString()
                  : "";

              String UserID = Applicant_ID['UserID'] != null
                  ? Applicant_ID['UserID'].toString()
                  : "";

              var Person_ID = Applicant_ID["Person_ID"];

              String Email = Person_ID['Email'] != null
                  ? Person_ID['Email'].toString()
                  : "";
              String FirstName = Person_ID['FirstName'] != null
                  ? Person_ID['FirstName'].toString()
                  : "";
              String LastName = Person_ID['LastName'] != null
                  ? Person_ID['LastName'].toString()
                  : "";
              String MobileNumber = Person_ID['MobileNumber'] != null
                  ? Person_ID['MobileNumber'].toString()
                  : "";
              String Dial_Code = Person_ID['Dial_Code'] != null
                  ? Person_ID['Dial_Code'].toString()
                  : "";

              maintenanceDetails.Applicant_ID = ID;
              maintenanceDetails.Applicant_UserID = UserID;
              maintenanceDetails.Applicant_email = Email;
              maintenanceDetails.Applicant_firstname = FirstName;
              maintenanceDetails.Applicant_lastname = LastName;
              maintenanceDetails.Applicant_mobile = MobileNumber;
              maintenanceDetails.Applicant_dialcode = Dial_Code;
            } else {
              maintenanceDetails.Applicant_ID = "";
            }

            if (myobject["Owner_ID"] != null) {
              var OwnerIDobj = myobject["Owner_ID"];

              String Owner_ID =
                  OwnerIDobj['ID'] != null ? OwnerIDobj['ID'].toString() : "";
              String HomePageLink = OwnerIDobj['HomePageLink'] != null
                  ? OwnerIDobj['HomePageLink'].toString()
                  : "";
              String CompanyName = OwnerIDobj['CompanyName'] != null
                  ? OwnerIDobj['CompanyName'].toString()
                  : "";

              MediaInfo? Company_logo = OwnerIDobj['Company_logo'] != null
                  ? MediaInfo.fromJson(OwnerIDobj['Company_logo'])
                  : null;

              var PersonIDobj = OwnerIDobj["PersonID"];

              String Email = PersonIDobj['Email'] != null
                  ? PersonIDobj['Email'].toString()
                  : "";
              String FirstName = PersonIDobj['FirstName'] != null
                  ? PersonIDobj['FirstName'].toString()
                  : "";
              String LastName = PersonIDobj['LastName'] != null
                  ? PersonIDobj['LastName'].toString()
                  : "";
              String MobileNumber = PersonIDobj['MobileNumber'] != null
                  ? PersonIDobj['MobileNumber'].toString()
                  : "";
              String Dial_Code = PersonIDobj['Dial_Code'] != null
                  ? PersonIDobj['Dial_Code'].toString()
                  : "";

              maintenanceDetails.Owner_ID = Owner_ID;
              maintenanceDetails.HomePageLink = HomePageLink;
              maintenanceDetails.CompanyName = CompanyName;
              maintenanceDetails.Owner_email = Email;
              maintenanceDetails.Owner_firstname = FirstName;
              maintenanceDetails.Owner_lastname = LastName;
              maintenanceDetails.Owner_mobile = MobileNumber;
              maintenanceDetails.Owner_dialcode = Dial_Code;
              maintenanceDetails.Company_logo = Company_logo;
            }

            await ApiManager().MaintenanceImagesApi(context, maintenanceid,
                (status, responce, maintenanceImageslist) async {
              if (status) {
                maintenanceDetails.maintenanceImageslist =
                    maintenanceImageslist;
              } else {
                maintenanceDetails.maintenanceImageslist = [];
              }

              await ApiManager()
                  .MaintenanceVendorDetailsApi(context, maintenanceid,
                      (status, responce, maintenanceVendorlist) {
                if (status) {
                  maintenanceDetails.maintenanceVendorlist =
                      maintenanceVendorlist;
                } else {
                  maintenanceDetails.maintenanceVendorlist = [];
                }

                if (flag == 1) {
                  updateMaintenanceData(
                      context, maintenanceDetails, callBackQuesy);
                } else if (flag == 2) {
                  updateTenantMaintenanceData(
                      context, maintenanceDetails, callBackQuesy);
                } else {
                  callBackQuesy(true, "", maintenanceDetails);
                }
              });
            });
          }
        } else {
          callBackQuesy(false, "", null);
        }
      } else {
        //loader.remove();
        Helper.Log("respoce", respoce);
        callBackQuesy(false, respoce, null);
      }
    });
  }

  updateMaintenanceData(
      BuildContext context,
      MaintenanceDetails maintenanceDetails,
      CallBackMaintenanceDetails callBackQuesy) async {
    List<SystemEnumDetails> MaintenanceStatuslist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Status);
    List<SystemEnumDetails> MaintenanceCategorylist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Category);

    _store.dispatch(UpdateMER_MaintenanceStatuslist(MaintenanceStatuslist));
    _store.dispatch(UpdateMER_MaintenanceCategorylist(MaintenanceCategorylist));
    _store.dispatch(UpdateMER_selectStatus(maintenanceDetails.Status));
    _store.dispatch(UpdateMER_selectCategory(maintenanceDetails.Category));

    if (maintenanceDetails.Priority != null) {
      _store.dispatch(
          UpdateMER_priority(maintenanceDetails.Priority!.EnumDetailID));
    }

    ApiManager().getLogActivityList(context, maintenanceDetails.mID.toString(),
        (error, respoce) async {
      if (error) {
      } else {
        Helper.Log("respoce", respoce);
      }
    });

    _store.dispatch(UpdateMER_mid(maintenanceDetails.mID!));
    _store.dispatch(UpdateMER_Applicant_ID(
        maintenanceDetails.Applicant_ID != null
            ? maintenanceDetails.Applicant_ID!
            : ""));
    _store.dispatch(UpdateMER_Type_User(maintenanceDetails.Type_User!));
    _store.dispatch(UpdateMER_IsLock(maintenanceDetails.IsLock!));
    _store.dispatch(UpdateMER_requestName(maintenanceDetails.RequestName!));
    _store.dispatch(UpdateMER_description(maintenanceDetails.Describe_Issue!));
    _store.dispatch(UpdateMER_description(maintenanceDetails.Describe_Issue!));

    if (maintenanceDetails.maintenanceImageslist != null &&
        maintenanceDetails.maintenanceImageslist!.length > 0) {
      List<FileObject> fileobjectlist = [];

      for (int i = 0;
          i < maintenanceDetails.maintenanceImageslist!.length;
          i++) {
        PropertyMaintenanceImages pim =
            maintenanceDetails.maintenanceImageslist![i];

        FileObject fileObject = new FileObject();
        fileObject.appImage = null;
        fileObject.filename = "";
        fileObject.islocal = false;
        fileObject.mediaId = pim.mediaId;
        fileObject.id = pim.id;

        fileobjectlist.add(fileObject);
      }
      _store.dispatch(UpdateMER_fileobjectlist(fileobjectlist));
    }

    String address = maintenanceDetails.PropertyName! +
        " - " +
        (maintenanceDetails.Suite_Unit!.isNotEmpty
            ? maintenanceDetails.Suite_Unit! + " - "
            : "") +
        maintenanceDetails.Property_Address!;

    PropertyDropData propertyDropData = new PropertyDropData();
    propertyDropData.id = maintenanceDetails.Prop_ID!;
    propertyDropData.propertyName = address;

    _store.dispatch(UpdateMER_selectproperty(propertyDropData));

    _store.dispatch(UpdateMER_PropertyDropDatalist([]));
    await ApiManager()
        .getPropertyMaintenanceList(context, Prefs.getString(PrefsName.OwnerID),
            (status, responce, errorlist) {
      if (status) {
        _store.dispatch(UpdateMER_PropertyDropDatalist(errorlist));
      } else {
        _store.dispatch(UpdateMER_PropertyDropDatalist([]));
      }
    });

    ApiManager().getCountryList(context, (status, responce, errorlist) {
      if (status) {
        _store.dispatch(UpdateMER_countrydatalist(errorlist));
      }
    });

    _store.dispatch(UpdateMER_selectedCountry(maintenanceDetails.Country));
    _store.dispatch(UpdateMER_selectedState(maintenanceDetails.State));

    if (maintenanceDetails.Country != null) {
      await ApiManager()
          .getStateList(context, maintenanceDetails.Country!.ID.toString(),
              (status, responce, errorlist) {
        if (status) {
          _store.dispatch(UpdateMER_statedatalist(errorlist));
        }
      });

      if (maintenanceDetails.State != null) {
        await ApiManager()
            .getCityList(context, maintenanceDetails.State!.ID.toString(),
                (status, responce, errorlist) async {
          if (status) {
            _store.dispatch(UpdateMER_citydatalist(errorlist));

            if (maintenanceDetails.City != null &&
                maintenanceDetails.City!.isNotEmpty) {
              List<CityData>? selectedCity = [];
              for (int i = 0; i < errorlist.length; i++) {
                CityData cityData = errorlist[i];

                if (maintenanceDetails.City!.contains(cityData.ID.toString())) {
                  selectedCity.add(cityData);
                }
              }

              _store.dispatch(UpdateMER_selectedCity(selectedCity));

              await ApiManager()
                  .getCityWiseVendorList(context, maintenanceDetails.City!,
                      (status, responce, errorlist) async {
                if (status) {
                  _store.dispatch(UpdateMER_mainvendordatalist(errorlist));
                  List<SystemEnumDetails> categorylist =
                      await Helper.removeDuplicates(errorlist);
                  _store.dispatch(UpdateMER_filterCategorylist(categorylist));

                  Helper.Log("getCityWiseVendorList categorylist",
                      categorylist.toString());

                  if (maintenanceDetails.maintenanceVendorlist != null &&
                      maintenanceDetails.maintenanceVendorlist!.length > 0) {
                    List<AddVendorData> addvendordatalist = [];

                    for (int i = 0;
                        i < maintenanceDetails.maintenanceVendorlist!.length;
                        i++) {
                      MaintenanceVendor avd =
                          maintenanceDetails.maintenanceVendorlist![i];

                      AddVendorData addVendorData = new AddVendorData();
                      addVendorData.id = avd.ID;
                      addVendorData.selectfilterCategory = avd.category;
                      addVendorData.Instruction = avd.Instruction;

                      List<VendorData> vendordatalist = [];
                      if (avd.category != null) {
                        vendordatalist =
                            await Helper.filtervendor(errorlist, avd.category!);
                      }

                      addVendorData.filtervendordatalist = vendordatalist;
                      addVendorData.selectvendor =
                          await Helper.filtervendorByID(errorlist, avd.vid!);

                      addvendordatalist.add(addVendorData);
                    }

                    _store
                        .dispatch(UpdateMER_vendordatalist(addvendordatalist));
                  } else {
                    _store.dispatch(UpdateMER_vendordatalist([]));
                  }
                } else {}
              });
            }
          }
        });
      } else {
        _store.dispatch(UpdateMER_selectedState(null));
        _store.dispatch(UpdateMER_selectedCity([]));
        _store.dispatch(UpdateMER_mainvendordatalist([]));
        _store.dispatch(UpdateMER_filterCategorylist([]));
      }
    } else {
      _store.dispatch(UpdateMER_selectedState(null));
      _store.dispatch(UpdateMER_selectedCity([]));
      _store.dispatch(UpdateMER_mainvendordatalist([]));
      _store.dispatch(UpdateMER_filterCategorylist([]));
    }

    callBackQuesy(true, "", maintenanceDetails);
  }

  updateTenantMaintenanceData(
      BuildContext context,
      MaintenanceDetails maintenanceDetails,
      CallBackMaintenanceDetails callBackQuesy) async {
    // List<SystemEnumDetails> MaintenanceStatuslist = QueryFilter().PlainValues(eSystemEnums().Maintenance_Status);
    List<SystemEnumDetails> MaintenanceCategorylist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Category);

    _store.dispatch(UpdateTMR_MaintenanceCategorylist(MaintenanceCategorylist));
    _store.dispatch(UpdateTMR_selectStatus(maintenanceDetails.Status));
    _store.dispatch(UpdateTMR_selectCategory(maintenanceDetails.Category));

    if (maintenanceDetails.Priority != null) {
      _store.dispatch(
          UpdateTMR_priority(maintenanceDetails.Priority!.EnumDetailID));
    }

    _store.dispatch(UpdateTMR_mid(maintenanceDetails.mID!));
    _store.dispatch(UpdateTMR_Type_User(maintenanceDetails.Type_User!));
    _store.dispatch(UpdateTMR_IsLock(maintenanceDetails.IsLock!));
    _store.dispatch(UpdateTMR_requestName(maintenanceDetails.RequestName!));
    _store.dispatch(UpdateTMR_description(maintenanceDetails.Describe_Issue!));

    if (maintenanceDetails.maintenanceImageslist != null &&
        maintenanceDetails.maintenanceImageslist!.length > 0) {
      List<FileObject> fileobjectlist = [];

      for (int i = 0;
          i < maintenanceDetails.maintenanceImageslist!.length;
          i++) {
        PropertyMaintenanceImages pim =
            maintenanceDetails.maintenanceImageslist![i];

        FileObject fileObject = new FileObject();
        fileObject.appImage = null;
        fileObject.filename = "";
        fileObject.islocal = false;
        fileObject.mediaId = pim.mediaId;
        fileObject.id = pim.id;

        fileobjectlist.add(fileObject);
      }
      _store.dispatch(UpdateTMR_fileobjectlist(fileobjectlist));
    }

    callBackQuesy(true, "", maintenanceDetails);
  }

  getCountryList(BuildContext context, CallBackCountry callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_Country,
      "LoadLookUpValues": false,
    };

    String json = jsonEncode(myjson);

    Helper.Log("getCountryList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("CountryList Responce", respoce);
        //loader.remove();
        var data = jsonDecode(respoce);

        List<CountryData> countrylist = <CountryData>[];

        if (data['Result'].length > 0) {
          countrylist = (data['Result'] as List)
              .map((p) => CountryData.fromJson(p))
              .toList();
        }
        callback(true, "", countrylist);
      } else {
        callback(false, "", []);
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getStateList(BuildContext context, String id, CallBackState callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_State,
      "Reqtokens": {"ID": id},
      "LoadLookUpValues": false,
    };

    String json = jsonEncode(myjson);

    Helper.Log("getStateList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("StateList Responce", respoce);
        //loader.remove();
        var data = jsonDecode(respoce);

        List<StateData> statelist = <StateData>[];

        if (data['Result'].length > 0) {
          statelist = (data['Result'] as List)
              .map((p) => StateData.fromJson(p))
              .toList();
        }
        callback(true, "", statelist);
      } else {
        callback(false, "", []);
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getCityList(BuildContext context, String id, CallBackCity callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_City,
      "Reqtokens": {"StateID": id},
      "LoadLookUpValues": false,
    };

    String json = jsonEncode(myjson);

    Helper.Log("getCityList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("CityList Responce", respoce);
        //loader.remove();
        var data = jsonDecode(respoce);

        List<CityData> citylist = <CityData>[];

        if (data['Result'].length > 0) {
          citylist = (data['Result'] as List)
              .map((p) => CityData.fromJson(p))
              .toList();
        }
        callback(true, "", citylist);
      } else {
        callback(false, "", []);
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getPropertyMaintenanceList(BuildContext context, String ownerid,
      CallBackMaintenancePro callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_Property_Maintenance_list,
      "Reqtokens": {"Owner_ID": ownerid},
      "LoadLookUpValues": false,
      "LoadRecordInfo": false
    };

    String json = jsonEncode(myjson);

    Helper.Log("Property", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<PropertyDropData> propertylist = <PropertyDropData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          PropertyDropData propertyDropData = new PropertyDropData();

          var myobject = data['Result'][i];

          String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

          String PropertyName = myobject['PropertyName'] != null
              ? myobject['PropertyName'].toString()
              : "";

          String Suite_Unit = myobject['Suite_Unit'] != null
              ? myobject['Suite_Unit'].toString()
              : "";

          String Property_Address = myobject['Property_Address'] != null
              ? myobject['Property_Address'].toString()
              : "";

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String Country =
              myobject['Country'] != null ? myobject['Country'].toString() : "";

          String Province = myobject['Province'] != null
              ? myobject['Province'].toString()
              : "";

          String address = PropertyName +
              " - " +
              (Suite_Unit.isNotEmpty ? Suite_Unit + " - " : "") +
              Property_Address +
              ", " +
              City +
              ", " +
              Province +
              ", " +
              Country;

          propertyDropData.id = ID;
          propertyDropData.propertyName = address;

          propertylist.add(propertyDropData);
        }
        callback(true, "", propertylist);
      } else {
        callback(false, "", []);
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getPropertyWiseApplicantID(
      BuildContext context, String propid, CallBackApplicant callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_Applicant_Propertywise,
      "Reqtokens": {"Prop_ID": propid},
      "LoadLookUpValues": false,
      "LoadRecordInfo": false
    };

    String json = jsonEncode(myjson);

    Helper.Log("Property", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        String Applicant_ID = "";
        String ApplicantionID = "";

        if (data['Result'] != null && data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            Applicant_ID = myobject['Applicant_ID'] != null
                ? myobject['Applicant_ID'].toString()
                : "";

            ApplicantionID =
                myobject['ID'] != null ? myobject['ID'].toString() : "";
          }
        }
        callback(true, "", Applicant_ID, ApplicantionID);
      } else {
        callback(false, "", "", "");
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  //Multifile
  MaintenanceImagesUpload(BuildContext context, List<FileObject> fileobjectlist,
      CallBackListQuesy CallBackQuesy) async {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    var multipartRequest =
        new http.MultipartRequest("POST", Uri.parse(Weburl.FileUpload_Api));
    multipartRequest.headers.addAll(headers);

    for (int i = 0; i < fileobjectlist.length; i++) {
      FileObject file = fileobjectlist[i];

      if (file.islocal != null && file.islocal! && file.appImage != null) {
        List<int> _selectedFile = file.appImage!;
        String filepath = "";
        String extenson = "";

        if ((file.filename!.split('.').last).contains("jpg") ||
            (file.filename!.split('.').last).contains("JPG")) {
          /*String name = file.filename!
              .replaceAll("." + file.filename!.split('.').last, "");
          String name2 = '${DateTime
              .now()
              .millisecondsSinceEpoch}.jpg';*/
          filepath = file.filename!;
          extenson = "jpg";
        } else if ((file.filename!.split('.').last).contains("png") ||
            (file.filename!.split('.').last).contains("PNG")) {
          filepath = file.filename!;
          extenson = "png";
        } else if ((file.filename!.split('.').last).contains("jpeg") ||
            (file.filename!.split('.').last).contains("jpeg")) {
          filepath = file.filename!;
          extenson = "jpeg";
        } else if ((file.filename!.split('.').last).contains("heif") ||
            (file.filename!.split('.').last).contains("HEIF")) {
          filepath = file.filename!;
          extenson = "png";
        } else if ((file.filename!.split('.').last).contains("pdf") ||
            (file.filename!.split('.').last).contains("PDF")) {
          filepath = file.filename!;
          extenson = "pdf";
        } else if ((file.filename!.split('.').last).contains("mp4") ||
            (file.filename!.split('.').last).contains("MP4")) {
          filepath = file.filename!;
          extenson = "mp4";
        } else {
          filepath = file.filename!;
          extenson = "png";
        }

        multipartRequest.files.add(await http.MultipartFile.fromBytes(
            'file[]', _selectedFile,
            contentType: new MediaType('application', extenson),
            filename: filepath));
      }
    }

    await multipartRequest.send().then((result) {
      if (result.statusCode == 200) {
        http.Response.fromStream(result).then((response) {
          if (response.statusCode == 200) {
            if (jsonDecode(response.body)['StatusCode'].toString() == "200") {
              var data = jsonDecode(response.body);

              if (data != null) {
                List<String> mediaString = [];
                for (int i = 0; i < data['Result'].length; i++) {
                  var myobject = data['Result'][i];

                  String MediaID = myobject['MediaID'] != null
                      ? "" + myobject['MediaID'].toString()
                      : "";

                  String url = myobject['url'] != null
                      ? "" + myobject['url'].toString()
                      : "";

                  mediaString.add(MediaID);

                  if (data['Result'].length - 1 == i) {
                    CallBackQuesy(true, mediaString, "");
                  }
                }
              } else {
                CallBackQuesy(false, [], GlobleString.Error);
              }
            } else {
              CallBackQuesy(false, [], GlobleString.Error);
            }
          } else if (response.statusCode == 401) {
            CallBackQuesy(false, [], GlobleString.Error_401);
          } else {
            CallBackQuesy(false, [], GlobleString.Error);
          }
        });
      } else if (result.statusCode == 401) {
        CallBackQuesy(false, [], GlobleString.Error_401);
      } else {
        CallBackQuesy(false, [], GlobleString.Error);
      }
    });
  }

  InsetMaintenanceImages(
      BuildContext context, List<Object> POJO, CallBackQuesy CallBackQuesy) {
    String json = QueryFilter().InsertQueryArray(
        POJO,
        etableName.PropertyMaintenanceImages,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

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
            CallBackQuesy(false, respoce);
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

  InsetNewRequest(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQuery(POJO, etableName.Maintenance,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, Result);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  UpdateMaintenanceRequest(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Maintenance,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        //String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, "");
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  getLogActivityList(
      BuildContext context, String mid, CallBackQuesy callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_LogActivity_list,
      "Reqtokens": {
        "Owner_ID": Prefs.getString(PrefsName.OwnerID),
        "Maintenance_ID": mid
      },
      "LoadLookUpValues": false,
    };

    String json = jsonEncode(myjson);

    Helper.Log("getLogActivityList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("getLogActivityList Responce", respoce);
        //loader.remove();
        var data = jsonDecode(respoce);

        List<LogActivity> logactivitylist = <LogActivity>[];

        if (data['Result'].length > 0) {
          logactivitylist = (data['Result'] as List)
              .map((p) => LogActivity.fromJson(p))
              .toList();
        }

        _store.dispatch(UpdateMER_logActivitylist(logactivitylist));

        callback(true, "");
      } else {
        _store.dispatch(UpdateMER_logActivitylist([]));
        callback(false, "");
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  InsetLogActivity(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQuery(POJO, etableName.LogActivities,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, Result);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  deleteLogActivity(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().DeleteQuery(POJO, etableName.LogActivities,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().deleteAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  deleteMaintenanceVendor(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().DeleteQuery(POJO, etableName.MaintenanceVendor,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().deleteAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  InsetAssigneVendorRequest(BuildContext context, List<Object> POJO,
      Object? dPOJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> queryList = <QueryObject>[];

    if (dPOJO != null) {
      String query = QueryFilter().DeleteQuery(
          dPOJO,
          etableName.MaintenanceVendor,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var querydecode = jsonDecode(query);
      QueryObject updatequery = QueryObject.fromJson(querydecode);
      queryList.add(updatequery);
    }

    for (int i = 0; i < POJO.length; i++) {
      String queryinsert = QueryFilter().InsertQuery(
          POJO[i],
          etableName.MaintenanceVendor,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      queryList.add(insetquery);
    }

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

  deleteMaintenanceImage(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().DeleteQuery(
        POJO,
        etableName.PropertyMaintenanceImages,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().deleteAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

/*==========================================================================*/
/*======================== Landlord Vendor Module ==========================*/
/*==========================================================================*/

  getVendorCount(BuildContext context, String ownerid) async {
    var myjson = {
      "DSQID": Weburl.DSQ_landlord_VendorList,
      "Reqtokens": {
        "Owner_ID": ownerid,
      },
      "LoadLookUpValues": false,
      "LoadRecordInfo": false,
    };

    String json = jsonEncode(myjson);

    Helper.Log("getVendorCount", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        int count = data['TotalRecords'] != null ? data['TotalRecords'] : 0;

        _store.dispatch(UpdateLLVendor_status_TotalVendor(count));
      } else {
        _store.dispatch(UpdateLLVendor_status_TotalVendor(0));
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getVendorList(BuildContext context, String json, int ftime) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    Helper.Log("getVendorList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<VendorData> vendorDatalist = <VendorData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          VendorData vendorData = new VendorData();

          vendorData.id = myobject['ID'] != null ? myobject['ID'] : 0;

          vendorData.province = myobject['Province'] != null
              ? StateData.fromJson(myobject['Province'])
              : null;

          vendorData.country = myobject['Country'] != null
              ? CountryData.fromJson(myobject['Country'])
              : null;

          vendorData.companyName = myobject['CompanyName'] != null
              ? myobject['CompanyName'].toString()
              : "";
          vendorData.address =
              myobject['Address'] != null ? myobject['Address'].toString() : "";
          vendorData.rating =
              myobject['Rating'] != null ? myobject['Rating'] : 0;
          vendorData.suite =
              myobject['Suite'] != null ? myobject['Suite'].toString() : "";
          vendorData.PostalCode = myobject['PostalCode'] != null
              ? myobject['PostalCode'].toString()
              : "";
          vendorData.Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          vendorData.city = myobject['City'] != null
              ? CityData.fromJson(myobject['City'])
              : null;

          if (myobject['PersonID'] != null) {
            var PersonIDobj = myobject['PersonID'];

            vendorData.PersonID =
                PersonIDobj['ID'] != null ? PersonIDobj['ID'] : 0;

            vendorData.firstName = PersonIDobj['FirstName'] != null
                ? PersonIDobj['FirstName'].toString()
                : "";
            vendorData.lastName = PersonIDobj['LastName'] != null
                ? PersonIDobj['LastName'].toString()
                : "";
            vendorData.email = PersonIDobj['Email'] != null
                ? PersonIDobj['Email'].toString()
                : "";
            vendorData.mobileNumber = PersonIDobj['MobileNumber'] != null
                ? PersonIDobj['MobileNumber'].toString()
                : "";

            vendorData.Country_Code = PersonIDobj['Country_Code'] != null
                ? PersonIDobj['Country_Code'].toString()
                : "CA";

            vendorData.Dial_Code = PersonIDobj['Dial_Code'] != null
                ? PersonIDobj['Dial_Code'].toString()
                : "+91";
          }

          vendorData.category = myobject['Category'] != null
              ? SystemEnumDetails.fromJson(myobject['Category'])
              : null;

          //vendorData.category = null;

          vendorData.showInstruction = false;

          vendorDatalist.add(vendorData);
        }

        if (ftime == 0) {
          if (vendorDatalist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateLLVendor_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store.dispatch(UpdateLLVendor_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store.dispatch(UpdateLLVendor_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateLLVendor_totalpage(1));
          }
          _store.dispatch(UpdateLLVendor_pageNo(1));
        }

        _store.dispatch(UpdateLLVendor_isloding(false));
        _store.dispatch(UpdateLL_vendordatalist(vendorDatalist));
      } else {
        _store.dispatch(UpdateLLVendor_totalpage(0));
        _store.dispatch(UpdateLLVendor_totalRecord(0));
        _store.dispatch(UpdateLLVendor_pageNo(1));
        _store.dispatch(UpdateLLVendor_isloding(false));
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getAllVendorListCSV(BuildContext context, String json) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    /* var myjson = {
      "DSQID": Weburl.DSQ_landlord_VendorList,
      "Reqtokens": {"Owner_ID": ownerid, "Name": ""},
      "LoadLookUpValues": true,
      "LoadRecordInfo": false,
      "Sort": [
        {"FieldID": "ID", "SortSequence": 0}
      ]
    };

    String json = jsonEncode(myjson);*/

    Helper.Log("getVendorList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          String csv;
          List<List<dynamic>> csvList = [];

          List csvHeaderTitle = [];
          csvHeaderTitle.add("ID");
          csvHeaderTitle.add(GlobleString.LMV_CompanyName);
          csvHeaderTitle.add(GlobleString.LMV_ContactName);
          csvHeaderTitle.add(GlobleString.LMV_Email);
          csvHeaderTitle.add(GlobleString.LMV_Phone);
          csvHeaderTitle.add(GlobleString.LMV_Category);
          csvHeaderTitle.add(GlobleString.LMV_Rating);

          csvHeaderTitle.add(GlobleString.LMV_CompanyAddress);
          csvHeaderTitle.add(GlobleString.LMV_suit);
          csvHeaderTitle.add(GlobleString.LMV_PostalCode);
          csvHeaderTitle.add(GlobleString.LMV_City);
          csvHeaderTitle.add(GlobleString.LMV_State);
          csvHeaderTitle.add(GlobleString.LMV_Country);
          csvHeaderTitle.add(GlobleString.LMV_Note);

          csvList.add(csvHeaderTitle);

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            VendorData vendorData = new VendorData();

            vendorData.id = myobject['ID'] != null ? myobject['ID'] : 0;

            vendorData.province = myobject['Province'] != null
                ? StateData.fromJson(myobject['Province'])
                : null;

            vendorData.country = myobject['Country'] != null
                ? CountryData.fromJson(myobject['Country'])
                : null;

            vendorData.companyName = myobject['CompanyName'] != null
                ? myobject['CompanyName'].toString()
                : "";
            vendorData.address = myobject['Address'] != null
                ? myobject['Address'].toString()
                : "";
            vendorData.rating =
                myobject['Rating'] != null ? myobject['Rating'] : 0;
            vendorData.suite =
                myobject['Suite'] != null ? myobject['Suite'].toString() : "";
            vendorData.PostalCode = myobject['PostalCode'] != null
                ? myobject['PostalCode'].toString()
                : "";
            vendorData.Note =
                myobject['Note'] != null ? myobject['Note'].toString() : "";

            vendorData.city = myobject['City'] != null
                ? CityData.fromJson(myobject['City'])
                : null;

            if (myobject['PersonID'] != null) {
              var PersonIDobj = myobject['PersonID'];

              vendorData.PersonID =
                  PersonIDobj['ID'] != null ? PersonIDobj['ID'] : 0;

              vendorData.firstName = PersonIDobj['FirstName'] != null
                  ? PersonIDobj['FirstName'].toString()
                  : "";
              vendorData.lastName = PersonIDobj['LastName'] != null
                  ? PersonIDobj['LastName'].toString()
                  : "";
              vendorData.email = PersonIDobj['Email'] != null
                  ? PersonIDobj['Email'].toString()
                  : "";
              vendorData.mobileNumber = PersonIDobj['MobileNumber'] != null
                  ? PersonIDobj['MobileNumber'].toString()
                  : "";

              vendorData.Country_Code = PersonIDobj['Country_Code'] != null
                  ? PersonIDobj['Country_Code'].toString()
                  : "CA";

              vendorData.Dial_Code = PersonIDobj['Dial_Code'] != null
                  ? PersonIDobj['Dial_Code'].toString()
                  : "+91";
            }

            vendorData.category = myobject['Category'] != null
                ? SystemEnumDetails.fromJson(myobject['Category'])
                : null;

            vendorData.showInstruction = false;

            List row = [];
            row.add(vendorData.id);
            row.add(vendorData.companyName);
            row.add(vendorData.firstName! + " " + vendorData.lastName!);
            row.add(vendorData.email);
            row.add(vendorData.mobileNumber);
            row.add(vendorData.category != null
                ? vendorData.category!.displayValue
                : "");
            row.add(vendorData.rating);
            row.add(vendorData.address);
            row.add(vendorData.suite);
            row.add(vendorData.PostalCode);
            row.add(vendorData.city != null ? vendorData.city!.CityName : "");
            row.add(vendorData.province != null
                ? vendorData.province!.StateName
                : "");
            row.add(vendorData.country != null
                ? vendorData.country!.CountryName
                : "");
            row.add(vendorData.Note);
            csvList.add(row);
          }

          csv = const ListToCsvConverter().convert(csvList);

          String filename = "Vendor" +
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
          ToastUtils.showCustomToast(
              context, GlobleString.Blank_Landloadview, false);
        }

        loader.remove();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getVendorDetails(
      BuildContext context, String vid, CallBackVendorData callBack) {
    var myjson = {
      "DSQID": Weburl.DSQ_Vendor_Details,
      "Reqtokens": {"ID": vid},
      "LoadLookUpValues": true
    };

    String json = jsonEncode(myjson);

    Helper.Log("duplicateVendorworkflow", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        VendorData vendorData = new VendorData();

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          vendorData.id = myobject['ID'] != null ? myobject['ID'] : 0;

          vendorData.province = myobject['Province'] != null
              ? StateData.fromJson(myobject['Province'])
              : null;

          vendorData.country = myobject['Country'] != null
              ? CountryData.fromJson(myobject['Country'])
              : null;

          vendorData.companyName = myobject['CompanyName'] != null
              ? myobject['CompanyName'].toString()
              : "";
          vendorData.address =
              myobject['Address'] != null ? myobject['Address'].toString() : "";
          vendorData.rating =
              myobject['Rating'] != null ? myobject['Rating'] : 0;
          vendorData.suite =
              myobject['Suite'] != null ? myobject['Suite'].toString() : "";
          vendorData.PostalCode = myobject['PostalCode'] != null
              ? myobject['PostalCode'].toString()
              : "";
          vendorData.Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          vendorData.city = myobject['City'] != null
              ? CityData.fromJson(myobject['City'])
              : null;

          if (myobject['PersonID'] != null) {
            var PersonIDobj = myobject['PersonID'];

            vendorData.PersonID =
                PersonIDobj['ID'] != null ? PersonIDobj['ID'] : 0;

            vendorData.firstName = PersonIDobj['FirstName'] != null
                ? PersonIDobj['FirstName'].toString()
                : "";
            vendorData.lastName = PersonIDobj['LastName'] != null
                ? PersonIDobj['LastName'].toString()
                : "";
            vendorData.email = PersonIDobj['Email'] != null
                ? PersonIDobj['Email'].toString()
                : "";
            vendorData.mobileNumber = PersonIDobj['MobileNumber'] != null
                ? PersonIDobj['MobileNumber'].toString()
                : "";

            vendorData.Country_Code = PersonIDobj['Country_Code'] != null
                ? PersonIDobj['Country_Code'].toString()
                : "CA";

            vendorData.Dial_Code = PersonIDobj['Dial_Code'] != null
                ? PersonIDobj['Dial_Code'].toString()
                : "+91";
          }

          vendorData.category = myobject['Category'] != null
              ? SystemEnumDetails.fromJson(myobject['Category'])
              : null;

          //vendorData.category = null;

          vendorData.showInstruction = false;
        }
        callBack(true, "", vendorData);
      } else {
        callBack(false, respoce, new VendorData());
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  duplicateVendorworkflow(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.workflow_landlord_Vendor_Duplicate,
      "Reqtokens": {
        "Vendor_ID": id,
        "Owner_ID": Prefs.getString(PrefsName.OwnerID),
      }
    };

    String json = jsonEncode(myjson);

    Helper.Log("duplicateVendorworkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        String vid = data['Result'] != null ? data['Result'].toString() : "";

        Helper.Log("duplicateVendorworkflow", respoce);
        callBackQuesy(true, vid);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  getCityWiseVendorList(
      BuildContext context, String id, CallBackVendorDatalist callback) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_City_Wise_VendorList,
      "Reqtokens": {"City": id, "ID": Prefs.getString(PrefsName.OwnerID)},
      "LoadLookUpValues": true,
    };

    String json = jsonEncode(myjson);

    Helper.Log("getCityWiseVendorList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        Helper.Log("getCityWiseVendorList Responce", respoce);
        //loader.remove();
        var data = jsonDecode(respoce);

        List<VendorData> vendorDatalist = <VendorData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          VendorData vendorData = new VendorData();

          vendorData.id = myobject['ID'] != null ? myobject['ID'] : 0;

          vendorData.province = myobject['Province'] != null
              ? StateData.fromJson(myobject['Province'])
              : null;

          vendorData.country = myobject['Country'] != null
              ? CountryData.fromJson(myobject['Country'])
              : null;

          vendorData.companyName = myobject['CompanyName'] != null
              ? myobject['CompanyName'].toString()
              : "";
          vendorData.address =
              myobject['Address'] != null ? myobject['Address'].toString() : "";
          vendorData.rating =
              myobject['Rating'] != null ? myobject['Rating'] : 0;
          vendorData.suite =
              myobject['Suite'] != null ? myobject['Suite'].toString() : "";
          vendorData.PostalCode = myobject['PostalCode'] != null
              ? myobject['PostalCode'].toString()
              : "";
          vendorData.Note =
              myobject['Note'] != null ? myobject['Note'].toString() : "";

          vendorData.city = myobject['City'] != null
              ? CityData.fromJson(myobject['City'])
              : null;

          if (myobject['PersonID'] != null) {
            var PersonIDobj = myobject['PersonID'];

            vendorData.PersonID =
                PersonIDobj['ID'] != null ? PersonIDobj['ID'] : 0;

            vendorData.firstName = PersonIDobj['FirstName'] != null
                ? PersonIDobj['FirstName'].toString()
                : "";
            vendorData.lastName = PersonIDobj['LastName'] != null
                ? PersonIDobj['LastName'].toString()
                : "";
            vendorData.email = PersonIDobj['Email'] != null
                ? PersonIDobj['Email'].toString()
                : "";
            vendorData.mobileNumber = PersonIDobj['MobileNumber'] != null
                ? PersonIDobj['MobileNumber'].toString()
                : "";

            vendorData.Country_Code = PersonIDobj['Country_Code'] != null
                ? PersonIDobj['Country_Code'].toString()
                : "CA";

            vendorData.Dial_Code = PersonIDobj['Dial_Code'] != null
                ? PersonIDobj['Dial_Code'].toString()
                : "+91";
          }

          vendorData.category = myobject['Category'] != null
              ? SystemEnumDetails.fromJson(myobject['Category'])
              : null;

          //vendorData.category = null;

          vendorData.showInstruction = false;

          vendorDatalist.add(vendorData);
        }

        callback(true, "", vendorDatalist);
      } else {
        callback(false, "", []);
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  InsetNewVendor(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().InsertQuery(POJO, etableName.Vendor,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().insertAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, "");
      } else {
        CallBackQuesy(false, "");
      }
    });
  }

  EditVendor(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().UpdateQuery(CPOJO, UpPOJO, etableName.Vendor,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        //String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, "");
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  deleteVendorAPI(
      BuildContext context, Object POJO, CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().DeleteQuery(POJO, etableName.Vendor,
        eConjuctionClause().AND, eRelationalOperator().EqualTo);

    HttpClientCall().deleteAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

/*==========================================================================*/
/*======================== Basic Tenant Module ==========================*/
/*==========================================================================*/

  landlord_ProfileDSQCall(BuildContext context, String UserID,
      CallBackLandlordProfile CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_User_ProfileDetails.toString(),
      "LoadLookupValues": true,
      "Reqtokens": {"ID": UserID}
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        LandlordProfile landlordProfile = new LandlordProfile();

        Helper.Log("userProfileDSQCall", respoce);

        var rest = data["Result"] as List;

        String ID = rest[0]["ID"] != null ? rest[0]["ID"].toString() : "";

        String CompanyName = rest[0]["CompanyName"] != null
            ? rest[0]["CompanyName"].toString()
            : "";

        String HomePageLink = rest[0]["HomePageLink"] != null
            ? rest[0]["HomePageLink"].toString()
            : "";

        String CustomerFeatureListingURL =
            rest[0]['CustomerFeatureListingURL'] != null
                ? rest[0]['CustomerFeatureListingURL']
                : "";

        MediaInfo? Company_logo = rest[0]['Company_logo'] != null
            ? MediaInfo.fromJson(rest[0]['Company_logo'])
            : null;

        var PersonID = rest[0]["PersonID"];

        String pID = PersonID['ID'] != null ? PersonID['ID'].toString() : "";
        String Email =
            PersonID['Email'] != null ? PersonID['Email'].toString() : "";
        String FirstName = PersonID['FirstName'] != null
            ? PersonID['FirstName'].toString()
            : "";
        String LastName =
            PersonID['LastName'] != null ? PersonID['LastName'].toString() : "";
        String Country_Code =
            PersonID['Country_Code'] != null && PersonID['Country_Code'] != ""
                ? PersonID['Country_Code'].toString()
                : "CA";
        String Dial_Code =
            PersonID['Dial_Code'] != null && PersonID['Dial_Code'] != ""
                ? PersonID['Dial_Code'].toString()
                : "+1";
        String MobileNumber = PersonID['MobileNumber'] != null
            ? PersonID['MobileNumber'].toString()
            : "";

        landlordProfile.id = ID;
        landlordProfile.companyname = CompanyName;
        landlordProfile.homepagelink = HomePageLink;
        landlordProfile.CustomerFeatureListingURL = CustomerFeatureListingURL;
        landlordProfile.companylogo = Company_logo;
        landlordProfile.PersonID = pID;
        landlordProfile.firstname = FirstName;
        landlordProfile.lastname = LastName;
        landlordProfile.email = Email;
        landlordProfile.phonenumber = MobileNumber;
        landlordProfile.countrycode = Country_Code;
        landlordProfile.dialcode = Dial_Code;

        CallBackQuesy(true, "", landlordProfile);
      } else {
        CallBackQuesy(false, respoce, null);
      }
    });
  }

  TenantLoginApi(BuildContext context, String email, String password,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "Email": email,
      "Password": password,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().Login(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("responce", respoce);

        var responce = jsonDecode(respoce);
        var result = responce['Result'];
        var Token = result['Token'];

        Helper.Log("Token", Token);
        await Prefs.setString(PrefsName.userTokan, Token);

        var user = result['user'];
        var Attributes = user['Attributes'];
        var Id = Attributes['Id'];

        CallBackQuesy(true, Id.toString());
      } else {
        Helper.Log("LoginApi respoce", respoce);

        CallBackQuesy(false, respoce);
      }
    });
  }

  tenantRegisterWorkflow(
      BuildContext context,
      String email,
      String id,
      String Company_logo,
      String Link,
      String Tenant_FirstName,
      String Lan_FirstName,
      String Lan_LastName,
      String CompanyName,
      CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.workflow_tenant_register,
      "Reqtokens": {
        "ToEmail": email,
        "Person_ID": id,
        "Company_logo": Company_logo,
        "Link": Link,
        "Tenant_FirstName": Tenant_FirstName,
        "Lan_FirstName": Lan_FirstName,
        "Lan_LastName": Lan_LastName,
        "CompanyName": CompanyName,
      }
    };

    String json = jsonEncode(myjson);

    Helper.Log("tenantRegisterWorkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        Helper.Log("duplicateVendorworkflow", respoce);
        callBackQuesy(true, respoce);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  UpdateUserIdApplicant(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy callBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Applicant,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        callBackQuesy(true, Result);
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  CompanyDetailsDSQCall(BuildContext context, String CustomerFeatureListingURL,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_UserLogin.toString(),
      "LoadLookupValues": true,
      "Reqtokens": {"CustomerFeatureListingURL": CustomerFeatureListingURL}
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("userLoginDSQCall", respoce);

        var data = jsonDecode(respoce);
        //var rest = data["Result"] as List;
        if (data["Result"].length > 0) {
          var myobject = data["Result"][0];

          bool IsActive =
              myobject["IsActive"] != null ? myobject["IsActive"] : false;

          bool adminsideIsActive = myobject["AdminsideIsActive"] != null
              ? myobject["AdminsideIsActive"]
              : false;

          if (IsActive) {
            if (adminsideIsActive) {
              var ID = myobject["ID"].toString();

              String CustomerFeatureListingURL =
                  myobject['CustomerFeatureListingURL'] != null
                      ? myobject['CustomerFeatureListingURL'].toString()
                      : "";

              String CompanyName = myobject['CompanyName'] != null
                  ? myobject['CompanyName'].toString()
                  : "";

              String HomePageLink = myobject['HomePageLink'] != null
                  ? myobject['HomePageLink'].toString()
                  : "";

              String UserName = myobject['UserName'] != null
                  ? myobject['UserName'].toString()
                  : "";

              MediaInfo? Company_logo = myobject['Company_logo'] != null
                  ? MediaInfo.fromJson(myobject['Company_logo'])
                  : null;

              if (Company_logo != null && Company_logo.id != null) {
                await Prefs.setString(
                    PrefsName.BT_CompanyLogoid, Company_logo.id.toString());
                await Prefs.setString(
                    PrefsName.BT_CompanyLogoURL, Company_logo.url.toString());
              }

              await Prefs.setString(PrefsName.BT_CustomerFeatureListingURL,
                  CustomerFeatureListingURL);
              await Prefs.setString(PrefsName.BT_CompanyName, CompanyName);
              await Prefs.setString(PrefsName.BT_CompanyLink, HomePageLink);

              CallBackQuesy(true, "");
            } else {
              CallBackQuesy(false, "2");
            }
          } else {
            CallBackQuesy(false, "1");
          }
        } else {
          CallBackQuesy(false, "3");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  tenant_Details_DSQCall(
      BuildContext context, String json, CallBackQuesy CallBackQuesy) async {
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("tenant_Details_DSQCall", respoce);

        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        if (data["Result"].length > 0) {
          int ID = rest[0]["ID"] != null ? rest[0]["ID"] : 0;
          int Person_ID =
              rest[0]["Person_ID_ID"] != null ? rest[0]["Person_ID_ID"] : 0;

          String UserID = rest[0]["UserID"] != null ? rest[0]["UserID"] : "0";
          String FirstName = rest[0]["Person_ID_FirstName"] != null
              ? rest[0]["Person_ID_FirstName"]
              : "";
          String Email = rest[0]["Person_ID_Email"] != null
              ? rest[0]["Person_ID_Email"]
              : "";
          String LastName = rest[0]["Person_ID_LastName"] != null
              ? rest[0]["Person_ID_LastName"]
              : "";
          String MobileNumber = rest[0]["Person_ID_MobileNumber"] != null
              ? rest[0]["Person_ID_MobileNumber"]
              : "";
          String Country_Code = rest[0]["Person_ID_Country_Code"] != null
              ? rest[0]["Person_ID_Country_Code"]
              : "CA";
          String Dial_Code = rest[0]["Person_ID_Dial_Code"] != null
              ? rest[0]["Person_ID_Dial_Code"]
              : "+1";

          await Prefs.setString(PrefsName.BT_UserID, UserID);
          await Prefs.setString(PrefsName.BT_ApplicantID, ID.toString());
          await Prefs.setString(PrefsName.BT_PersonID, Person_ID.toString());
          await Prefs.setString(PrefsName.BT_Email, Email);
          await Prefs.setString(PrefsName.BT_fname, FirstName);
          await Prefs.setString(PrefsName.BT_lname, LastName);
          await Prefs.setString(PrefsName.BT_phoneno, MobileNumber);
          await Prefs.setString(PrefsName.BT_Country_Code, Country_Code);
          await Prefs.setString(PrefsName.BT_Dial_Code, Dial_Code);

          CallBackQuesy(true, "");
        } else {
          CallBackQuesy(false, "");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  getApplicationByApplicant(BuildContext context, String ApplicantID,
      CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_Application_by_Applicant.toString(),
      "LoadLookupValues": true,
      "Reqtokens": {"Applicant_ID": ApplicantID}
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("getApplicationByApplicant", respoce);

        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        if (data["Result"].length > 0) {
          int Owner_ID = rest[0]["Owner_ID"] != null ? rest[0]["Owner_ID"] : 0;
          int ID = rest[0]["ID"] != null ? rest[0]["ID"] : 0;

          //int ApplicationStatus = rest[0]["ApplicationStatus"] != null ? rest[0]["ApplicationStatus"] : 0;
          int IsArchived =
              rest[0]["IsArchived"] != null ? rest[0]["IsArchived"] : 0;

          SystemEnumDetails? ApplicationStatus =
              rest[0]["ApplicationStatus"] != null
                  ? SystemEnumDetails.fromJson(rest[0]["ApplicationStatus"])
                  : null;

          if ((ApplicationStatus != null &&
                  ApplicationStatus.EnumDetailID == 6) &&
              IsArchived == 0) {
            await Prefs.setBool(PrefsName.BT_Is_login, true);

            if (rest[0]['Prop_ID'] != null) {
              var Prop_IDobj = rest[0]['Prop_ID'];

              String ID = Prop_IDobj["ID"] != null ? Prop_IDobj["ID"] : "";
              String PropertyName = Prop_IDobj["PropertyName"] != null
                  ? Prop_IDobj["PropertyName"]
                  : "";
              String Property_Address = Prop_IDobj["Property_Address"] != null
                  ? Prop_IDobj["Property_Address"]
                  : "";
              String Postal_Code = Prop_IDobj["Postal_Code"] != null
                  ? Prop_IDobj["Postal_Code"]
                  : "";
              String City =
                  Prop_IDobj["City"] != null ? Prop_IDobj["City"] : "";
              String Country =
                  Prop_IDobj["Country"] != null ? Prop_IDobj["Country"] : "";
              String Suite_Unit = Prop_IDobj["Suite_Unit"] != null
                  ? Prop_IDobj["Suite_Unit"]
                  : "";
              String Province =
                  Prop_IDobj["Province"] != null ? Prop_IDobj["Province"] : "";

              String address =
                  (Suite_Unit.isNotEmpty ? Suite_Unit + " - " : "") +
                      Property_Address +
                      ", " +
                      City +
                      ", " +
                      Province +
                      ", " +
                      Country +
                      ", " +
                      Postal_Code;

              await Prefs.setString(PrefsName.BT_PropID, ID.toString());
              await Prefs.setString(
                  PrefsName.BT_PropName, PropertyName.toString());
              await Prefs.setString(
                  PrefsName.BT_PropAddress, address.toString());

              if (Prop_IDobj["Owner_ID"] != null) {
                var Owner_IDobj = Prop_IDobj["Owner_ID"];

                String OwID = Owner_IDobj['ID'] != null
                    ? Owner_IDobj['ID'].toString()
                    : "";
                String CompanyName = Owner_IDobj['CompanyName'] != null
                    ? Owner_IDobj['CompanyName'].toString()
                    : "";

                var PersonIDobj = Owner_IDobj["PersonID"];

                String Email = PersonIDobj['Email'] != null
                    ? PersonIDobj['Email'].toString()
                    : "";
                String FirstName = PersonIDobj['FirstName'] != null
                    ? PersonIDobj['FirstName'].toString()
                    : "";
                String LastName = PersonIDobj['LastName'] != null
                    ? PersonIDobj['LastName'].toString()
                    : "";
                String MobileNumber = PersonIDobj['MobileNumber'] != null
                    ? PersonIDobj['MobileNumber'].toString()
                    : "";
                String Dial_Code = PersonIDobj['Dial_Code'] != null
                    ? PersonIDobj['Dial_Code'].toString()
                    : "";

                await Prefs.setString(PrefsName.BT_OwnerID, OwID);
                await Prefs.setString(
                    PrefsName.BT_Owner_name, (FirstName + " " + LastName));
                await Prefs.setString(PrefsName.BT_Owner_email, Email);
                await Prefs.setString(
                    PrefsName.BT_Owner_phoneno, (Dial_Code + MobileNumber));
                await Prefs.setString(
                    PrefsName.BT_Owner_Companyname, CompanyName);
              }
            } else {
              await Prefs.setString(PrefsName.BT_PropID, "");
              await Prefs.setString(PrefsName.BT_PropName, "");
              await Prefs.setString(PrefsName.BT_PropAddress, "");
            }

            await Prefs.setString(PrefsName.BT_OwnerID, Owner_ID.toString());
            await Prefs.setString(PrefsName.BT_ApplicationId, ID.toString());

            CallBackQuesy(true, "");
          } else {
            CallBackQuesy(false, "1");
          }
        } else {
          CallBackQuesy(false, "");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  getTenantMaintenaceList(BuildContext context, String json, int ftime) async {
    /*loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    Helper.Log("getTenantMaintenaceList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);

        List<MaintenanceData> maintenanceDatalist = <MaintenanceData>[];

        for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          MaintenanceData maintenanceData = new MaintenanceData();

          maintenanceData.ID =
              myobject['ID'] != null ? myobject['ID'].toString() : "";

          maintenanceData.RequestName = myobject['RequestName'] != null
              ? myobject['RequestName'].toString()
              : "";
          maintenanceData.Date_Created = myobject['Date_Created'] != null
              ? myobject['Date_Created'].toString()
              : "";

          maintenanceData.CreatedBy = myobject['CreatedBy'] != null
              ? myobject['CreatedBy'].toString()
              : "";

          maintenanceData.IsLock =
              myobject['IsLock'] != null ? myobject['IsLock'] : false;
          maintenanceData.Describe_Issue = myobject['Describe_Issue'] != null
              ? myobject['Describe_Issue'].toString()
              : "";
          maintenanceData.Type_User = myobject['Type_User'] != null
              ? myobject['Type_User'].toString()
              : "1";

          if (myobject['Owner_ID'] != null) {
            var Owner_IDobj = myobject['Owner_ID'];

            var OPersonID = Owner_IDobj['PersonID'];

            maintenanceData.Owner_ID =
                Owner_IDobj['ID'] != null ? Owner_IDobj['ID'].toString() : "";
            String FirstName = OPersonID['FirstName'] != null
                ? OPersonID['FirstName'].toString()
                : "";
            String LastName = OPersonID['LastName'] != null
                ? OPersonID['LastName'].toString()
                : "";

            maintenanceData.OwnerName = FirstName + " " + LastName;
          }

          if (myobject['Applicant_ID'] != null) {
            var Applicant_IDobj = myobject['Applicant_ID'];

            var APersonID = Applicant_IDobj['Person_ID'];

            maintenanceData.Applicant_ID = Applicant_IDobj['ID'] != null
                ? Applicant_IDobj['ID'].toString()
                : "";
            String FirstName = APersonID['FirstName'] != null
                ? APersonID['FirstName'].toString()
                : "";
            String LastName = APersonID['LastName'] != null
                ? APersonID['LastName'].toString()
                : "";

            maintenanceData.ApplicantName = FirstName + " " + LastName;
          }

          if (myobject['Prop_ID'] != null) {
            var Prop_IDobj = myobject['Prop_ID'];

            maintenanceData.Prop_ID =
                Prop_IDobj['ID'] != null ? Prop_IDobj['ID'].toString() : "";
            maintenanceData.PropertyName = Prop_IDobj['PropertyName'] != null
                ? Prop_IDobj['PropertyName'].toString()
                : "";
          }

          maintenanceData.Category = myobject['Category'] != null
              ? SystemEnumDetails.fromJson(myobject['Category'])
              : null;

          maintenanceData.Status = myobject['Status'] != null
              ? SystemEnumDetails.fromJson(myobject['Status'])
              : null;

          maintenanceData.Priority = myobject['Priority'] != null
              ? SystemEnumDetails.fromJson(myobject['Priority'])
              : null;

          maintenanceDatalist.add(maintenanceData);
        }

        /* propertylist.sort((a, b) =>
            b.createdOn!.toLowerCase().compareTo(a.createdOn!.toLowerCase()));*/

        if (ftime == 0) {
          if (maintenanceDatalist.length > 0) {
            int TotalRecords =
                data['TotalRecords'] != null ? data['TotalRecords'] : 0;

            _store.dispatch(UpdateTenantMaintenance_totalRecord(TotalRecords));

            if (TotalRecords % 15 == 0) {
              int dept_totalpage = int.parse((TotalRecords / 15).toString());
              _store
                  .dispatch(UpdateTenantMaintenance_totalpage(dept_totalpage));
            } else {
              double page = (TotalRecords / 15);
              int dept_totalpage = (page + 1).toInt();
              _store
                  .dispatch(UpdateTenantMaintenance_totalpage(dept_totalpage));
            }
          } else {
            _store.dispatch(UpdateTenantMaintenance_totalpage(1));
          }
          _store.dispatch(UpdateTenantMaintenance_pageNo(1));
        }

        _store.dispatch(UpdateTenantMaintenance_isloding(false));
        _store.dispatch(UpdateTenant_maintenancedatalist(maintenanceDatalist));
      } else {
        _store.dispatch(UpdateTenantMaintenance_isloding(false));
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getTenantMaintenaceListCSV(BuildContext context, String json) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    Helper.Log("getTenantMaintenaceList", json);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          String csv;
          List<List<dynamic>> csvList = [];

          List csvHeaderTitle = [];
          csvHeaderTitle.add("ID");
          csvHeaderTitle.add(GlobleString.Mant_RequestName);
          csvHeaderTitle.add(GlobleString.Mant_Category);
          csvHeaderTitle.add(GlobleString.Mant_Priority);
          csvHeaderTitle.add(GlobleString.Mant_DateCreated);
          csvHeaderTitle.add(GlobleString.Mant_CreatedBy);
          csvHeaderTitle.add(GlobleString.Mant_Status);
          csvHeaderTitle.add(GlobleString.Mant_EditRights);

          csvList.add(csvHeaderTitle);

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            MaintenanceData maintenanceData = new MaintenanceData();

            maintenanceData.ID =
                myobject['ID'] != null ? myobject['ID'].toString() : "";

            maintenanceData.RequestName = myobject['RequestName'] != null
                ? myobject['RequestName'].toString()
                : "";
            maintenanceData.Date_Created = myobject['Date_Created'] != null
                ? myobject['Date_Created'].toString()
                : "";

            maintenanceData.CreatedBy = myobject['CreatedBy'] != null
                ? myobject['CreatedBy'].toString()
                : "";

            maintenanceData.IsLock =
                myobject['IsLock'] != null ? myobject['IsLock'] : false;
            maintenanceData.Describe_Issue = myobject['Describe_Issue'] != null
                ? myobject['Describe_Issue'].toString()
                : "";
            maintenanceData.Type_User = myobject['Type_User'] != null
                ? myobject['Type_User'].toString()
                : "1";

            if (myobject['Owner_ID'] != null) {
              var Owner_IDobj = myobject['Owner_ID'];

              var OPersonID = Owner_IDobj['PersonID'];

              maintenanceData.Owner_ID =
                  Owner_IDobj['ID'] != null ? Owner_IDobj['ID'].toString() : "";
              String FirstName = OPersonID['FirstName'] != null
                  ? OPersonID['FirstName'].toString()
                  : "";
              String LastName = OPersonID['LastName'] != null
                  ? OPersonID['LastName'].toString()
                  : "";

              maintenanceData.OwnerName = FirstName + " " + LastName;
            }

            if (myobject['Applicant_ID'] != null) {
              var Applicant_IDobj = myobject['Applicant_ID'];

              var APersonID = Applicant_IDobj['Person_ID'];

              maintenanceData.Applicant_ID = Applicant_IDobj['ID'] != null
                  ? Applicant_IDobj['ID'].toString()
                  : "";
              String FirstName = APersonID['FirstName'] != null
                  ? APersonID['FirstName'].toString()
                  : "";
              String LastName = APersonID['LastName'] != null
                  ? APersonID['LastName'].toString()
                  : "";

              maintenanceData.ApplicantName = FirstName + " " + LastName;
            }

            if (myobject['Prop_ID'] != null) {
              var Prop_IDobj = myobject['Prop_ID'];

              maintenanceData.Prop_ID =
                  Prop_IDobj['ID'] != null ? Prop_IDobj['ID'].toString() : "";
              maintenanceData.PropertyName = Prop_IDobj['PropertyName'] != null
                  ? Prop_IDobj['PropertyName'].toString()
                  : "";
            }

            maintenanceData.Category = myobject['Category'] != null
                ? SystemEnumDetails.fromJson(myobject['Category'])
                : null;

            maintenanceData.Status = myobject['Status'] != null
                ? SystemEnumDetails.fromJson(myobject['Status'])
                : null;

            maintenanceData.Priority = myobject['Priority'] != null
                ? SystemEnumDetails.fromJson(myobject['Priority'])
                : null;

            List row = [];

            row.add(maintenanceData.ID);
            row.add(maintenanceData.RequestName);
            row.add(maintenanceData.Category != null
                ? maintenanceData.Category!.displayValue
                : "");
            row.add(maintenanceData.Priority != null
                ? maintenanceData.Priority!.displayValue
                : "");
            row.add(maintenanceData.Date_Created != null &&
                    maintenanceData.Date_Created != "0" &&
                    maintenanceData.Date_Created != ""
                ? new DateFormat("dd-MMM-yyyy")
                    .format(DateTime.parse(maintenanceData.Date_Created!))
                    .toString()
                : "");
            row.add(maintenanceData.CreatedBy);
            row.add(maintenanceData.Status != null
                ? maintenanceData.Status!.displayValue
                : "");
            row.add(maintenanceData.IsLock != null
                ? maintenanceData.IsLock
                : false);

            csvList.add(row);
          }

          csv = const ListToCsvConverter().convert(csvList);

          String filename = "Tenant_Maintenance_Request" +
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
          ToastUtils.showCustomToast(
              context, GlobleString.Blank_Landloadview, false);
        }
        loader.remove();
      } else {
        loader.remove();
        _store.dispatch(UpdateTenantMaintenance_isloding(false));
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  getTenantDetailsDSQCall(
      BuildContext context, String UserID, CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_tenant_Details.toString(),
      "LoadLookupValues": true,
      "Reqtokens": {"UserID": UserID}
    };

    String json = jsonEncode(myjson);
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("tenant_Details_DSQCall", respoce);

        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        if (data["Result"].length > 0) {
          int ID = rest[0]["ID"] != null ? rest[0]["ID"] : 0;
          int Person_ID =
              rest[0]["Person_ID_ID"] != null ? rest[0]["Person_ID_ID"] : 0;

          String UserID = rest[0]["UserID"] != null ? rest[0]["UserID"] : "0";
          String FirstName = rest[0]["Person_ID_FirstName"] != null
              ? rest[0]["Person_ID_FirstName"]
              : "";
          String Email = rest[0]["Person_ID_Email"] != null
              ? rest[0]["Person_ID_Email"]
              : "";
          String LastName = rest[0]["Person_ID_LastName"] != null
              ? rest[0]["Person_ID_LastName"]
              : "";
          String MobileNumber = rest[0]["Person_ID_MobileNumber"] != null
              ? rest[0]["Person_ID_MobileNumber"]
              : "";
          String Country_Code = rest[0]["Person_ID_Country_Code"] != null
              ? rest[0]["Person_ID_Country_Code"]
              : "CA";
          String Dial_Code = rest[0]["Person_ID_Dial_Code"] != null
              ? rest[0]["Person_ID_Dial_Code"]
              : "+1";

          MediaInfo? profile = rest[0]['profile'] != null
              ? MediaInfo.fromJson(rest[0]['profile'])
              : null;

          await Prefs.setString(PrefsName.BT_Email, Email);
          await Prefs.setString(PrefsName.BT_fname, FirstName);
          await Prefs.setString(PrefsName.BT_lname, LastName);
          await Prefs.setString(PrefsName.BT_phoneno, MobileNumber);
          await Prefs.setString(PrefsName.BT_Country_Code, Country_Code);
          await Prefs.setString(PrefsName.BT_Dial_Code, Dial_Code);

          _store.dispatch(UpdateTenantPersonal_perFirstname(FirstName));
          _store.dispatch(UpdateTenantPersonal_perLastname(LastName));
          _store.dispatch(UpdateTenantPersonal_perEmail(Email));
          _store.dispatch(UpdateTenantPersonal_perPhoneNumber(MobileNumber));
          _store.dispatch(UpdateTenantPersonal_perCountryCode(Country_Code));
          _store.dispatch(UpdateTenantPersonal_perDialCode(Dial_Code));
          _store.dispatch(UpdateTenantPersonal_propertyImage(profile));
          _store.dispatch(UpdateTenantPersonal_appimage(null));

          CallBackQuesy(true, "");
        } else {
          CallBackQuesy(false, "");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  UpdateTenantProfileData(BuildContext context, Object CPOJO, Object UpPOJO,
      CallBackQuesy CallBackQuesy) {
    String query = QueryFilter().UpdateQuery(
        CPOJO,
        UpPOJO,
        etableName.Applicant,
        eConjuctionClause().AND,
        eRelationalOperator().EqualTo);

    HttpClientCall().updateAPICall(context, query, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        String Result = data['Result'] != null ? data['Result'].toString() : "";
        CallBackQuesy(true, Result);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  ChangePasswordAPI(BuildContext context, String email, String curpassword,
      String newpassword, CallBackQuesy CallBackQuesy) async {
    var myjson = {
      "Email": email,
      "CurrentPassword": curpassword,
      "NewPassword": newpassword,
    };

    String json = jsonEncode(myjson);

    HttpClientCall().ChangePassword(context, json, (error, respoce) async {
      if (error) {
        var responce = jsonDecode(respoce);
        CallBackQuesy(true, respoce);
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }

  clear_Tenant_LeaseState() {
    _store.dispatch(Update_BtLease_lanOwnerId(""));
    _store.dispatch(Update_BtLease_lan_name(""));
    _store.dispatch(Update_BtLease_lan_email(""));
    _store.dispatch(Update_BtLease_lan_phoneno(""));
    _store.dispatch(Update_BtLease_lan_Companyname(""));
    _store.dispatch(Update_BtLease_lan_Companyemail(""));

    _store.dispatch(Update_BtLease_ProperTytypeValue(null));
    _store.dispatch(Update_BtLease_PropertyTypeOtherValue(""));

    _store.dispatch(Update_BtLease_Dateofavailable(null));
    _store.dispatch(Update_BtLease_RentalSpaceValue(null));
    _store.dispatch(Update_BtLease_PropertyName(""));
    _store.dispatch(Update_BtLease_PropertyAddress(""));
    _store.dispatch(Update_BtLease_PropertyDescription(""));
    _store.dispatch(Update_BtLease_Suiteunit(""));
    _store.dispatch(Update_BtLease_Buildingname(""));
    _store.dispatch(Update_BtLease_PropertyCity(""));
    _store.dispatch(Update_BtLease_PropertyCountryCode("CA"));
    _store.dispatch(Update_BtLease_PropertyCountryName(""));
    _store.dispatch(Update_BtLease_PropertyProvince(""));
    _store.dispatch(Update_BtLease_PropertyPostalcode(""));
    _store.dispatch(Update_BtLease_PropertyRentAmount(""));
    _store.dispatch(Update_BtLease_RentPaymentFrequencyValue(null));
    _store.dispatch(Update_BtLease_LeaseTypeValue(null));
    _store.dispatch(Update_BtLease_MinimumLeasedurationValue(null));
    _store.dispatch(Update_BtLease_MinimumleasedurationNumber(""));

    _store.dispatch(Update_BtLease_PropertyBedrooms(""));
    _store.dispatch(Update_BtLease_PropertyBathrooms(""));
    _store.dispatch(Update_BtLease_PropertySizeinsquarefeet(""));
    _store.dispatch(Update_BtLease_PropertyMaxoccupancy(""));
    _store.dispatch(Update_BtLease_FurnishingValue(null));
    _store.dispatch(Update_BtLease_OtherPartialFurniture(""));
    _store.dispatch(Update_BtLease_Parkingstalls(""));
    _store.dispatch(Update_BtLease_StorageAvailableValue(null));
    _store.dispatch(Update_BtLease_AgreeTCPP(false));
    _store.dispatch(Update_BtLease_PropertyDrafting(0));
    _store.dispatch(Update_BtLease_PropertyVacancy(false));

    _store.dispatch(Update_BtLease_MID(""));
    _store.dispatch(Update_BtLease_MediaDoc(null));
  }

  bindTenantPropertyData(PropertyData propertyData) {
    _store
        .dispatch(Update_BtLease_ProperTytypeValue(propertyData.propertyType));
    _store.dispatch(
        Update_BtLease_PropertyTypeOtherValue(propertyData.otherPropertyType!));

    DateTime tempDate = DateTime.parse(propertyData.dateAvailable!);

    _store.dispatch(Update_BtLease_Dateofavailable(tempDate));
    _store.dispatch(Update_BtLease_RentalSpaceValue(propertyData.rentalSpace));
    _store.dispatch(Update_BtLease_PropertyName(propertyData.propertyName!));
    _store.dispatch(
        Update_BtLease_PropertyAddress(propertyData.propertyAddress!));
    _store.dispatch(
        Update_BtLease_PropertyDescription(propertyData.propertyDescription!));
    _store.dispatch(Update_BtLease_Suiteunit(propertyData.suiteUnit!));
    _store.dispatch(Update_BtLease_Buildingname(propertyData.buildingName!));
    _store.dispatch(Update_BtLease_PropertyCity(propertyData.city!));
    _store.dispatch(
        Update_BtLease_PropertyCountryCode(propertyData.countryCode!));
    _store.dispatch(Update_BtLease_PropertyCountryName(propertyData.country!));
    _store.dispatch(Update_BtLease_PropertyProvince(propertyData.province!));
    _store
        .dispatch(Update_BtLease_PropertyPostalcode(propertyData.postalCode!));
    _store
        .dispatch(Update_BtLease_PropertyRentAmount(propertyData.rentAmount!));
    _store.dispatch(Update_BtLease_RentPaymentFrequencyValue(
        propertyData.rentPaymentFrequency));
    _store.dispatch(Update_BtLease_LeaseTypeValue(propertyData.leaseType));
    _store.dispatch(Update_BtLease_MinimumLeasedurationValue(
        propertyData.minLeaseDuration));
    _store.dispatch(Update_BtLease_MinimumleasedurationNumber(
        propertyData.minLeaseNumber.toString()));

    _store.dispatch(
        Update_BtLease_PropertyBedrooms(propertyData.bedrooms.toString()));
    _store.dispatch(
        Update_BtLease_PropertyBathrooms(propertyData.bathrooms.toString()));
    _store.dispatch(
        Update_BtLease_PropertySizeinsquarefeet(propertyData.size.toString()));
    _store.dispatch(
        Update_BtLease_PropertyMaxoccupancy(propertyData.maxOccupancy!));
    _store.dispatch(Update_BtLease_FurnishingValue(propertyData.furnishing));
    _store.dispatch(Update_BtLease_OtherPartialFurniture(
        propertyData.otherPartialFurniture.toString()));
    _store.dispatch(Update_BtLease_Parkingstalls(propertyData.parkingStalls!));
    _store.dispatch(
        Update_BtLease_StorageAvailableValue(propertyData.storageAvailable));
    _store.dispatch(Update_BtLease_AgreeTCPP(propertyData.isAgreedTandC!));
    _store
        .dispatch(Update_BtLease_PropertyDrafting(propertyData.PropDrafting!));
    _store.dispatch(Update_BtLease_PropertyVacancy(propertyData.Vacancy!));
  }

  TenantLeaseAgreement(
      BuildContext context, String id, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "DSQID": Weburl.DSQ_VIEW_LEASE_Document,
      "LoadLookupValues": true,
      "LoadChildren": false,
      "Reqtokens": {"Application_ID": id}
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'].length > 0) {
          for (int i = 0; i < data['Result'].length; i++) {
            var objectPropertyDocument = data['Result'][i];

            String ID = objectPropertyDocument['ID'] != null
                ? objectPropertyDocument['ID'].toString()
                : "";

            bool IsOwneruploaded =
                objectPropertyDocument['IsOwneruploaded'] != null
                    ? objectPropertyDocument['IsOwneruploaded']
                    : false;

            String Owner_ID = objectPropertyDocument['Owner_ID'] != null
                ? objectPropertyDocument['Owner_ID'].toString()
                : "";

            /*===============*/
            /*  Media Info */
            /*===============*/

            MediaInfo? mediaInfo = objectPropertyDocument['Media_ID'] != null
                ? MediaInfo.fromJson(objectPropertyDocument['Media_ID'])
                : null;

            if (!IsOwneruploaded) {
              _store.dispatch(Update_BtLease_MID(ID));
              _store.dispatch(Update_BtLease_MediaDoc(mediaInfo));
            }
          }
        } else {
          _store.dispatch(Update_BtLease_MID(""));
          _store.dispatch(Update_BtLease_MediaDoc(null));
        }
        callBackQuesy(true, "");
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  AddMaintenaceNotification(
      BuildContext context, List<Object> POJO, CallBackQuesy CallBackQuesy) {
    List<QueryObject> queryList = <QueryObject>[];

    Helper.Log("POJO", jsonEncode(POJO));

    for (int i = 0; i < POJO.length; i++) {
      String queryinsert = QueryFilter().InsertQuery(
          POJO[i],
          etableName.Notification,
          eConjuctionClause().AND,
          eRelationalOperator().EqualTo);

      var queryinsetdecode = jsonDecode(queryinsert);
      QueryObject insetquery = QueryObject.fromJson(queryinsetdecode);
      queryList.add(insetquery);
    }

    String json = jsonEncode(queryList);

    Helper.Log("AddMaintenaceNotification", json);

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

  getTenantNotificationList(BuildContext context, String id, int pageno,
      CallBackNotificationQuery callBackQuesy) async {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    var myjson = {
      "DSQID": Weburl.DSQ_Notification,
      "LoadLookUpValues": true,
      "Pager": {"PageNo": pageno, "NoOfRecords": 10},
      "Reqtokens": {"TypeOfNotification": "6,9,10", "Applicant_ID": id},

      /* "Sort": [
        {"FieldID": "NotificationDate", "SortSequence": 0},
        {"FieldID": "IsRead", "SortSequence": 0}
      ]*/
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);
        List<NotificationData> notificationlist = <NotificationData>[];

        if (data['Result'].length > 0) {
          /* notificationlist = (data['Result'] as List)
              .map((p) => NotificationData.fromJson(p))
              .toList();*/

          for (int i = 0; i < data['Result'].length; i++) {
            var myobject = data['Result'][i];

            NotificationData notification = new NotificationData();

            notification.id = myobject['ID'] != null ? myobject['ID'] : 0;
            notification.applicantName = myobject['ApplicantName'] != null
                ? myobject['ApplicantName'].toString()
                : "";
            notification.ownerId =
                myobject['Owner_ID'] != null ? myobject['Owner_ID'] : 0;
            notification.applicantId =
                myobject['Applicant_ID'] != null ? myobject['Applicant_ID'] : 0;
            notification.notificationDate = myobject['NotificationDate'] != null
                ? myobject['NotificationDate'].toString()
                : "";
            notification.isRead =
                myobject['IsRead'] != null ? myobject['IsRead'] : false;
            notification.typeOfNotification =
                myobject['TypeOfNotification'] != null
                    ? myobject['TypeOfNotification']
                    : 0;
            notification.MaintenanceID = myobject['MaintenanceID'] != null
                ? myobject['MaintenanceID']
                : 0;
            notification.applicationId = myobject['Application_ID'] != null
                ? myobject['Application_ID']
                : 0;

            if (myobject['Prop_ID'] != null) {
              var Prop_IDobject = myobject['Prop_ID'];

              notification.PropID = Prop_IDobject['ID'] != null
                  ? Prop_IDobject['ID'].toString()
                  : "";
              notification.propertyName = Prop_IDobject['PropertyName'] != null
                  ? Prop_IDobject['PropertyName'].toString()
                  : "";
              notification.suiteUnit = Prop_IDobject['Suite_Unit'] != null
                  ? Prop_IDobject['Suite_Unit'].toString()
                  : "";
            }
            notificationlist.add(notification);
          }
        }
        //loader.remove();
        callBackQuesy(true, notificationlist, "");
      } else {
        //loader.remove();
        callBackQuesy(false, <NotificationData>[], respoce);
      }
    });
  }

  NotificationCountTenant(BuildContext context) {
    var myjson = {
      "DSQID": Weburl.DSQ_Notification,
      "LoadLookUpValues": true,
      "Reqtokens": {
        "TypeOfNotification": "6,9,10",
        "Applicant_ID": Prefs.getString(PrefsName.BT_ApplicantID),
        "IsRead": false
      },
    };

    String json = jsonEncode(myjson);

    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        var data = jsonDecode(respoce);

        int TotalRecords =
            data['TotalRecords'] != null ? data['TotalRecords'] : 0;
        _store.dispatch(UpdateTenantPortalPage_notificationCount(TotalRecords));
      } else {
        _store.dispatch(UpdateTenantPortalPage_notificationCount(0));
      }
    });
  }

  Tenant_forgotpassWorkflow(BuildContext context, String email, String url,
      String DbAppCode, String CompanyLogo, CallBackQuesy callBackQuesy) async {
    var myjson = {
      "WorkFlowID": Weburl.WorkFlow_tenant_forgotpass,
      "Reqtokens": {
        "ToEmail": email,
        "HostURL": url,
        "DbAppCode": DbAppCode,
        "Company_logo": CompanyLogo
      }
      //"Reqtokens": {"UserID": "0D31C3A7-3934-43C2-B4AC-D445A067F561", "HostURL":url}
    };

    String json = jsonEncode(myjson);

    Helper.Log("Tenant_forgotpassWorkflow", json);

    HttpClientCall().WorkFlowExecuteAPICall(context, json, (error, respoce) {
      if (error) {
        var data = jsonDecode(respoce);

        if (data['Result'] != null && data['Result'].length > 0) {
          callBackQuesy(true, respoce);
        } else {
          callBackQuesy(false, "1");
        }
      } else {
        callBackQuesy(false, respoce);
      }
    });
  }

  getTenantEmail_DSQCall(
      BuildContext context, String json, CallBackQuesy CallBackQuesy) async {
    HttpClientCall().DSQAPICall(context, json, (error, respoce) async {
      if (error) {
        Helper.Log("tenant_Details_DSQCall", respoce);

        var data = jsonDecode(respoce);
        var rest = data["Result"] as List;

        if (data["Result"].length > 0) {
          int ID = rest[0]["ID"] != null ? rest[0]["ID"] : 0;
          int Person_ID =
              rest[0]["Person_ID_ID"] != null ? rest[0]["Person_ID_ID"] : 0;

          String UserID = rest[0]["UserID"] != null ? rest[0]["UserID"] : "0";
          String FirstName = rest[0]["Person_ID_FirstName"] != null
              ? rest[0]["Person_ID_FirstName"]
              : "";
          String Email = rest[0]["Person_ID_Email"] != null
              ? rest[0]["Person_ID_Email"]
              : "";
          String LastName = rest[0]["Person_ID_LastName"] != null
              ? rest[0]["Person_ID_LastName"]
              : "";
          String MobileNumber = rest[0]["Person_ID_MobileNumber"] != null
              ? rest[0]["Person_ID_MobileNumber"]
              : "";
          String Country_Code = rest[0]["Person_ID_Country_Code"] != null
              ? rest[0]["Person_ID_Country_Code"]
              : "CA";
          String Dial_Code = rest[0]["Person_ID_Dial_Code"] != null
              ? rest[0]["Person_ID_Dial_Code"]
              : "+1";

          CallBackQuesy(true, Email);
        } else {
          CallBackQuesy(false, "");
        }
      } else {
        CallBackQuesy(false, respoce);
      }
    });
  }
}

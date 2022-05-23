import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_leads_details_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';

class AdminTenancyDetails extends StatefulWidget {
  @override
  _AdminTenancyDetailsState createState() => _AdminTenancyDetailsState();
}

class _AdminTenancyDetailsState extends State<AdminTenancyDetails> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  double drawer_width = 230;
  double header_height = 70;
  double ssheight = 0, sswidth = 0;

  var font_medium, font_demi, font_regular, font_bold;

  @override
  void initState() {
    fontload();
    super.initState();
  }

  void fontload() async {
    font_medium = await rootBundle.load("assets/fonts/avenirnext-medium.ttf");
    font_demi = await rootBundle.load("assets/fonts/avenirnext-demi.ttf");
    font_regular = await rootBundle.load("assets/fonts/avenirnext-regular.ttf");
    font_bold = await rootBundle.load("assets/fonts/avenirnext-bold.ttf");
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      height: height - 90,
      width: width,
      color: myColor.white,
      child: SingleChildScrollView(
        child: Container(
          width: width,
          margin: EdgeInsets.only(right: 20, left: 20),
          child: ConnectState<AdminLandlordLeadsDetailsState>(
            map: (state) => state.adminLandlordLeadsDetailsState,
            where: notIdentical,
            builder: (AdminLLLeadDetailsState) {
              return Column(
                children: [
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(
                        top: 10, right: 10, left: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: width,
                            color: myColor.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (Prefs.getBool(
                                        PrefsName.Is_adminLandlord_lead)) {
                                      _store.dispatch(
                                          UpdateAdminPortalLandlordDetails(
                                              GlobleString
                                                  .NAV_admin_Landlords));
                                    } else if (Prefs.getBool(
                                        PrefsName.Is_adminLandlord_Property)) {
                                      _store.dispatch(
                                          UpdateAdminPortalLandlordDetails(
                                              GlobleString
                                                  .NAV_admin_Landlords));
                                    } else {
                                      _store.dispatch(UpdateAdminPortalPage(2,
                                          GlobleString.NAV_admin_LeadsTenants));
                                    }
                                  },
                                  child: Container(
                                    child: Text(
                                      GlobleString.TA_BACK,
                                      style: MyStyles.Bold(14, myColor.blue),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Pdfgenerate(AdminLLLeadDetailsState!);
                                  },
                                  child: Container(
                                    child: Text(
                                      GlobleString.TA_exportpdf,
                                      style: MyStyles.Bold(14, myColor.blue),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: width,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: width,
                            color: myColor.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: width,
                                  height: 60,
                                  color: myColor.TA_header,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    AdminLLLeadDetailsState!.perFirstname +
                                        " " +
                                        AdminLLLeadDetailsState.perLastname,
                                    style: MyStyles.Medium(25, myColor.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        margin: EdgeInsets.only(right: 10),
                                        elevation: 4,
                                        shadowColor: myColor.black,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: myColor.TA_Border,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        child: Container(
                                          height: 80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                GlobleString
                                                    .TA_box_Annual_income,
                                                style: MyStyles.Medium(
                                                    18, myColor.text_color),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                AdminLLLeadDetailsState
                                                            .anualincomestatus !=
                                                        null
                                                    ? AdminLLLeadDetailsState
                                                        .anualincomestatus!
                                                        .displayValue
                                                    : "None",
                                                style: MyStyles.Bold(
                                                    18, myColor.blue),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        margin:
                                            EdgeInsets.only(right: 5, left: 5),
                                        elevation: 4,
                                        shadowColor: myColor.black,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: myColor.TA_Border,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        child: Container(
                                          height: 80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                GlobleString
                                                    .TA_box_employment_status,
                                                style: MyStyles.Medium(
                                                    18, myColor.text_color),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                AdminLLLeadDetailsState
                                                            .empstatus !=
                                                        null
                                                    ? AdminLLLeadDetailsState
                                                        .empstatus!.displayValue
                                                    : "None",
                                                style: MyStyles.Bold(
                                                    18, myColor.blue),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        margin: EdgeInsets.only(left: 10),
                                        elevation: 4,
                                        shadowColor: myColor.black,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: myColor.TA_Border,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        child: Container(
                                          height: 80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                GlobleString.TA_box_AGE,
                                                style: MyStyles.Medium(
                                                    18, myColor.text_color),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                AdminLLLeadDetailsState.perAge,
                                                style: MyStyles.Bold(
                                                    18, myColor.blue),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                PersonalInfo(AdminLLLeadDetailsState),
                                SizedBox(
                                  height: 30,
                                ),
                                EmploymentInfo(AdminLLLeadDetailsState),
                                SizedBox(
                                  height: 30,
                                ),
                                CurrentTenancyInfo(AdminLLLeadDetailsState),
                                SizedBox(
                                  height: 30,
                                ),
                                CurrentlandlordInfo(AdminLLLeadDetailsState),
                                SizedBox(
                                  height: 30,
                                ),
                                AdditionalOccupantsInfo(
                                    AdminLLLeadDetailsState),
                                SizedBox(
                                  height: 30,
                                ),
                                AdditionalInformatiInfo(
                                    AdminLLLeadDetailsState),
                                SizedBox(
                                  height: 30,
                                ),
                                ReferencesInformatiInfo(
                                    AdminLLLeadDetailsState),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: width,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget PersonalInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.TA_Personal_Information,
          style: MyStyles.Bold(18, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Date_of_birth,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.dateofbirth == null
                          ? ""
                          : Helper.DateForMMM(TAppDetailsState.dateofbirth!) +
                              " (age:" +
                              TAppDetailsState.perAge +
                              ")",
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Email,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.perEmail,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Phone_number,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.perDialCode +
                          " " +
                          TAppDetailsState.perPhoneNumber,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_My_Story,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.perStory,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget EmploymentInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.TA_Employment_Information,
          style: MyStyles.Bold(18, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          color: myColor.TA_light,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  GlobleString.TA_employment_status,
                  style: MyStyles.Medium(14, myColor.text_color),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  TAppDetailsState.empstatus != null
                      ? TAppDetailsState.empstatus!.displayValue
                      : "None",
                  style: MyStyles.Regular(14, myColor.text_color),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            (TAppDetailsState.empstatus != null &&
                    (TAppDetailsState.empstatus!.EnumDetailID == 2 ||
                        TAppDetailsState.empstatus!.EnumDetailID == 3 ||
                        TAppDetailsState.empstatus!.EnumDetailID == 4))
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: UniqueKey(),
                    itemCount: TAppDetailsState.listoccupation.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      TenancyEmploymentInformation tempinfo =
                          TAppDetailsState.listoccupation[index];
                      return Column(
                        children: [
                          if (TAppDetailsState.listoccupation.length > 1)
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
                              color: myColor.TA_dark,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      GlobleString.TA_Occupation_title +
                                          " " +
                                          (index + 1).toString(),
                                      style: MyStyles.Bold(14, myColor.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: myColor.TA_light,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    index == 0
                                        ? GlobleString.TA_Current_Occupation
                                        : GlobleString.TA_Occupation,
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    tempinfo.occupation.toString(),
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: myColor.TA_dark,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    GlobleString.TA_Organization,
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    tempinfo.organization.toString(),
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: myColor.TA_light,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    GlobleString.TA_Length_of_Employment,
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    tempinfo.lenthofemp.toString(),
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: myColor.TA_dark,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    GlobleString.TA_Annual_Income,
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    tempinfo.anualIncome != null
                                        ? tempinfo.anualIncome!.displayValue
                                            .toString()
                                        : "",
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (TAppDetailsState.listoccupation.length > 1)
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
                              color: myColor.white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "",
                                      style: MyStyles.Regular(
                                          14, myColor.text_color),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  )
                : Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    color: myColor.TA_dark,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            GlobleString.TA_Annual_Income,
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            TAppDetailsState.anualincomestatus != null
                                ? TAppDetailsState
                                    .anualincomestatus!.displayValue
                                : "",
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        )
                      ],
                    ),
                  ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_LinkedIn_profile_link,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.linkedprofile,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Other_sources_of_income,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.othersourceincome,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget CurrentTenancyInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.TA_Current_Tenacy,
          style: MyStyles.Bold(18, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Current_tenacy_start_date,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.ct_startdate != null
                          ? Helper.DateForMMM(TAppDetailsState.ct_startdate!)
                          : "",
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Current_tenacy_end_date,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.ct_enddate != null
                          ? Helper.DateForMMM(TAppDetailsState.ct_enddate!)
                          : "",
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Current_tenacy_Address,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.CurrentTenancyID != ""
                          ? TAppDetailsState.suiteunit +
                              " - " +
                              TAppDetailsState.ct_address +
                              ", " +
                              TAppDetailsState.ct_city +
                              ", " +
                              TAppDetailsState.ct_province +
                              ", " +
                              TAppDetailsState.ct_postalcode
                          : "",
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget CurrentlandlordInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.TA_Current_Landlord,
          style: MyStyles.Bold(18, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Landlord_Name,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.cl_firstname +
                          " " +
                          TAppDetailsState.cl_lastname,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Email,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.cl_email,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Phone_number,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.cl_dailcode +
                          " " +
                          TAppDetailsState.cl_phonenumber,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget AdditionalOccupantsInfo(
      AdminLandlordLeadsDetailsState TAppDetailsState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.TA_Additional_Occupants,
          style: MyStyles.Bold(18, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            !TAppDetailsState.notapplicable
                ? TAppDetailsState.occupantlist.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        key: UniqueKey(),
                        itemCount: TAppDetailsState.occupantlist.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          TenancyAdditionalOccupant taoccupant =
                              TAppDetailsState.occupantlist[index];
                          return Column(
                            children: [
                              if (TAppDetailsState.occupantlist.length > 1)
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  color: myColor.TA_dark,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          GlobleString.TA_Occupants +
                                              " " +
                                              (index + 1).toString(),
                                          style:
                                              MyStyles.Bold(14, myColor.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_light,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString
                                            .TA_Additional_Occupants_first_name,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        taoccupant.firstname.toString(),
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_dark,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString
                                            .TA_Additional_Occupants_Last_name,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        taoccupant.lastname.toString(),
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_light,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString
                                            .TA_Additional_Occupants_Relationship_applicant,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        taoccupant.primaryApplicant.toString(),
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (TAppDetailsState.occupantlist.length > 1)
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  color: myColor.white,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "",
                                          style: MyStyles.Regular(
                                              14, myColor.text_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      )
                    : Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: myColor.TA_light,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "None",
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "",
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            )
                          ],
                        ),
                      )
                : Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    color: myColor.TA_light,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "None",
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "",
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Widget AdditionalInformatiInfo(
      AdminLandlordLeadsDetailsState TAppDetailsState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.TA_Additional_Informations,
          style: MyStyles.Bold(18, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            (TAppDetailsState.isPets &&
                    TAppDetailsState.petslist != null &&
                    TAppDetailsState.petslist.length > 0)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: UniqueKey(),
                    itemCount: TAppDetailsState.petslist.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      Pets pets = TAppDetailsState.petslist[index];
                      return Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color:
                            index % 2 == 0 ? myColor.TA_light : myColor.TA_dark,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.TA_Pet +
                                    " #" +
                                    (index + 1).toString() +
                                    " " +
                                    GlobleString.TA_Pet_Type_Size_Age,
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                pets.typeofpets.toString() +
                                    ", " +
                                    pets.size.toString() +
                                    ", " +
                                    pets.age.toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    color: myColor.TA_light,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            GlobleString.TA_Pet,
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "None",
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        )
                      ],
                    ),
                  ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Smoking,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.isSmoking
                          ? GlobleString.TA_Yes
                          : GlobleString.TA_No,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            (TAppDetailsState.isVehical &&
                    TAppDetailsState.vehicallist != null &&
                    TAppDetailsState.vehicallist.length > 0)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: UniqueKey(),
                    itemCount: TAppDetailsState.vehicallist.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      Vehical vehical = TAppDetailsState.vehicallist[index];
                      return Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color:
                            index % 2 == 0 ? myColor.TA_light : myColor.TA_dark,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.TA_Vehicle +
                                    " #" +
                                    (index + 1).toString() +
                                    " " +
                                    GlobleString.TA_Vehicle_Make_Model_Year,
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                vehical.make.toString() +
                                    ", " +
                                    vehical.model.toString() +
                                    ", " +
                                    vehical.year.toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    color: myColor.TA_light,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            GlobleString.TA_Vehicle,
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "None",
                            style: MyStyles.Regular(14, myColor.text_color),
                          ),
                        )
                      ],
                    ),
                  ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Intended_tenancy_start_date,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.tenancystartdate == null
                          ? ""
                          : new DateFormat("dd-MMM-yyyy")
                              .format(TAppDetailsState.tenancystartdate!)
                              .toString(),
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Intended_legth_of_tenancy,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "",
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_AI_Number,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.IntendedPeriodNo,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_AI_Period,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.IntendedPeriod != null
                          ? TAppDetailsState.IntendedPeriod!.displayValue
                          : "",
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget ReferencesInformatiInfo(
      AdminLandlordLeadsDetailsState TAppDetailsState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.TA_References,
          style: MyStyles.Bold(18, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        TAppDetailsState.referencelist.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                key: UniqueKey(),
                itemCount: TAppDetailsState.referencelist.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  TenancyAdditionalReference reference =
                      TAppDetailsState.referencelist[index];
                  return Column(
                    children: [
                      if (TAppDetailsState.referencelist.length > 1)
                        Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          color: myColor.TA_dark,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  GlobleString.TA_Reference +
                                      " " +
                                      (index + 1).toString(),
                                  style: MyStyles.Bold(14, myColor.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: myColor.TA_light,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.TA_Reference_Name,
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                reference.firstname.toString() +
                                    " " +
                                    reference.lastname.toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: myColor.TA_dark,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString
                                    .TA_Relationship_to_primary_applicant,
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                reference.reletionshipprimaryApplicant
                                    .toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: myColor.TA_light,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.TA_Reference_Email,
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                reference.email.toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: myColor.TA_dark,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.TA_Reference_Phone_Number,
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                reference.dailcode.toString() +
                                    " " +
                                    reference.phonenumber.toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (TAppDetailsState.referencelist.length > 1)
                        Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          color: myColor.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "",
                                  style:
                                      MyStyles.Regular(14, myColor.text_color),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              )
            : Container(
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: myColor.TA_light,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "None",
                        style: MyStyles.Regular(14, myColor.text_color),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "",
                        style: MyStyles.Regular(14, myColor.text_color),
                      ),
                    )
                  ],
                ),
              ),
      ],
    );
  }

  Future<void> Pdfgenerate(
      AdminLandlordLeadsDetailsState TAppDetailsState) async {
    final pdf = pw.Document(
      author: "Silver Home",
      pageMode: PdfPageMode.fullscreen,
      title: "Tenant Details",
    );

    ssheight = MediaQuery.of(context).size.height;
    sswidth = MediaQuery.of(context).size.width;

    /* pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(10),
        build: (pw.Context context) => pw.Container(
          width: sswidth,
          // height: ssheight,
          color: PdfColor.fromHex("#FBFBFB"),
          child: pw.Column(
            children: [
              //Banner view

            ],
          ),
        ),
      ),
    );*/

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Container(
              width: sswidth,
              //height: ssheight,
              color: PdfColor.fromHex("#FFFFFF"),
              child: pw.Column(
                children: [
                  pdfHeader(TAppDetailsState),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pdfStatus(TAppDetailsState),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pdfPersonalInfo(TAppDetailsState),
                  pw.SizedBox(
                    height: 25,
                  ),
                  pdfEmploymentInfo(TAppDetailsState),
                  pw.SizedBox(
                    height: 25,
                  ),
                  pdfCurrentTenancyInfo(TAppDetailsState),
                  pw.SizedBox(
                    height: 25,
                  ),
                  pdfCurrentlandlordInfo(TAppDetailsState),
                  pw.SizedBox(
                    height: 25,
                  ),
                  pdfAdditionalOccupantsInfo(TAppDetailsState),
                  pw.SizedBox(
                    height: 25,
                  ),
                  pdfAdditionalInformatiInfo(TAppDetailsState),
                  pw.SizedBox(
                    height: 25,
                  ),
                  pdfReferencesInformatiInfo(TAppDetailsState)
                ],
              ),
            ),
          ];
        },
      ),
    );

    String filename = "Tenant_details_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
        ".pdf";

    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;
    html.document.body!.children.add(anchor);
    anchor.click();
  }

  pdfHeader(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Container(
      width: width,
      height: 40,
      color: PdfColor.fromHex("#010B32"),
      alignment: pw.Alignment.centerLeft,
      padding: pw.EdgeInsets.only(left: 30),
      child: pw.Text(
        TAppDetailsState.perFirstname + " " + TAppDetailsState.perLastname,
        style: pw.TextStyle(
          color: PdfColor.fromHex("#FFFFFF"),
          font: pw.Font.ttf(font_demi),
          fontSize: 18,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pdfStatus(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Container(
            height: 60,
            margin: pw.EdgeInsets.only(right: 10),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(1),
              color: PdfColors.white,
              border:
                  pw.Border.all(color: PdfColor.fromHex("#979797"), width: 1),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  GlobleString.TA_box_Annual_income,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#010B32"),
                    font: pw.Font.ttf(font_medium),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  TAppDetailsState.anualincomestatus != null
                      ? TAppDetailsState.anualincomestatus!.displayValue
                      : "None",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#4B74FF"),
                    font: pw.Font.ttf(font_demi),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            height: 60,
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(1),
              color: PdfColors.white,
              border:
                  pw.Border.all(color: PdfColor.fromHex("#979797"), width: 1),
            ),
            margin: pw.EdgeInsets.only(right: 5, left: 5),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  GlobleString.TA_box_employment_status,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#010B32"),
                    font: pw.Font.ttf(font_medium),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  TAppDetailsState.empstatus != null
                      ? TAppDetailsState.empstatus!.displayValue
                      : "None",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#4B74FF"),
                    font: pw.Font.ttf(font_demi),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            height: 60,
            margin: pw.EdgeInsets.only(left: 10),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(1),
              color: PdfColors.white,
              border:
                  pw.Border.all(color: PdfColor.fromHex("#979797"), width: 1),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  GlobleString.TA_box_AGE,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#010B32"),
                    font: pw.Font.ttf(font_medium),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  TAppDetailsState.perAge,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#4B74FF"),
                    font: pw.Font.ttf(font_demi),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pdfPersonalInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.TA_Personal_Information,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#010B32"),
            font: pw.Font.ttf(font_bold),
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(
          height: 10,
        ),
        pw.Column(
          children: [
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Date_of_birth,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.dateofbirth == null
                          ? ""
                          : Helper.DateForMMM(TAppDetailsState.dateofbirth!) +
                              " (age:" +
                              TAppDetailsState.perAge +
                              ")",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Email,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.perEmail,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Phone_number,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.perDialCode +
                          " " +
                          TAppDetailsState.perPhoneNumber,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_My_Story,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.perStory,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  pdfEmploymentInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.TA_Employment_Information,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#010B32"),
            font: pw.Font.ttf(font_bold),
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(
          height: 10,
        ),
        pw.Column(
          children: [
            (TAppDetailsState.empstatus != null &&
                    (TAppDetailsState.empstatus!.EnumDetailID == 2 ||
                        TAppDetailsState.empstatus!.EnumDetailID == 3 ||
                        TAppDetailsState.empstatus!.EnumDetailID == 4))
                ? pw.ListView.builder(
                    itemCount: TAppDetailsState.listoccupation.length,
                    itemBuilder: (pw.Context ctxt, int index) {
                      TenancyEmploymentInformation tempinfo =
                          TAppDetailsState.listoccupation[index];
                      return pw.Column(
                        children: [
                          if (TAppDetailsState.listoccupation.length > 1)
                            pw.Container(
                              padding: pw.EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
                              color: PdfColor.fromHex("#FBFBFB"),
                              child: pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Text(
                                      GlobleString.TA_Occupation_title +
                                          " " +
                                          (index + 1).toString(),
                                      style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        font: pw.Font.ttf(font_demi),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          pw.Container(
                            padding: pw.EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: PdfColor.fromHex("#F2F2F2"),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    GlobleString.TA_Current_Occupation,
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    tempinfo.occupation.toString(),
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: PdfColor.fromHex("#FBFBFB"),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    GlobleString.TA_Organization,
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    tempinfo.organization.toString(),
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: PdfColor.fromHex("#F2F2F2"),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    GlobleString.TA_Length_of_Employment,
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    tempinfo.lenthofemp.toString(),
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            color: PdfColor.fromHex("#FBFBFB"),
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    GlobleString.TA_Annual_Income,
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    tempinfo.anualIncome!.displayValue
                                        .toString(),
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#010B32"),
                                      font: pw.Font.ttf(font_regular),
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (TAppDetailsState.listoccupation.length > 1)
                            pw.Container(
                              padding: pw.EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
                              color: PdfColor.fromHex("#FFFFFF"),
                              child: pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Text(
                                      "",
                                      style: pw.TextStyle(
                                        color: PdfColor.fromHex("#010B32"),
                                        font: pw.Font.ttf(font_regular),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  )
                : pw.Container(
                    padding: pw.EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10),
                    color: PdfColor.fromHex("#FBFBFB"),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            GlobleString.TA_Annual_Income,
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            TAppDetailsState.anualincomestatus != null
                                ? TAppDetailsState
                                    .anualincomestatus!.displayValue
                                : "",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_LinkedIn_profile_link,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.linkedprofile,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Other_sources_of_income,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.othersourceincome,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pdfCurrentTenancyInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.TA_Current_Tenacy,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#010B32"),
            font: pw.Font.ttf(font_bold),
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(
          height: 10,
        ),
        pw.Column(
          children: [
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Current_tenacy_start_date,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.ct_startdate != null
                          ? Helper.DateForMMM(TAppDetailsState.ct_startdate!)
                          : "",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Current_tenacy_end_date,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.ct_enddate != null
                          ? Helper.DateForMMM(TAppDetailsState.ct_enddate!)
                          : "",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Current_tenacy_Address,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.CurrentTenancyID != ""
                          ? TAppDetailsState.suiteunit +
                              " - " +
                              TAppDetailsState.ct_address +
                              ", " +
                              TAppDetailsState.ct_city +
                              ", " +
                              TAppDetailsState.ct_province +
                              ", " +
                              TAppDetailsState.ct_postalcode
                          : "",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pdfCurrentlandlordInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.TA_Current_Landlord,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#010B32"),
            font: pw.Font.ttf(font_bold),
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(
          height: 10,
        ),
        pw.Column(
          children: [
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Landlord_Name,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.cl_firstname +
                          " " +
                          TAppDetailsState.cl_lastname,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Email,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.cl_email,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Phone_number,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.cl_dailcode +
                          " " +
                          TAppDetailsState.cl_phonenumber,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pdfAdditionalOccupantsInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.TA_Additional_Occupants,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#010B32"),
            font: pw.Font.ttf(font_bold),
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(
          height: 10,
        ),
        pw.Column(
          children: [
            !TAppDetailsState.notapplicable
                ? TAppDetailsState.occupantlist.length > 0
                    ? pw.ListView.builder(
                        itemCount: TAppDetailsState.occupantlist.length,
                        itemBuilder: (pw.Context ctxt, int index) {
                          TenancyAdditionalOccupant taoccupant =
                              TAppDetailsState.occupantlist[index];
                          return pw.Column(
                            children: [
                              if (TAppDetailsState.occupantlist.length > 1)
                                pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  color: PdfColor.fromHex("#FBFBFB"),
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Expanded(
                                        flex: 2,
                                        child: pw.Text(
                                          GlobleString.TA_Occupants +
                                              " " +
                                              (index + 1).toString(),
                                          style: pw.TextStyle(
                                            color: PdfColor.fromHex("#000000"),
                                            font: pw.Font.ttf(font_demi),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: PdfColor.fromHex("#F2F2F2"),
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                        GlobleString
                                            .TA_Additional_Occupants_first_name,
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#010B32"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      flex: 3,
                                      child: pw.Text(
                                        taoccupant.firstname.toString(),
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#010B32"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: PdfColor.fromHex("#FBFBFB"),
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                        GlobleString
                                            .TA_Additional_Occupants_Last_name,
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#010B32"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      flex: 3,
                                      child: pw.Text(
                                        taoccupant.lastname.toString(),
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#010B32"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: PdfColor.fromHex("#FBFBFB"),
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                        GlobleString
                                            .TA_Additional_Occupants_Relationship_applicant,
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#010B32"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      flex: 3,
                                      child: pw.Text(
                                        taoccupant.primaryApplicant.toString(),
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#010B32"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (TAppDetailsState.occupantlist.length > 1)
                                pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Expanded(
                                        flex: 2,
                                        child: pw.Text(
                                          "",
                                          style: pw.TextStyle(
                                            color: PdfColor.fromHex("#010B32"),
                                            font: pw.Font.ttf(font_regular),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      )
                    : pw.Container(
                        padding: pw.EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: PdfColor.fromHex("#FBFBFB"),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                "None",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                "",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                : pw.Container(
                    padding: pw.EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10),
                    color: PdfColor.fromHex("#FBFBFB"),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            "None",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            "",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  pdfAdditionalInformatiInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.TA_Additional_Informations,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#010B32"),
            font: pw.Font.ttf(font_bold),
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(
          height: 10,
        ),
        pw.Column(
          children: [
            (TAppDetailsState.isPets &&
                    TAppDetailsState.petslist != null &&
                    TAppDetailsState.petslist.length > 0)
                ? pw.ListView.builder(
                    itemCount: TAppDetailsState.petslist.length,
                    itemBuilder: (pw.Context ctxt, int index) {
                      Pets pets = TAppDetailsState.petslist[index];
                      return pw.Container(
                        padding: pw.EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: index % 2 == 0
                            ? PdfColor.fromHex("#FBFBFB")
                            : PdfColor.fromHex("#F2F2F2"),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                GlobleString.TA_Pet +
                                    " #" +
                                    (index + 1).toString() +
                                    " " +
                                    GlobleString.TA_Pet_Type_Size_Age,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                pets.typeofpets.toString() +
                                    ", " +
                                    pets.size.toString() +
                                    ", " +
                                    pets.age.toString(),
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : pw.Container(
                    padding: pw.EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10),
                    color: PdfColor.fromHex("#FBFBFB"),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            GlobleString.TA_Pet,
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            "",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Smoking,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.isSmoking
                          ? GlobleString.TA_Yes
                          : GlobleString.TA_No,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            (TAppDetailsState.isVehical &&
                    TAppDetailsState.vehicallist != null &&
                    TAppDetailsState.vehicallist.length > 0)
                ? pw.ListView.builder(
                    itemCount: TAppDetailsState.vehicallist.length,
                    itemBuilder: (pw.Context ctxt, int index) {
                      Vehical vehical = TAppDetailsState.vehicallist[index];
                      return pw.Container(
                        padding: pw.EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: index % 2 == 0
                            ? PdfColor.fromHex("#FBFBFB")
                            : PdfColor.fromHex("#F2F2F2"),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                GlobleString.TA_Vehicle +
                                    " #" +
                                    (index + 1).toString() +
                                    " " +
                                    GlobleString.TA_Vehicle_Make_Model_Year,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                vehical.make.toString() +
                                    ", " +
                                    vehical.model.toString() +
                                    ", " +
                                    vehical.year.toString(),
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : pw.Container(
                    padding: pw.EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10),
                    color: PdfColor.fromHex("#FBFBFB"),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            GlobleString.TA_Vehicle,
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            "None",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#010B32"),
                              font: pw.Font.ttf(font_regular),
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Intended_tenancy_start_date,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.tenancystartdate == null
                          ? ""
                          : new DateFormat("dd-MMM-yyyy")
                              .format(TAppDetailsState.tenancystartdate!)
                              .toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_Intended_legth_of_tenancy,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      "",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#F2F2F2"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_AI_Number,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.IntendedPeriodNo,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pw.Container(
              padding:
                  pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      GlobleString.TA_AI_Period,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      TAppDetailsState.IntendedPeriod != null
                          ? TAppDetailsState.IntendedPeriod!.displayValue
                          : "",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#010B32"),
                        font: pw.Font.ttf(font_regular),
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pdfReferencesInformatiInfo(AdminLandlordLeadsDetailsState TAppDetailsState) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.TA_References,
          style: pw.TextStyle(
            color: PdfColor.fromHex("#010B32"),
            font: pw.Font.ttf(font_bold),
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(
          height: 10,
        ),
        TAppDetailsState.referencelist.length > 0
            ? pw.ListView.builder(
                itemCount: TAppDetailsState.referencelist.length,
                itemBuilder: (pw.Context ctxt, int index) {
                  TenancyAdditionalReference reference =
                      TAppDetailsState.referencelist[index];
                  return pw.Column(
                    children: [
                      if (TAppDetailsState.referencelist.length > 1)
                        pw.Container(
                          padding: pw.EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          color: PdfColor.fromHex("#F2F2F2"),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  GlobleString.TA_Reference +
                                      " " +
                                      (index + 1).toString(),
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex("#000000"),
                                    font: pw.Font.ttf(font_demi),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      pw.Container(
                        padding: pw.EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: PdfColor.fromHex("#FBFBFB"),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                GlobleString.TA_Reference_Name,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                reference.firstname.toString() +
                                    " " +
                                    reference.lastname.toString(),
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: PdfColor.fromHex("#F2F2F2"),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                GlobleString
                                    .TA_Relationship_to_primary_applicant,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                reference.reletionshipprimaryApplicant
                                    .toString(),
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: PdfColor.fromHex("#FBFBFB"),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                GlobleString.TA_Reference_Email,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                reference.email.toString(),
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        color: PdfColor.fromHex("#F2F2F2"),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                GlobleString.TA_Reference_Phone_Number,
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                reference.dailcode.toString() +
                                    " " +
                                    reference.phonenumber.toString(),
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (TAppDetailsState.referencelist.length > 1)
                        pw.Container(
                          padding: pw.EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          color: PdfColor.fromHex("#FFFFFF"),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  "",
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex("#010B32"),
                                    font: pw.Font.ttf(font_regular),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              )
            : pw.Container(
                padding:
                    pw.EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                color: PdfColor.fromHex("#FBFBFB"),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        "None",
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_regular),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "",
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_regular),
                          fontSize: 11,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ],
    );
  }
}

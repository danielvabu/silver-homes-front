import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenants_application_details_action.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/alert/circular_loading_widget.dart';

import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../models/landlord_models/tenants_application_details_state.dart';

class TenancyApplicationScreen extends StatefulWidget {
  List<TenancyApplication> listdata;
  int pos;

  TenancyApplicationScreen({
    required List<TenancyApplication> listdata1,
    required int index,
  })  : listdata = listdata1,
        pos = index;

  @override
  _TenancyApplicationScreenState createState() =>
      _TenancyApplicationScreenState();
}

class _TenancyApplicationScreenState extends State<TenancyApplicationScreen> {
  double height = 0, width = 0;
  double ssheight = 0, sswidth = 0;
  bool isloading = true;
  final _store = getIt<AppStore>();

  static List<SystemEnumDetails> statuslist = [];
  var font_medium, font_demi, font_regular, font_bold;

  int indexpos = 0;

  @override
  void initState() {
    apiManagerCall();
    fontload();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    indexpos = widget.pos;
    statuslist.clear();
    statuslist = QueryFilter().PlainValues(eSystemEnums().ApplicationStatus);

    ApiCallForTenantDetails(widget.listdata[widget.pos].applicantId.toString());
  }

  ApiCallForTenantDetails(String applicantId) async {
    await ClearState();

    ApiManager().getTenancyDetails_Applicant(context, applicantId,
        (status, responce, applicantDetails) {
      if (status) {
        if (applicantDetails!.intendedTenancyStartDate != "") {
          DateTime tempDate =
              DateTime.parse(applicantDetails.intendedTenancyStartDate!);
          _store
              .dispatch(UpdateTADetailAdditionalInfoTenancyStartDate(tempDate));
        } else {
          _store.dispatch(UpdateTADetailAdditionalInfoTenancyStartDate(null));
        }

        _store.dispatch(UpdateTADetailApplicantID(applicantDetails.id!));
        _store.dispatch(
            UpdateTADetailAdditionalInfoisSmoking(applicantDetails.isSmoking!));
        _store.dispatch(
            UpdateTADetailAdditionalInfoIspets(applicantDetails.isPet!));
        _store.dispatch(
            UpdateTADetailAdditionalInfoisVehical(applicantDetails.isVehicle!));
        _store.dispatch(
            UpdateTADetailAdditionalInfoComment(applicantDetails.smokingDesc!));
        _store.dispatch(UpdateTADetailAdditionalInfoLenthOfTenancy(
            applicantDetails.intendedLenth));
        _store.dispatch(UpdateTADetailAdditionalInfoIntendedPeriod(
            applicantDetails.intendedPeriod));
        _store.dispatch(UpdateTADetailAdditionalInfoIntendedPeriodNo(
            applicantDetails.intendedPeriodNo!));

        _store.dispatch(UpdateTADetailPersonID(applicantDetails.personId!.id!));
        _store.dispatch(
            UpdateTADetailFirstname(applicantDetails.personId!.firstName!));
        _store.dispatch(
            UpdateTADetailLastname(applicantDetails.personId!.lastName!));
        _store.dispatch(UpdateTADetailEmail(applicantDetails.personId!.email!));
        _store.dispatch(UpdateTADetailPhoneNumber(
            applicantDetails.personId!.mobileNumber!));
        _store.dispatch(
            UpdateTADetailCountryCode(applicantDetails.personId!.countryCode!));
        _store.dispatch(
            UpdateTADetailDialCode(applicantDetails.personId!.dialCode!));
        _store.dispatch(UpdateTADetailStory(applicantDetails.yourStory!));
        _store.dispatch(UpdateTADetailNote(applicantDetails.note!));

        if (applicantDetails.personId!.DOB != "") {
          DateTime tempDate = DateTime.parse(applicantDetails.personId!.DOB!);
          _store.dispatch(UpdateTADetailDateofBirth(tempDate));
          _store.dispatch(
              UpdateTADetailAge(Helper.calculateAge(tempDate).toString()));
        } else {
          _store.dispatch(UpdateTADetailDateofBirth(null));
          _store.dispatch(UpdateTADetailAge("0"));
        }

        _store.dispatch(UpdateTADetailRating(applicantDetails.rating!));
        _store.dispatch(UpdateTADetailRatingReview(applicantDetails.note!));
      }
    });

    ApiManager().getTenancyDetails_Application(context, applicantId,
        (status, responce, applicationDetails, propdata, ownerdata) {
      if (status) {
        _store.dispatch(UpdateTADetailApplicationID(applicationDetails!.id!));
        _store.dispatch(UpdateTADetailApplicationStatus(
            applicationDetails.applicationStatus));

        _store.dispatch(UpdateTADetailAddOccupantNotApplicable(
            applicationDetails.IsNotApplicableAddOccupant!));

        ApiManager().getTenancyDetails_AdditionalOccupant(
            context, applicationDetails.id!, (status, responce, occupantlist) {
          if (status) {
            _store.dispatch(UpdateTADetailAddOccupantlist(occupantlist));
          }
        });

        ApiManager().getTenancyDetails_AdditionalReference(
            context, applicationDetails.id!, (status, responce, referencelist) {
          if (status) {
            _store
                .dispatch(UpdateTADetailAdditionalReferencelist(referencelist));
          }
        });

        updatemethod();
      }
    });

    ApiManager().getTenancyDetails_CurrentTenancy(context, applicantId,
        (status, responce, applicatCurrentTenancy) {
      if (status) {
        if (applicatCurrentTenancy!.startDate != "") {
          DateTime tempDate = DateTime.parse(applicatCurrentTenancy.startDate!);
          _store.dispatch(UpdateTADetailCurrenttenantStartDate(tempDate));
        } else {
          _store.dispatch(UpdateTADetailCurrenttenantStartDate(null));
        }

        if (applicatCurrentTenancy.endDate != "") {
          DateTime tempDate = DateTime.parse(applicatCurrentTenancy.endDate!);
          _store.dispatch(UpdateTADetailCurrenttenantEndDate(tempDate));
        } else {
          _store.dispatch(UpdateTADetailCurrenttenantEndDate(null));
        }

        _store.dispatch(UpdateTADetailCurrenttenantCurrentTenancyID(
            applicatCurrentTenancy.id!));
        _store.dispatch(UpdateTADetailCurrenttenantCurrentLandLordID(
            applicatCurrentTenancy.CurrentLandLord_ID!));
        _store.dispatch(UpdateTADetailCurrenttenantSuiteUnit(
            applicatCurrentTenancy.suite!));
        _store.dispatch(UpdateTADetailCurrenttenantAddress(
            applicatCurrentTenancy.address!));
        _store.dispatch(
            UpdateTADetailCurrenttenantCity(applicatCurrentTenancy.city!));
        _store.dispatch(UpdateTADetailCurrenttenantProvince(
            applicatCurrentTenancy.province!));
        _store.dispatch(UpdateTADetailCurrenttenantPostalcode(
            applicatCurrentTenancy.postalCode!));
        _store.dispatch(UpdateTADetailCurrenttenantisReference(
            applicatCurrentTenancy.currentLandLordIscheckedAsReference!));
        _store.dispatch(UpdateTADetailCurrenttenantFirstname(
            applicatCurrentTenancy.CurrentLandLord_FirstName!));
        _store.dispatch(UpdateTADetailCurrenttenantLastname(
            applicatCurrentTenancy.CurrentLandLord_LastName!));
        _store.dispatch(UpdateTADetailCurrenttenantEmail(
            applicatCurrentTenancy.CurrentLandLord_Email!));
        _store.dispatch(UpdateTADetailCurrenttenantPhonenumber(
            applicatCurrentTenancy.CurrentLandLord_MobileNumber!));
        _store.dispatch(UpdateTADetailCurrenttenantCode(
            applicatCurrentTenancy.CurrentLandLord_Country_Code!));
        _store.dispatch(UpdateTADetailCurrenttenantDailCode(
            applicatCurrentTenancy.CurrentLandLord_Dial_Code!));
      }
    });

    ApiManager().getTenancyDetails_Employemant(context, applicantId,
        (status, responce, employemantDetails) {
      if (status) {
        _store.dispatch(UpdateTADetailothersourceincome(
            employemantDetails!.otherSourceIncome!));
        _store.dispatch(
            UpdateTADetaillinkedprofile(employemantDetails.LinkedIn!));
        _store.dispatch(UpdateTADetailAnualincomestatus(
            employemantDetails.annualIncomeStatus));
        _store
            .dispatch(UpdateTADetailempstatus(employemantDetails.empStatusId));
        _store.dispatch(UpdateTADetailEmploymentID(employemantDetails.id!));
        _store.dispatch(
            UpdateTADetaillistoccupation(employemantDetails.occupation!));

        for (int b = 0; b < employemantDetails.occupation!.length; b++) {
          TenancyEmploymentInformation tenancyEmploymentInformation =
              employemantDetails.occupation![b];

          if (tenancyEmploymentInformation.IsCurrentOccupation!) {
            _store.dispatch(UpdateTADetailAnualincomestatus(
                tenancyEmploymentInformation.anualIncome!));
            break;
          }
        }
      }
    });

    ApiManager().getTenancyDetails_PetInfo(context, applicantId,
        (status, responce, petslist) {
      if (status) {
        _store.dispatch(UpdateTADetailAdditionalInfoPetslist(petslist));
      }
    });

    ApiManager().getTenancyDetails_Vehicallist(context, applicantId,
        (status, responce, vehicallist) {
      if (status) {
        _store.dispatch(UpdateTADetailAdditionalInfoVehicallist(vehicallist));
      }
    });
  }

  ClearState() {
    _store.dispatch(UpdateTADetailAdditionalInfoTenancyStartDate(null));

    _store.dispatch(UpdateTADetailApplicantID(""));
    _store.dispatch(UpdateTADetailAdditionalInfoisSmoking(false));
    _store.dispatch(UpdateTADetailAdditionalInfoIspets(false));
    _store.dispatch(UpdateTADetailAdditionalInfoisVehical(false));
    _store.dispatch(UpdateTADetailAdditionalInfoComment(""));

    _store.dispatch(UpdateTADetailAdditionalInfoLenthOfTenancy(null));
    _store.dispatch(UpdateTADetailAdditionalInfoIntendedPeriod(null));
    _store.dispatch(UpdateTADetailAdditionalInfoIntendedPeriodNo(""));

    _store.dispatch(UpdateTADetailPersonID(""));
    _store.dispatch(UpdateTADetailFirstname(""));
    _store.dispatch(UpdateTADetailLastname(""));
    _store.dispatch(UpdateTADetailEmail(""));
    _store.dispatch(UpdateTADetailPhoneNumber(""));
    _store.dispatch(UpdateTADetailCountryCode("CA"));
    _store.dispatch(UpdateTADetailDialCode("+1"));
    _store.dispatch(UpdateTADetailStory(""));
    _store.dispatch(UpdateTADetailNote(""));

    _store.dispatch(UpdateTADetailDateofBirth(null));
    _store.dispatch(UpdateTADetailAge("0"));
    _store.dispatch(UpdateTADetailRating(0));
    _store.dispatch(UpdateTADetailRatingReview(""));

    _store.dispatch(UpdateTADetailApplicationID(""));
    _store.dispatch(UpdateTADetailApplicationStatus(null));

    _store.dispatch(UpdateTADetailAddOccupantNotApplicable(false));

    _store.dispatch(UpdateTADetailAddOccupantlist([]));
    _store.dispatch(UpdateTADetailAdditionalReferencelist([]));

    _store.dispatch(UpdateTADetailCurrenttenantStartDate(null));
    _store.dispatch(UpdateTADetailCurrenttenantEndDate(null));

    _store.dispatch(UpdateTADetailCurrenttenantCurrentTenancyID(""));
    _store.dispatch(UpdateTADetailCurrenttenantCurrentLandLordID(""));
    _store.dispatch(UpdateTADetailCurrenttenantSuiteUnit(""));
    _store.dispatch(UpdateTADetailCurrenttenantAddress(""));
    _store.dispatch(UpdateTADetailCurrenttenantCity(""));
    _store.dispatch(UpdateTADetailCurrenttenantProvince(""));
    _store.dispatch(UpdateTADetailCurrenttenantPostalcode(""));
    _store.dispatch(UpdateTADetailCurrenttenantisReference(false));
    _store.dispatch(UpdateTADetailCurrenttenantFirstname(""));
    _store.dispatch(UpdateTADetailCurrenttenantLastname(""));
    _store.dispatch(UpdateTADetailCurrenttenantEmail(""));
    _store.dispatch(UpdateTADetailCurrenttenantPhonenumber(""));
    _store.dispatch(UpdateTADetailCurrenttenantCode("CA"));
    _store.dispatch(UpdateTADetailCurrenttenantDailCode("+1"));

    _store.dispatch(UpdateTADetailothersourceincome(""));
    _store.dispatch(UpdateTADetaillinkedprofile(""));
    _store.dispatch(UpdateTADetailAnualincomestatus(null));
    _store.dispatch(UpdateTADetailempstatus(null));
    _store.dispatch(UpdateTADetailEmploymentID(""));
    _store.dispatch(UpdateTADetaillistoccupation([]));

    _store.dispatch(UpdateTADetailAdditionalInfoPetslist([]));
    _store.dispatch(UpdateTADetailAdditionalInfoVehicallist([]));
  }

  void fontload() async {
    font_medium = await rootBundle.load("assets/fonts/avenirnext-medium.ttf");
    font_demi = await rootBundle.load("assets/fonts/avenirnext-demi.ttf");
    font_regular = await rootBundle.load("assets/fonts/avenirnext-regular.ttf");
    font_bold = await rootBundle.load("assets/fonts/avenirnext-bold.ttf");
  }

  void updatemethod() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      height: height,
      width: width,
      color: isloading ? Colors.black12 : myColor.white,
      child: isloading
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularLoadingWidget(height: 50),
                  /* Container(
                    height: 200,
                    child: Image.asset(
                      "assets/images/silverhome.png",
                      //width: 180,
                    ),
                  ),*/
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: width,
                margin: EdgeInsets.only(right: 20, left: 20),
                child: ConnectState<TenantsApplicationDetailsState>(
                    map: (state) => state.tenantsApplicationDetailsState,
                    where: notIdentical,
                    builder: (TAppDetailsState) {
                      return Column(
                        children: [
                          Container(
                            height: 30,
                            margin: EdgeInsets.only(
                                top: 10, right: 10, left: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _store.dispatch(UpdatePortalPage(
                                        4, GlobleString.NAV_Tenants));
                                  },
                                  child: Container(
                                    child: Text(
                                      GlobleString.TA_BACK_TenancyApplications,
                                      style: MyStyles.Bold(14, myColor.blue),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Pdfgenerate(TAppDetailsState!);
                                      },
                                      child: Container(
                                        child: Text(
                                          GlobleString.TA_exportpdf,
                                          style:
                                              MyStyles.Bold(14, myColor.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    (widget.listdata.length - 1) > indexpos &&
                                            widget.listdata.length > 1
                                        ? InkWell(
                                            onTap: () {
                                              indexpos++;
                                              if (widget.listdata.length >
                                                  indexpos) {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                nextdetails(indexpos);
                                              }
                                            },
                                            child: Container(
                                              child: Text(
                                                GlobleString.TA_NEXT,
                                                style: MyStyles.Bold(
                                                    14, myColor.blue),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: width,
                                    color: myColor.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width,
                                          height: 60,
                                          color: myColor.TA_header,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  TAppDetailsState!
                                                          .perFirstname +
                                                      " " +
                                                      TAppDetailsState
                                                          .perLastname,
                                                  style: MyStyles.Medium(
                                                      25, myColor.white),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _store.dispatch(
                                                      UpdatePortalPage(
                                                          4,
                                                          GlobleString
                                                              .NAV_Tenants));
                                                  CustomeWidget.EditApplicant(
                                                      context,
                                                      TAppDetailsState
                                                              .ApplicantID
                                                          .toString());
                                                },
                                                child: Tooltip(
                                                  message: "Edit",
                                                  child: Container(
                                                    width: 30,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    child: Image.asset(
                                                      "assets/images/ic_edit.png",
                                                      width: 30,
                                                      height: 30,
                                                      color: Colors.white,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Card(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                elevation: 4,
                                                shadowColor: myColor.black,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            myColor.TA_Border,
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)),
                                                child: Container(
                                                  height: 80,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        GlobleString
                                                            .TA_box_Annual_income,
                                                        style: MyStyles.Medium(
                                                            16,
                                                            myColor.text_color),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        TAppDetailsState
                                                                    .anualincomestatus !=
                                                                null
                                                            ? TAppDetailsState
                                                                .anualincomestatus!
                                                                .displayValue
                                                            : "None",
                                                        style: MyStyles.Bold(
                                                            18, myColor.blue),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Card(
                                                margin: EdgeInsets.only(
                                                    right: 5, left: 5),
                                                elevation: 4,
                                                shadowColor: myColor.black,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            myColor.TA_Border,
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)),
                                                child: Container(
                                                  height: 80,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        GlobleString
                                                            .TA_box_employment_status,
                                                        style: MyStyles.Medium(
                                                            16,
                                                            myColor.text_color),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        TAppDetailsState
                                                                    .empstatus !=
                                                                null
                                                            ? TAppDetailsState
                                                                .empstatus!
                                                                .displayValue
                                                            : "None",
                                                        style: MyStyles.Bold(
                                                            18, myColor.blue),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Card(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                elevation: 4,
                                                shadowColor: myColor.black,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            myColor.TA_Border,
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)),
                                                child: Container(
                                                  height: 80,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        GlobleString.TA_box_AGE,
                                                        style: MyStyles.Medium(
                                                            16,
                                                            myColor.text_color),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        TAppDetailsState.perAge,
                                                        style: MyStyles.Bold(
                                                            18, myColor.blue),
                                                        textAlign:
                                                            TextAlign.center,
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
                                        PersonalInfo(TAppDetailsState),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        EmploymentInfo(TAppDetailsState),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        CurrentTenancyInfo(TAppDetailsState),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        CurrentlandlordInfo(TAppDetailsState),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        AdditionalOccupantsInfo(
                                            TAppDetailsState),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        AdditionalInformatiInfo(
                                            TAppDetailsState),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        ReferencesInformatiInfo(
                                            TAppDetailsState),
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
                                TenantScroing(TAppDetailsState),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
    );
  }

  Widget PersonalInfo(TenantsApplicationDetailsState TAppDetailsState) {
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
            ),
            /*Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              color: myColor.TA_dark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      GlobleString.TA_Private_Notes,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      TAppDetailsState.Note,
                      style: MyStyles.Regular(14, myColor.text_color),
                    ),
                  )
                ],
              ),
            )*/
          ],
        ),
      ],
    );
  }

  Widget EmploymentInfo(TenantsApplicationDetailsState TAppDetailsState) {
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
                  style: MyStyles.Regular(14, myColor.text_color),
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

  Widget CurrentTenancyInfo(TenantsApplicationDetailsState TAppDetailsState) {
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

  Widget CurrentlandlordInfo(TenantsApplicationDetailsState TAppDetailsState) {
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
      TenantsApplicationDetailsState TAppDetailsState) {
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
      TenantsApplicationDetailsState TAppDetailsState) {
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
      TenantsApplicationDetailsState TAppDetailsState) {
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

  Widget TenantScroing(TenantsApplicationDetailsState TAppDetailsState) {
    return Expanded(
      flex: 2,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: myColor.TA_Border, width: 1.5),
            color: myColor.white),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tenant Scoring",
                style: MyStyles.Medium(25, myColor.text_color),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                GlobleString.TA_General_Rating,
                style: MyStyles.Medium(18, myColor.text_color),
              ),
              SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: TAppDetailsState.Rating,
                allowHalfRating: false,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: myColor.blue,
                ),
                onRatingUpdate: (rating) {
                  _store.dispatch(UpdateTADetailRating(rating));
                },
                itemCount: 5,
                itemSize: 30.0,
                unratedColor: myColor.TA_Border,
                direction: Axis.horizontal,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                GlobleString.TA_Status,
                style: MyStyles.Medium(18, myColor.text_color),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 35,
                width: 200,
                child: DropdownSearch<SystemEnumDetails>(
                  mode: Mode.MENU,
                  items: statuslist,
                  textstyle: MyStyles.Medium(12, myColor.text_color),
                  itemAsString: (SystemEnumDetails? u) =>
                      u != null ? u.displayValue : "",
                  hint: "Select Status",
                  defultHeight: statuslist.length * 35 > 250
                      ? 250
                      : statuslist.length * 35,
                  showSearchBox: false,
                  selectedItem: TAppDetailsState.ApplicationStatus != null
                      ? TAppDetailsState.ApplicationStatus
                      : null,
                  isFilteredOnline: true,
                  onChanged: (data) {
                    _store.dispatch(UpdateTADetailApplicationStatus(data));
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                GlobleString.Notes,
                style: MyStyles.Medium(18, myColor.text_color),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: TAppDetailsState.RatingReview,
                textAlign: TextAlign.start,
                maxLines: 7,
                style: MyStyles.Medium(14, myColor.text_color),
                decoration: InputDecoration(
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: myColor.TA_Border, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: myColor.TA_Border, width: 1.0),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    fillColor: myColor.white,
                    filled: true),
                onChanged: (value) {
                  _store.dispatch(UpdateTADetailRatingReview(value.toString()));
                },
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      TenancyApplicationID updateid =
                          new TenancyApplicationID();
                      updateid.ID = TAppDetailsState.ApplicationID;

                      UpdateScoreRatingReview ratingreview =
                          new UpdateScoreRatingReview();
                      ratingreview.ID = TAppDetailsState.ApplicantID;
                      ratingreview.Rating = TAppDetailsState.Rating;
                      ratingreview.Note =
                          TAppDetailsState.RatingReview.toString();
                      ratingreview.RatingReview =
                          TAppDetailsState.RatingReview.toString();

                      TenancyApplicationUpdateScore updatestatus =
                          new TenancyApplicationUpdateScore();
                      updatestatus.ApplicationStatus = TAppDetailsState
                          .ApplicationStatus!.EnumDetailID
                          .toString();
                      updatestatus.applicantID = ratingreview;

                      ApiManager().UpdateTenancyApplicationScore(
                          context, updateid, updatestatus);
                    },
                    child: Container(
                      height: 35,
                      width: 80,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: myColor.Circle_main,
                      ),
                      child: Text(
                        GlobleString.TA_Save,
                        style: MyStyles.Medium(14, myColor.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  nextdetails(int index) {
    ApiCallForTenantDetails(widget.listdata[index].applicantId.toString());
  }

  /*==========================================================================*/
  /*======================== PDF For TENANT DETAILS===========================*/
  /*==========================================================================*/

  Future<void> Pdfgenerate(
      TenantsApplicationDetailsState TAppDetailsState) async {
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

  pdfHeader(TenantsApplicationDetailsState TAppDetailsState) {
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

  pdfStatus(TenantsApplicationDetailsState TAppDetailsState) {
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

  pdfPersonalInfo(TenantsApplicationDetailsState TAppDetailsState) {
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

  pdfEmploymentInfo(TenantsApplicationDetailsState TAppDetailsState) {
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
                                    tempinfo.anualIncome != null
                                        ? tempinfo.anualIncome!.displayValue
                                            .toString()
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

  pdfCurrentTenancyInfo(TenantsApplicationDetailsState TAppDetailsState) {
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

  pdfCurrentlandlordInfo(TenantsApplicationDetailsState TAppDetailsState) {
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

  pdfAdditionalOccupantsInfo(TenantsApplicationDetailsState TAppDetailsState) {
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

  pdfAdditionalInformatiInfo(TenantsApplicationDetailsState TAppDetailsState) {
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

  pdfReferencesInformatiInfo(TenantsApplicationDetailsState TAppDetailsState) {
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

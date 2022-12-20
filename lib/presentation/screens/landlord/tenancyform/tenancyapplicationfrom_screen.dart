import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/Animation/animated_wave.dart';
import 'package:silverhome/common/basic_page.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/navigation_constants.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyaddinfo_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyaddoccupant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyaddreference_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancycurrenttenant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyemployment_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyperson_actions.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/landlord_models/tenancyform_state.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/taf_document_screen.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/taf_personal_screen.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';

import 'taf_additional_information_screen.dart';
import 'taf_additional_occupants_screen.dart';
import 'taf_additional_references_screen.dart';
import 'taf_currenttenancy_screen.dart';
import 'taf_employment_screen.dart';

class TenancyApplicationFormScreen extends BasePage {
  TenancyApplicationFormScreen({
    this.ApplicantID,
  });

  static bool changeFormData = false;
  final String? ApplicantID;

  @override
  TenancyApplicationFormScreenState createState() =>
      TenancyApplicationFormScreenState();
}

class TenancyApplicationFormScreenState
    extends BaseState<TenancyApplicationFormScreen> with BasicPage {
  final _store = getIt<AppStore>();

  double height = 0, width = 0;
  late OverlayEntry loader;

  bool isloading = true;

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    await RemoveHighLight();
    await Prefs.setBool(PrefsName.TCF_Step1, false);
    await Prefs.setBool(PrefsName.TCF_Step2, false);
    await Prefs.setBool(PrefsName.TCF_Step3, false);
    await Prefs.setBool(PrefsName.TCF_Step4, false);
    await Prefs.setBool(PrefsName.TCF_Step5, false);
    await Prefs.setBool(PrefsName.TCF_Step6, false);
    await Prefs.setBool(PrefsName.TCF_Current_isReference_Receive, false);

    if (Prefs.getBool(PrefsName.TCF_EditApplicant) != null &&
        Prefs.getBool(PrefsName.TCF_EditApplicant) != "" &&
        Prefs.getBool(PrefsName.TCF_EditApplicant) == true) {
      await Prefs.setString(PrefsName.TCF_ApplicationID, "");
      await Prefs.setString(PrefsName.TCF_Current_isReference, "");
      await Prefs.setString(PrefsName.TCF_CurrentlandlordID, "");

      Helper.Log("OwnerID Side", Prefs.getString(PrefsName.TCF_ApplicantID));

      apiCallCollection(Prefs.getString(PrefsName.TCF_ApplicantID), 0, false);
    } else {
      await Prefs.setString(PrefsName.TCF_ApplicationID, "");
      await Prefs.setString(PrefsName.TCF_Current_isReference, "");
      await Prefs.setString(PrefsName.TCF_CurrentlandlordID, "");

      await Prefs.setString(
          PrefsName.TCF_ApplicantID, widget.ApplicantID.toString());

      //await Prefs.setString(PrefsName.TCF_ApplicantID, "2263");

      HttpClientCall().CallAPIToken(context, (error, respoce) async {
        if (error) {
          Helper.Log("responce", respoce);
          await Prefs.setString(PrefsName.userTokan, respoce);

          ApiManager().getSystemEnumCallDSQ(context, (error, respoce) async {
            if (error) {
              if (Prefs.getString(PrefsName.TCF_ApplicantID) != null &&
                  Prefs.getString(PrefsName.TCF_ApplicantID) != "") {
                apiCallCollection(
                    Prefs.getString(PrefsName.TCF_ApplicantID), 0, false);
              } else {
                ToastUtils.showCustomToast(context, "Error_server", false);
                await Prefs.clear();
                navigateTo(context, RouteNames.Login);
              }
            } else {
              Helper.Log("respoce", respoce);
            }
          });
        } else {
          Helper.Log("respoce", respoce);
        }
      });
    }
  }

  apiCallCollection(String applicantid, int flag, bool load) async {
    ApiManager().getTenancyDetails_Applicant(context, applicantid,
        (status, responce, applicantDetails) {
      if (status) {
        if (applicantDetails!.intendedTenancyStartDate != "") {
          DateTime tempDate =
              DateTime.parse(applicantDetails.intendedTenancyStartDate!);
          _store.dispatch(UpdateTFAdditionalInfoTenancyStartDate(tempDate));
          _store.dispatch(FNLUpdateTFAdditionalInfoTenancyStartDate(tempDate));
        } else {
          _store.dispatch(UpdateTFAdditionalInfoTenancyStartDate(null));
          _store.dispatch(FNLUpdateTFAdditionalInfoTenancyStartDate(null));
        }
        _store.dispatch(
            UpdateTFAdditionalInfoisSmoking(applicantDetails.isSmoking!));
        _store.dispatch(UpdateTFAdditionalInfoIspets(applicantDetails.isPet!));
        _store.dispatch(
            UpdateTFAdditionalInfoisVehical(applicantDetails.isVehicle!));
        _store.dispatch(
            UpdateTFAdditionalInfoComment(applicantDetails.smokingDesc!));
        _store.dispatch(UpdateTFAdditionalInfoLenthOfTenancy(
            applicantDetails.intendedLenth));
        _store.dispatch(
            UpdateTFAdditionalInfoPeriodValue(applicantDetails.intendedPeriod));
        _store.dispatch(UpdateTFAdditionalInfolenthoftenancynumber(
            applicantDetails.intendedPeriodNo!));

        _store.dispatch(
            FNLUpdateTFAdditionalInfoisSmoking(applicantDetails.isSmoking!));
        _store
            .dispatch(FNLUpdateTFAdditionalInfoIspets(applicantDetails.isPet!));
        _store.dispatch(
            FNLUpdateTFAdditionalInfoisVehical(applicantDetails.isVehicle!));
        _store.dispatch(
            FNLUpdateTFAdditionalInfoComment(applicantDetails.smokingDesc!));
        _store.dispatch(FNLUpdateTFAdditionalInfoLenthOfTenancy(
            applicantDetails.intendedLenth));
        _store.dispatch(FNLUpdateTFAdditionalInfoPeriodValue(
            applicantDetails.intendedPeriod));
        _store.dispatch(FNLUpdateTFAdditionalInfolenthoftenancynumber(
            applicantDetails.intendedPeriodNo!));

        if (applicantDetails.intendedPeriod != null &&
            applicantDetails.intendedPeriod != "") {
          Prefs.setBool(PrefsName.TCF_Step5, true);
        } else {
          Prefs.setBool(PrefsName.TCF_Step5, false);
        }

        _store.dispatch(UpdateTFPersonPersonID(applicantDetails.personId!.id!));
        _store.dispatch(
            UpdateTFPersonFirstname(applicantDetails.personId!.firstName!));
        _store.dispatch(
            UpdateTFPersonLastname(applicantDetails.personId!.lastName!));
        _store.dispatch(UpdateTFPersonEmail(applicantDetails.personId!.email!));
        _store.dispatch(UpdateTFPersonPhoneNumber(
            applicantDetails.personId!.mobileNumber!));
        _store.dispatch(
            UpdateTFPersonCountryCode(applicantDetails.personId!.countryCode!));
        _store.dispatch(
            UpdateTFPersonDialCode(applicantDetails.personId!.dialCode!));
        _store.dispatch(UpdateTFPersonStory(applicantDetails.yourStory!));

        _store.dispatch(
            FNLUpdateTFPersonFirstname(applicantDetails.personId!.firstName!));
        _store.dispatch(
            FNLUpdateTFPersonLastname(applicantDetails.personId!.lastName!));
        _store.dispatch(
            FNLUpdateTFPersonEmail(applicantDetails.personId!.email!));
        _store.dispatch(FNLUpdateTFPersonPhoneNumber(
            applicantDetails.personId!.mobileNumber!));
        _store.dispatch(FNLUpdateTFPersonCountryCode(
            applicantDetails.personId!.countryCode!));
        _store.dispatch(
            FNLUpdateTFPersonDialCode(applicantDetails.personId!.dialCode!));
        _store.dispatch(FNLUpdateTFPersonStory(applicantDetails.yourStory!));

        if (applicantDetails.personId!.mobileNumber != "" &&
            applicantDetails.personId!.DOB != "") {
          Prefs.setBool(PrefsName.TCF_Step1, true);
        } else {
          Prefs.setBool(PrefsName.TCF_Step1, false);
        }

        if (applicantDetails.personId!.DOB != "") {
          DateTime tempDate = DateTime.parse(applicantDetails.personId!.DOB!);
          _store.dispatch(UpdateTFPersonDateofBirth(tempDate));
          _store.dispatch(FNLUpdateTFPersonDateofBirth(tempDate));
        } else {
          _store.dispatch(UpdateTFPersonDateofBirth(null));
          _store.dispatch(FNLUpdateTFPersonDateofBirth(null));
        }
      }
    });

    ApiManager().getTenancyDetails_PetInfo(context, applicantid,
        (status, responce, petslist) {
      if (status) {
        _store.dispatch(UpdateTFAdditionalInfoPetslist(petslist));

        List<Pets> secondList =
            petslist.map((item) => new Pets.clone(item)).toList();

        _store.dispatch(FNLUpdateTFAdditionalInfoPetslist(secondList));
      }
    });

    ApiManager().getTenancyDetails_Vehicallist(context, applicantid,
        (status, responce, vehicallist) {
      if (status) {
        _store.dispatch(UpdateTFAdditionalInfoVehicallist(vehicallist));

        List<Vehical> secondList =
            vehicallist.map((item) => new Vehical.clone(item)).toList();

        _store.dispatch(FNLUpdateTFAdditionalInfoVehicallist(secondList));
      }
    });

    ApiManager().getTenancyDetails_Employemant(context, applicantid,
        (status, responce, employemantDetails) {
      if (status) {
        Prefs.setBool(PrefsName.TCF_Step2, true);

        _store.dispatch(UpdateTFEmploymentothersourceincome(
            employemantDetails!.otherSourceIncome!));
        _store.dispatch(
            UpdateTFEmploymentlinkedprofile(employemantDetails.LinkedIn!));
        _store.dispatch(UpdateTFEmploymentanualincomestatus(
            employemantDetails.annualIncomeStatus));
        _store.dispatch(
            UpdateTFEmploymentempstatus(employemantDetails.empStatusId));
        _store.dispatch(UpdateTFEmploymentEmploymentID(employemantDetails.id!));
        _store.dispatch(
            UpdateTFEmploymentlistoccupation(employemantDetails.occupation!));

        _store.dispatch(FNLUpdateTFEmploymentothersourceincome(
            employemantDetails.otherSourceIncome!));
        _store.dispatch(
            FNLUpdateTFEmploymentlinkedprofile(employemantDetails.LinkedIn!));
        _store.dispatch(FNLUpdateTFEmploymentanualincomestatus(
            employemantDetails.annualIncomeStatus));
        _store.dispatch(
            FNLUpdateTFEmploymentempstatus(employemantDetails.empStatusId));

        List<TenancyEmploymentInformation> secondList = employemantDetails
            .occupation!
            .map((item) => new TenancyEmploymentInformation.clone(item))
            .toList();

        _store.dispatch(FNLUpdateTFEmploymentlistoccupation(secondList));
      }
    });

    ApiManager().getTenancyDetails_Application(context, applicantid,
        (status, responce, applicationDetails, propdata, ownerdata) async {
      if (status) {
        if (propdata!.isActive != null && propdata.isActive!) {
          await Prefs.setString(
              PrefsName.TCF_ApplicationID, applicationDetails!.id!);

          if (applicationDetails.IsNotApplicableAddOccupant!) {
            Prefs.setBool(PrefsName.TCF_Step4, true);
          }

          _store.dispatch(UpdateTFAddOccupantNotApplicable(
              applicationDetails.IsNotApplicableAddOccupant!));
          _store.dispatch(UpdateTFAdditionalReferenceisAutherize(
              applicationDetails.isAuthorized!));
          _store.dispatch(UpdateTFAdditionalReferenceisTermsCondition(
              applicationDetails.isAgreedTerms!));

          _store.dispatch(FNLUpdateTFAddOccupantNotApplicable(
              applicationDetails.IsNotApplicableAddOccupant!));
          _store.dispatch(FNLUpdateTFAdditionalReferenceisAutherize(
              applicationDetails.isAuthorized!));
          _store.dispatch(FNLUpdateTFAdditionalReferenceisTermsCondition(
              applicationDetails.isAgreedTerms!));

          if (applicationDetails.isAuthorized! &&
              applicationDetails.isAgreedTerms!) {
            Prefs.setBool(PrefsName.TCF_Step6, true);
          } else {
            Prefs.setBool(PrefsName.TCF_Step6, false);
          }

          String Address = propdata.propertyName! +
              (propdata.suiteUnit != null && propdata.suiteUnit!.isNotEmpty
                  ? " - " + propdata.suiteUnit!
                  : "") +
              " - " +
              propdata.propertyAddress! +
              ", " +
              propdata.postalCode! +
              ", " +
              propdata.city! +
              ", " +
              propdata.province! +
              ", " +
              propdata.country!;

          _store.dispatch(UpdateTenacyFormAddress(Address));

          _store.dispatch(UpdateTenacyFormCompanyName(ownerdata!.CompanyName!));
          _store
              .dispatch(UpdateTenacyFormHomePagelink(ownerdata.HomePageLink!));
          _store.dispatch(UpdateTenacyFormCustomerFeatureListingURL(
              ownerdata.CustomerFeatureListingURL!));
          _store.dispatch(UpdateTenacyFormCompanyLogo(ownerdata.Company_logo));

          await ApiManager().getTenancyDetails_AdditionalOccupant(
              context, applicationDetails.id!,
              (status, responce, occupantlist) async {
            if (status) {
              if (occupantlist.length > 0) {
                await Prefs.setBool(PrefsName.TCF_Step4, true);
              }
              _store.dispatch(UpdateTFAddOccupantlist(occupantlist));
              _store.dispatch(UpdateTFAddLiveServerOccupantlist(occupantlist));

              List<TenancyAdditionalOccupant> secondList = occupantlist
                  .map((item) => new TenancyAdditionalOccupant.clone(item))
                  .toList();

              _store.dispatch(FNLUpdateTFAddOccupantlist(secondList));
              _store.dispatch(FNLUpdateTFAddLiveServerOccupantlist(secondList));
            }

            if (applicationDetails.IsNotApplicableAddOccupant!) {
              await Prefs.setBool(PrefsName.TCF_Step4, true);
            } else if (!applicationDetails.IsNotApplicableAddOccupant! &&
                occupantlist.length > 0) {
              await Prefs.setBool(PrefsName.TCF_Step4, true);
            } else {
              await Prefs.setBool(PrefsName.TCF_Step4, false);
            }
          });

          await ApiManager()
              .getTenancyDetails_CurrentTenancy(context, applicantid,
                  (status, responce, applicatCurrentTenancy) async {
            if (status) {
              Prefs.setBool(PrefsName.TCF_Step3, true);

              if (applicatCurrentTenancy!.startDate != "") {
                DateTime tempDate =
                    DateTime.parse(applicatCurrentTenancy.startDate!);
                _store.dispatch(UpdateTFCurrenttenantStartDate(tempDate));
                _store.dispatch(FNLUpdateTFCurrenttenantStartDate(tempDate));
              } else {
                _store.dispatch(UpdateTFCurrenttenantStartDate(null));
                _store.dispatch(FNLUpdateTFCurrenttenantStartDate(null));
              }

              if (applicatCurrentTenancy.endDate != "") {
                DateTime tempDate =
                    DateTime.parse(applicatCurrentTenancy.endDate!);
                _store.dispatch(UpdateTFCurrenttenantEndDate(tempDate));
                _store.dispatch(FNLUpdateTFCurrenttenantEndDate(tempDate));
              } else {
                _store.dispatch(UpdateTFCurrenttenantEndDate(null));
                _store.dispatch(FNLUpdateTFCurrenttenantEndDate(null));
              }

              await Prefs.setString(PrefsName.TCF_CurrentlandlordID,
                  applicatCurrentTenancy.CurrentLandLord_ID!);

              _store.dispatch(UpdateTFCurrenttenantCurrentTenancyID(
                  applicatCurrentTenancy.id!));
              _store.dispatch(UpdateTFCurrenttenantCurrentLandLordID(
                  applicatCurrentTenancy.CurrentLandLord_ID!));

              _store.dispatch(UpdateTFCurrenttenantIsUpdate(true));
              _store.dispatch(UpdateTFCurrenttenantSuiteUnit(
                  applicatCurrentTenancy.suite!));
              _store.dispatch(UpdateTFCurrenttenantAddress(
                  applicatCurrentTenancy.address!));
              _store.dispatch(
                  UpdateTFCurrenttenantCity(applicatCurrentTenancy.city!));
              _store.dispatch(UpdateTFCurrenttenantProvince(
                  applicatCurrentTenancy.province!));
              _store.dispatch(UpdateTFCurrenttenantPostalcode(
                  applicatCurrentTenancy.postalCode!));
              _store.dispatch(UpdateTFCurrenttenantisReference(
                  applicatCurrentTenancy.currentLandLordIscheckedAsReference!));
              Prefs.setBool(PrefsName.TCF_Current_isReference,
                  applicatCurrentTenancy.currentLandLordIscheckedAsReference!);
              _store.dispatch(UpdateTFCurrenttenantFirstname(
                  applicatCurrentTenancy.CurrentLandLord_FirstName!));
              _store.dispatch(UpdateTFCurrenttenantLastname(
                  applicatCurrentTenancy.CurrentLandLord_LastName!));
              _store.dispatch(UpdateTFCurrenttenantEmail(
                  applicatCurrentTenancy.CurrentLandLord_Email!));
              _store.dispatch(UpdateTFCurrenttenantPhonenumber(
                  applicatCurrentTenancy.CurrentLandLord_MobileNumber!));
              _store.dispatch(UpdateTFCurrenttenantCode(
                  applicatCurrentTenancy.CurrentLandLord_Country_Code!));
              _store.dispatch(UpdateTFCurrenttenantDailCode(
                  applicatCurrentTenancy.CurrentLandLord_Dial_Code!));

              _store.dispatch(FNLUpdateTFCurrenttenantSuiteUnit(
                  applicatCurrentTenancy.suite!));
              _store.dispatch(FNLUpdateTFCurrenttenantAddress(
                  applicatCurrentTenancy.address!));
              _store.dispatch(
                  FNLUpdateTFCurrenttenantCity(applicatCurrentTenancy.city!));
              _store.dispatch(FNLUpdateTFCurrenttenantProvince(
                  applicatCurrentTenancy.province!));
              _store.dispatch(FNLUpdateTFCurrenttenantPostalcode(
                  applicatCurrentTenancy.postalCode!));
              _store.dispatch(FNLUpdateTFCurrenttenantisReference(
                  applicatCurrentTenancy.currentLandLordIscheckedAsReference!));
              _store.dispatch(FNLUpdateTFCurrenttenantFirstname(
                  applicatCurrentTenancy.CurrentLandLord_FirstName!));
              _store.dispatch(FNLUpdateTFCurrenttenantLastname(
                  applicatCurrentTenancy.CurrentLandLord_LastName!));
              _store.dispatch(FNLUpdateTFCurrenttenantEmail(
                  applicatCurrentTenancy.CurrentLandLord_Email!));
              _store.dispatch(FNLUpdateTFCurrenttenantPhonenumber(
                  applicatCurrentTenancy.CurrentLandLord_MobileNumber!));
              _store.dispatch(FNLUpdateTFCurrenttenantCode(
                  applicatCurrentTenancy.CurrentLandLord_Country_Code!));
              _store.dispatch(FNLUpdateTFCurrenttenantDailCode(
                  applicatCurrentTenancy.CurrentLandLord_Dial_Code!));
            }

            await ApiManager().getTenancyDetails_AdditionalReference(
                context, applicationDetails.id!,
                (status, responce, referencelist) async {
              if (status) {
                List<TenancyAdditionalReference> myreferencelist =
                    <TenancyAdditionalReference>[];

                List<TenancyAdditionalReference> liveserverreferencelist =
                    <TenancyAdditionalReference>[];

                for (int i = 0; i < referencelist.length; i++) {
                  TenancyAdditionalReference daya = referencelist[i];

                  daya.error_firstname = false;
                  daya.error_lastname = false;
                  daya.error_reletionshipprimaryApplicant = false;
                  daya.error_phonenumber = false;
                  daya.error_email = false;
                  daya.isLive = true;

                  if (referencelist[i].QuestionnaireReceivedDate == "" &&
                      daya.QuestionnaireSentDate == "") {
                    daya.isEditable = false;

                    if (Prefs.getString(PrefsName.TCF_CurrentlandlordID) ==
                        daya.ReferenceID) {
                      await Prefs.setBool(
                          PrefsName.TCF_Current_isReference_Receive, false);
                    }
                  } else {
                    daya.isEditable = true;

                    if (Prefs.getString(PrefsName.TCF_CurrentlandlordID) ==
                        daya.ReferenceID) {
                      await Prefs.setBool(
                          PrefsName.TCF_Current_isReference_Receive, true);
                    }
                  }

                  if (Prefs.getString(PrefsName.TCF_CurrentlandlordID) !=
                      daya.ReferenceID) {
                    myreferencelist.add(referencelist[i]);
                    liveserverreferencelist.add(referencelist[i]);
                  }
                }
                _store
                    .dispatch(UpdateTFAdditionalReferencelist(myreferencelist));
                _store.dispatch(UpdateTFAdditionalLiveServerReferencelist(
                    liveserverreferencelist));

                List<TenancyAdditionalReference> secondList = myreferencelist
                    .map((item) => new TenancyAdditionalReference.clone(item))
                    .toList();
                List<TenancyAdditionalReference> livesecondList =
                    liveserverreferencelist
                        .map((item) =>
                            new TenancyAdditionalReference.clone(item))
                        .toList();

                _store.dispatch(FNLUpdateTFAdditionalReferencelist(secondList));
                _store.dispatch(FNLUpdateTFAdditionalLiveServerReferencelist(
                    livesecondList));
              }

              if (load) {
                _store.dispatch(UpdateTenacyFormIndex(flag));
                loader.remove();
              } else {
                updatemethod();
              }
            });
          });
        } else {
          if (load) {
            loader.remove();
          } else {
            dailogShow();
          }
        }
      }
    });
  }

  dailogShow() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.Button_OK,
          title: GlobleString.user_not_accessible,
          onPressed: () async {
            Navigator.of(context).pop();
            await Prefs.clear();
            Navigator.pushNamed(context, RouteNames.Login);
          },
        );
      },
    );
  }

  void updatemethod() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget rootWidget(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isloading ? Colors.black12 : myColor.white,
      body: SafeArea(
        minimum: EdgeInsets.zero,
        child: Center(
          child: isloading
              ? Stack(
                  children: <Widget>[
                    new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /* Container(
                              margin: EdgeInsets.only(bottom: 150),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height - 150,
                              child: Image.asset(
                                "assets/images/silverhome_splash.png",
                                height: 280,
                                alignment: Alignment.center,
                                //width: 180,
                              ),
                            ),*/

                          Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height - 120,
                          ),
                        ],
                      ),
                    ),
                    onBottom(
                      AnimatedWave(
                        height: 180,
                        speed: 1.0,
                      ),
                    ),
                    onBottom(
                      AnimatedWave(
                        height: 120,
                        speed: 0.9,
                        offset: pi,
                      ),
                    ),
                    onBottom(
                      AnimatedWave(
                        height: 220,
                        speed: 1.2,
                        offset: pi / 2,
                      ),
                    ),
                  ],
                )
              : _initialview(),
        ),
      ),
    );
  }

  Widget onBottom(Widget child) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }

  Widget _initialview() {
    return Container(
      width: width,
      height: height,
      child: ConnectState<TenancyFormState>(
          map: (state) => state.tenancyFormState,
          where: notIdentical,
          builder: (tenancyFormState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 20.0, left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tenancyFormState!.CompanyLogo != null &&
                                    tenancyFormState.CompanyLogo!.id != null
                                ? Container(
                                    width: 250,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      width: 250,
                                      height: 80,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: new DecorationImage(
                                          alignment: Alignment.topLeft,
                                          fit: BoxFit.contain,
                                          image: CustomNetworkImage(
                                            Weburl.image_API +
                                                tenancyFormState.CompanyLogo!.id
                                                    .toString(),
                                            scale: 1.5,
                                            headers: {
                                              'Authorization': 'bearer ' +
                                                  Prefs.getString(
                                                      PrefsName.userTokan),
                                              'ApplicationCode':
                                                  Weburl.API_CODE,
                                            },
                                          ),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Helper.urlload(
                                              tenancyFormState.HomePagelink);
                                        },
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    "assets/images/silverhome.png",
                                    width: 250,
                                    height: 50,
                                    alignment: Alignment.topLeft,
                                  ),
                            SizedBox(height: 30),
                            Prefs.getBool(PrefsName.TCF_EditApplicant) !=
                                        null &&
                                    Prefs.getBool(
                                            PrefsName.TCF_EditApplicant) !=
                                        "" &&
                                    Prefs.getBool(
                                            PrefsName.TCF_EditApplicant) ==
                                        true
                                ? Container(
                                    width: 150,
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      onTap: () {
                                        showBackDialog(tenancyFormState, true);
                                        //Navigator.pushNamed(context, RouteNames.Portal);
                                      },
                                      child: Text(
                                        GlobleString.TAF_Back_to_Tenants,
                                        style:
                                            MyStyles.SemiBold(13, myColor.blue),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      _headerView(tenancyFormState)
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  _centerView(tenancyFormState),
                ],
              ),
            );
          }),
    );
  }

  void gotoBack() {
    //Navigator.of(context).pop();
    Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.Portal, (route) => false);
  }

  void showBackDialog(TenancyFormState tenancyFormState, bool goback,
      {int stepper = 0}) {
    if (stepper == tenancyFormState.selectView) return;
    if (!TenancyApplicationFormScreen.changeFormData &&
        !goback &&
        stepper != 0) {
      _store.dispatch(UpdateTenacyFormIndex(stepper));
      //UpdateViewAPI(stepper);
      return;
    }
    if (!TenancyApplicationFormScreen.changeFormData &&
        goback &&
        stepper == 0) {
      gotoBack();
      return;
    }
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.PS_Save_Propertys_msg,
          positiveText: GlobleString.PS_Save_Propertys_yes,
          negativeText: GlobleString.PS_Save_Propertyse_NO,
          onPressedNo: () {
            Navigator.pop(context1);
            if (goback && stepper == 0)
              gotoBack();
            else {
              //UpdateViewAPI(stepper);
              _store.dispatch(UpdateTenacyFormIndex(stepper));
            }
          },
          onPressedYes: () async {
            switch (tenancyFormState.selectView) {
              case 1:
                navigationNotifier.change(
                    back: NavigationConstant.tenancyPersonal,
                    goBack: goback,
                    step: stepper);
                break;
              case 2:
                navigationNotifier.change(
                    back: NavigationConstant.tenancyEmployment,
                    goBack: goback,
                    step: stepper);
                break;
              case 3:
                navigationNotifier.change(
                    back: NavigationConstant.tenancyCurrentTenancy,
                    goBack: goback,
                    step: stepper);
                break;
              case 4:
                navigationNotifier.change(
                    back: NavigationConstant.tenancyotherApplicant,
                    goBack: goback,
                    step: stepper);
                break;
              case 5:
                navigationNotifier.change(
                    back: NavigationConstant.tenancyAdditionalInfo,
                    goBack: goback,
                    step: stepper);
                break;
              case 6:
                navigationNotifier.change(
                    back: NavigationConstant.tenancyReference,
                    goBack: goback,
                    step: stepper);
                break;
            }
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  Widget _headerView(TenancyFormState tenancyFormState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 30.0),
          child: Text(
            GlobleString.TAF_TENANCY_APPLICATION,
            style: MyStyles.Medium(20, myColor.text_color),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width / 2,
            child: RichText(
              textAlign: TextAlign.center,
              maxLines: null,
              text: TextSpan(
                  text: GlobleString.TAF_PROPERT_ADDRESS,
                  style: MyStyles.Medium(18, myColor.text_color),
                  children: [
                    TextSpan(
                      text: " ",
                    ),
                    TextSpan(
                      text: tenancyFormState.property_address,
                      style: MyStyles.Regular(18, myColor.text_color),
                    )
                  ]),
            )),
        Container(
          alignment: Alignment.topCenter,
          width: 800,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 25),
                alignment: Alignment.center,
                color: myColor.black,
                height: 2,
              ),
              _indicator(tenancyFormState)
            ],
          ),
        )
      ],
    );
  }

  Widget _indicator(TenancyFormState tenancyFormState) {
    return Container(
      width: 830,
      margin: EdgeInsets.only(top: 25),
      alignment: Alignment.center,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.TCF_Step1)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 1);
                // _store.dispatch(UpdateTenacyFormIndex(1));
              }
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    Prefs.getBool(PrefsName.TCF_Step1)
                        ? "assets/images/ic_circle_check.png"
                        : "assets/images/ic_circle_fill.png",
                    width: 35,
                    height: 35,
                    alignment: Alignment.topLeft,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  GlobleString.TAF_PERSONAL,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(
            width: 60,
          ),
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.TCF_Step1) ||
                  Prefs.getBool(PrefsName.TCF_Step2)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 2);
                // _store.dispatch(UpdateTenacyFormIndex(2));
              }
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    Prefs.getBool(PrefsName.TCF_Step2)
                        ? "assets/images/ic_circle_check.png"
                        : tenancyFormState.selectView > 2
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 35,
                    height: 35,
                    alignment: Alignment.topLeft,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  GlobleString.TAF_Employment,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(
            width: 60,
          ),
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.TCF_Step3)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 3);
                // _store.dispatch(UpdateTenacyFormIndex(3));
              } else if (Prefs.getBool(PrefsName.TCF_Step1) &&
                  Prefs.getBool(PrefsName.TCF_Step2)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 3);
                // _store.dispatch(UpdateTenacyFormIndex(3));
              }
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    Prefs.getBool(PrefsName.TCF_Step3)
                        ? "assets/images/ic_circle_check.png"
                        : tenancyFormState.selectView > 3
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 35,
                    height: 35,
                    alignment: Alignment.topLeft,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  GlobleString.TAF_Current_tenancy,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(
            width: 60,
          ),
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.TCF_Step4)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 4);
                // _store.dispatch(UpdateTenacyFormIndex(4));
              } else if (Prefs.getBool(PrefsName.TCF_Step1) &&
                  Prefs.getBool(PrefsName.TCF_Step2) &&
                  Prefs.getBool(PrefsName.TCF_Step3)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 4);
                // _store.dispatch(UpdateTenacyFormIndex(4));
              }
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    Prefs.getBool(PrefsName.TCF_Step4)
                        ? "assets/images/ic_circle_check.png"
                        : tenancyFormState.selectView > 4
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 35,
                    height: 35,
                    alignment: Alignment.topLeft,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  GlobleString.TAF_Other_applicants,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(
            width: 60,
          ),
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.TCF_Step5)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 5);
                // _store.dispatch(UpdateTenacyFormIndex(5));
              } else if (Prefs.getBool(PrefsName.TCF_Step1) &&
                  Prefs.getBool(PrefsName.TCF_Step2) &&
                  Prefs.getBool(PrefsName.TCF_Step3) &&
                  Prefs.getBool(PrefsName.TCF_Step4)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 5);
                // _store.dispatch(UpdateTenacyFormIndex(5));
              }
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    Prefs.getBool(PrefsName.TCF_Step5)
                        ? "assets/images/ic_circle_check.png"
                        : tenancyFormState.selectView > 5
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 35,
                    height: 35,
                    alignment: Alignment.topLeft,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  GlobleString.TAF_Additional_Info,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(
            width: 60,
          ),
          InkWell(
            onTap: () {
              /*if (Prefs.getBool(PrefsName.TCF_Step6)) {
                _store.dispatch(UpdateTenacyFormIndex(6));
              } else*/
              if (Prefs.getBool(PrefsName.TCF_Step1) &&
                  Prefs.getBool(PrefsName.TCF_Step2) &&
                  Prefs.getBool(PrefsName.TCF_Step3) &&
                  Prefs.getBool(PrefsName.TCF_Step4) &&
                  Prefs.getBool(PrefsName.TCF_Step5)) {
                RemoveHighLight();
                showBackDialog(tenancyFormState, false, stepper: 6);
                // _store.dispatch(UpdateTenacyFormIndex(6));
              }
            },
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    Prefs.getBool(PrefsName.TCF_Step6)
                        ? "assets/images/ic_circle_check.png"
                        : tenancyFormState.selectView > 6
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 35,
                    height: 35,
                    alignment: Alignment.topLeft,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  GlobleString.TAF_References,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _centerView(TenancyFormState tenancyFormState) {
    switch (tenancyFormState.selectView) {
      case 1:
        {
          return TAFPersonalScreen(
            onPressedSave: () {
              Prefs.setBool(PrefsName.TCF_Step1, true);
              UpdateViewAPI(2);
            },
            onPressGotoback: () => gotoBack(),
            onPressedRecordStep: (int stepper) {
              UpdateViewAPI(stepper);
            },
          );
        }
      case 2:
        {
          //TAFDocumentScreen
          return TAFEmploymentScreen(
            onPressedBack: () {
              if (TenancyApplicationFormScreen.changeFormData)
                showBackDialog(tenancyFormState, false, stepper: 1);
              else
                _store.dispatch(UpdateTenacyFormIndex(1));
            },
            onPressedSave: () {
              Prefs.setBool(PrefsName.TCF_Step2, true);
              UpdateViewAPI(3);
              //_store.dispatch(UpdateTenacyFormIndex(3));
            },
            onPressGotoBack: () => gotoBack(),
            onPressedRecordStep: (int stepper) {
              UpdateViewAPI(stepper);
            },
          );
        }
      case 3:
        {
          return TAFCurrentTenancyScreen(
            onPressedBack: () {
              if (TenancyApplicationFormScreen.changeFormData)
                showBackDialog(tenancyFormState, false, stepper: 2);
              else {
                _store.dispatch(UpdateTenacyFormIndex(2));
              }
            },
            onPressedSave: () {
              Prefs.setBool(PrefsName.TCF_Step3, true);
              UpdateViewAPI(4);
              // _store.dispatch(UpdateTenacyFormIndex(4));
            },
            onPressGotoback: () => gotoBack(),
            onPressedRecordStep: (int stepper) {
              UpdateViewAPI(stepper);
            },
          );
        }
      case 4:
        {
          return TAFAdditionalOccupantsScreen(
            onPressedBack: () {
              if (TenancyApplicationFormScreen.changeFormData)
                showBackDialog(tenancyFormState, false, stepper: 3);
              else
                _store.dispatch(UpdateTenacyFormIndex(3));
            },
            onPressedSave: () {
              Prefs.setBool(PrefsName.TCF_Step4, true);
              UpdateViewAPI(5);
              // _store.dispatch(UpdateTenacyFormIndex(5));
            },
            onPressGotoBack: () => gotoBack(),
            onPressedRecordStep: (int stepper) {
              UpdateViewAPI(stepper);
            },
          );
        }
      case 5:
        {
          return TAFAdditionalInformationScreen(
            onPressedBack: () {
              if (TenancyApplicationFormScreen.changeFormData)
                showBackDialog(tenancyFormState, false, stepper: 4);
              else
                _store.dispatch(UpdateTenacyFormIndex(4));
            },
            onPressedSave: () {
              Prefs.setBool(PrefsName.TCF_Step5, true);
              UpdateViewAPI(6);
              //_store.dispatch(UpdateTenacyFormIndex(6));
            },
            onPressGotoBack: () => gotoBack(),
            onPressedRecordStep: (int stepper) {
              UpdateViewAPI(stepper);
            },
          );
        }
      case 6:
        {
          return TAFAdditionalReferencesScreen(
            onPressedBack: () {
              if (TenancyApplicationFormScreen.changeFormData)
                showBackDialog(tenancyFormState, false, stepper: 5);
              else
                _store.dispatch(UpdateTenacyFormIndex(5));
            },
            onPressedSave: () async {
              _store.dispatch(UpdateTenacyFormIndex(1));

              if (Prefs.getBool(PrefsName.TCF_EditApplicant) != null &&
                  Prefs.getBool(PrefsName.TCF_EditApplicant) != "" &&
                  Prefs.getBool(PrefsName.TCF_EditApplicant) == true) {
                await Prefs.setBool(PrefsName.TCF_Step1, false);
                await Prefs.setBool(PrefsName.TCF_Step2, false);
                await Prefs.setBool(PrefsName.TCF_Step3, false);
                await Prefs.setBool(PrefsName.TCF_Step4, false);
                await Prefs.setBool(PrefsName.TCF_Step5, false);
                await Prefs.setBool(PrefsName.TCF_Step6, false);
                await Prefs.setString(PrefsName.TCF_ApplicantID, "");
                await Prefs.setString(PrefsName.TCF_ApplicationID, "");
                await Prefs.setString(PrefsName.TCF_Current_isReference, "");
                await Prefs.setString(PrefsName.TCF_CurrentlandlordID, "");
                await Prefs.setBool(PrefsName.TCF_EditApplicant, false);

                Navigator.pushNamed(context, RouteNames.Portal);
              } else {
                callNavigate(tenancyFormState);
              }
            },
            onPressGotoBack: () => gotoBack(),
            onPressedRecordStep: (int stepper) {
              UpdateViewAPI(stepper);
            },
          );
        }

      default:
        {
          return TAFPersonalScreen(
            onPressedSave: () {
              _store.dispatch(UpdateTenacyFormIndex(2));
            },
            onPressGotoback: () => gotoBack(),
            onPressedRecordStep: (int stepper) {
              UpdateViewAPI(stepper);
            },
          );
        }
    }
  }

  RemoveHighLight() {
    _store.dispatch(UpdateTFPersonError_perFirstname(false));
    _store.dispatch(UpdateTFPersonError_perLastname(false));
    _store.dispatch(UpdateTFPersonError_dateofbirth(false));
    _store.dispatch(UpdateTFPersonError_perEmail(false));
    _store.dispatch(UpdateTFPersonError_perPhoneNumber(false));

    _store.dispatch(UpdateTFEmploymentError_empstatus(false));
    _store.dispatch(UpdateTFEmploymentError_anualincomestatus(false));
    _store.dispatch(UpdateTFEmploymentError_linkedprofile(false));

    _store.dispatch(UpdateTFCurrenttenantError_startdate(false));
    _store.dispatch(UpdateTFCurrenttenantError_enddate(false));
    _store.dispatch(UpdateTFCurrenttenantError_address(false));
    _store.dispatch(UpdateTFCurrenttenantError_city(false));
    _store.dispatch(UpdateTFCurrenttenantError_province(false));
    _store.dispatch(UpdateTFCurrenttenantError_postalcode(false));
    _store.dispatch(UpdateTFCurrenttenantError_firstname(false));
    _store.dispatch(UpdateTFCurrenttenantError_lastname(false));
    _store.dispatch(UpdateTFCurrenttenantError_email(false));
    _store.dispatch(UpdateTFCurrenttenantError_phonenumber(false));

    _store.dispatch(UpdateTFAdditionalInfoError_tenancystartdate(false));
    _store.dispatch(UpdateTFAdditionalInfoError_PeriodValue(false));
    _store.dispatch(UpdateTFAdditionalInfoError_lenthoftenancynumber(false));
  }

  UpdateViewAPI(int flag) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    apiCallCollection(Prefs.getString(PrefsName.TCF_ApplicantID), flag, true);
  }

  callNavigate(TenancyFormState tenancyFormState) async {
    await Prefs.clear();

    if (tenancyFormState.CustomerFeatureListingURL != null &&
        tenancyFormState.CustomerFeatureListingURL != "") {
      Helper.Log("CustomerFeatureListingURL",
          tenancyFormState.CustomerFeatureListingURL);

      Helper.Log(
          "Url: ",
          Weburl.CustomerFeaturedPage +
              tenancyFormState.CustomerFeatureListingURL);
      html.window.history.pushState(
          null, "", "/" + tenancyFormState.CustomerFeatureListingURL);

      //html.window.location.replace("http://localhost:52031/#/" + tenancyFormState.CustomerFeatureListingURL);
      html.window.location.replace(Weburl.CustomerFeaturedPage +
          tenancyFormState.CustomerFeatureListingURL);

      // html.window.open(
      //     Weburl.CustomerFeaturedPage +
      //         tenancyFormState.CustomerFeatureListingURL,
      //     "_self");
    } else {
      html.window.location.replace(Weburl.silverhomes_url);
    }
  }
}

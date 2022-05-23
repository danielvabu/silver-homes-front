import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/animation/animated_wave.dart';
import 'package:silverhome/common/basic_page.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_questionnaire_actions.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/landlord_models/reference_questionnaire_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

class ReferenceQuestionnaireScreen extends BasePage {
  final String? RID;

  ReferenceQuestionnaireScreen({
    this.RID,
  });

  @override
  _ReferenceQuestionnaireScreenState createState() =>
      _ReferenceQuestionnaireScreenState();
}

class _ReferenceQuestionnaireScreenState
    extends BaseState<ReferenceQuestionnaireScreen> with BasicPage {
  final _store = getIt<AppStore>();

  double height = 0, width = 0;

  bool isloading = true;

  late OverlayEntry loader;
  static List<SystemEnumDetails> lenghtoftenancy = [];

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();
    await ClearAllState();

    if (Prefs.getBool(PrefsName.RC_FillOUT) != null &&
        Prefs.getBool(PrefsName.RC_FillOUT)) {
      lenghtoftenancy.clear();
      lenghtoftenancy =
          QueryFilter().PlainValues(eSystemEnums().ReferenceLenthofTenancy);

      ApiManager().getReferenceDetailsAPi(
          context, Prefs.getString(PrefsName.RC_Referenceid),
          (status, responce) {
        if (status) {
          updatemethod();
        } else {
          if (responce == "1") {
            dailogShow();
          }
          Helper.Log("respoce", responce);
        }
      });
    } else {
      await Prefs.clear();
      await Prefs.setString(PrefsName.RC_Referenceid, widget.RID.toString());

      //await Prefs.setString(PrefsName.RC_Referenceid, "48");

      HttpClientCall().CallAPIToken(context, (error, respoce) async {
        if (error) {
          await Prefs.setString(PrefsName.userTokan, respoce);

          ApiManager().getSystemEnumCallDSQ(context, (error, respoce) async {
            if (error) {
              lenghtoftenancy.clear();
              lenghtoftenancy = QueryFilter()
                  .PlainValues(eSystemEnums().ReferenceLenthofTenancy);

              if (widget.RID != null && widget.RID != "") {
                await Prefs.setString(
                    PrefsName.RC_Referenceid, widget.RID.toString());

                ApiManager().getReferenceDetailsAPi(
                    context, Prefs.getString(PrefsName.RC_Referenceid),
                    (status, responce) {
                  if (status) {
                    updatemethod();
                  } else {
                    if (responce == "1") {
                      dailogShow();
                    }
                    print("respoce >>" + responce);
                  }
                });
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

  ClearAllState() {
    _store.dispatch(UpdateRQLenthTenancy(0));
    _store.dispatch(UpdateRQCleanlinessRating(0));
    _store.dispatch(UpdateRQCommunicationRating(0));
    _store.dispatch(UpdateRQRespectfulnessRating(0));
    _store.dispatch(UpdateRQPaymentPunctualityRating(0));
    _store.dispatch(UpdateRQYesNo(null));
    _store.dispatch(UpdateRQReasonDeparture(""));
    _store.dispatch(UpdateRQOtherComments(""));
    _store.dispatch(UpdateRQApplicantName(""));
    _store.dispatch(UpdateRQApplicantId(""));
    _store.dispatch(UpdateRQReferenceName(""));
    _store.dispatch(UpdateRQReferenceId(""));
    _store.dispatch(UpdateRQApplicationId(""));
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
        child: SingleChildScrollView(
          child: Center(
            child: isloading
                ? Stack(
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
      child: ConnectState<ReferenceQuestionnaireState>(
          map: (state) => state.referenceQuestionnaireState,
          where: notIdentical,
          builder: (refQueState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    _logoTopCorner(refQueState!),
                    _headerView(refQueState)
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                _questionnaries(refQueState),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          }),
    );
  }

  Widget _logoTopCorner(ReferenceQuestionnaireState refQueState) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          refQueState.CompanyLogo != null && refQueState.CompanyLogo!.id != null
              ? InkWell(
                  onTap: () {
                    Helper.urlload(refQueState.HomePagelink);
                  },
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: 250,
                    height: 80,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        fit: BoxFit.contain,
                        alignment: Alignment.topLeft,
                        image: CustomNetworkImage(
                          Weburl.image_API +
                              refQueState.CompanyLogo!.id.toString(),
                          scale: 1.5,
                          headers: {
                            'Authorization': 'bearer ' +
                                Prefs.getString(PrefsName.userTokan),
                            'ApplicationCode': Weburl.API_CODE,
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : Image.asset(
                  "assets/images/silverhome.png",
                  width: 250,
                  height: 40,
                  alignment: Alignment.topLeft,
                ),
          SizedBox(height: 30),
          Prefs.getString(PrefsName.OwnerID) != null &&
                  Prefs.getString(PrefsName.OwnerID) != ""
              ? Container(
                  width: 150,
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.Portal);
                    },
                    child: Text(
                      GlobleString.TAF_Back_to_Tenants,
                      style: MyStyles.SemiBold(13, myColor.blue),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _headerView(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 30.0),
          child: Text(
            GlobleString.Reference_Questionnaire,
            style: MyStyles.Medium(20, myColor.text_color),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                GlobleString.RQ_Applicant,
                style: MyStyles.Medium(18, myColor.text_color),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                refQueState.ApplicantName,
                style: MyStyles.Medium(18, myColor.text_color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                GlobleString.RQ_Reference,
                style: MyStyles.Medium(18, myColor.text_color),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                refQueState.ReferenceName,
                style: MyStyles.Medium(18, myColor.text_color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _questionnaries(ReferenceQuestionnaireState refQueState) {
    return Container(
      height: height - 226,
      child: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: Container(
            width: 750,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _lengthTenancy(refQueState),
                SizedBox(
                  height: 40,
                ),
                reasonDeparture(refQueState),
                SizedBox(
                  height: 40,
                ),
                Text(
                  GlobleString.RQ_question_title,
                  style: MyStyles.SemiBold(16, myColor.text_color),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                _question1(refQueState),
                SizedBox(
                  height: 20,
                ),
                _question2(refQueState),
                SizedBox(
                  height: 20,
                ),
                _question3(refQueState),
                SizedBox(
                  height: 20,
                ),
                _question4(refQueState),
                SizedBox(
                  height: 20,
                ),
                _recommendtenant(refQueState),
                SizedBox(
                  height: 20,
                ),
                _otherComment(refQueState),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_submitButton(refQueState)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lengthTenancy(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.RQ_Length_of_Tenancy,
          style: MyStyles.SemiBold(16, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _store.dispatch(UpdateRQLenthTenancy(1));
              },
              child: CustomeWidget.LenghtOFTenancy(
                  GlobleString.RQ_Under_6_month, refQueState.lenth_tenancy, 1),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                _store.dispatch(UpdateRQLenthTenancy(2));
              },
              child: CustomeWidget.LenghtOFTenancy(
                  GlobleString.RQ_6_months_to_1_year,
                  refQueState.lenth_tenancy,
                  2),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                _store.dispatch(UpdateRQLenthTenancy(3));
              },
              child: CustomeWidget.LenghtOFTenancy(
                  GlobleString.RQ_1_year_to_2_years,
                  refQueState.lenth_tenancy,
                  3),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                _store.dispatch(UpdateRQLenthTenancy(4));
              },
              child: CustomeWidget.LenghtOFTenancy(
                  GlobleString.RQ_Over_2_years, refQueState.lenth_tenancy, 4),
            ),
          ],
        ),
      ],
    );
  }

  Widget reasonDeparture(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.RQ_Reason_For_Departure,
          style: MyStyles.SemiBold(16, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLength: 150,
          initialValue: refQueState.ReasonDeparture,
          textAlign: TextAlign.start,
          style: MyStyles.Regular(14, myColor.text_color),
          maxLines: 5,
          decoration: InputDecoration(
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
              ),
              hintText: GlobleString.RQ_Reason_For_Departure_hint,
              hintStyle: MyStyles.Regular(14, myColor.RQ_hint),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              fillColor: myColor.white,
              filled: true),
          onChanged: (value) {
            _store.dispatch(UpdateRQReasonDeparture(value.toString()));
          },
        ),
      ],
    );
  }

  Widget _question1(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.RQ_question1_title,
          style: MyStyles.SemiBold(14, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            GlobleString.RQ_question1,
            style: MyStyles.Regular(13, myColor.text_color),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                GlobleString.RQ_Poor,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              RatingBar.builder(
                initialRating: refQueState.CleanlinessRating,
                allowHalfRating: false,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: myColor.blue,
                ),
                onRatingUpdate: (rating) {
                  _store.dispatch(UpdateRQCleanlinessRating(rating));
                },
                itemCount: 5,
                itemSize: 20.0,
                unratedColor: myColor.TA_Border,
                direction: Axis.horizontal,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                GlobleString.RQ_Excellent,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _question2(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.RQ_question2_title,
          style: MyStyles.SemiBold(14, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            GlobleString.RQ_question2,
            style: MyStyles.Regular(13, myColor.text_color),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                GlobleString.RQ_Poor,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              RatingBar.builder(
                initialRating: refQueState.CommunicationRating,
                allowHalfRating: false,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: myColor.blue,
                ),
                onRatingUpdate: (rating) {
                  _store.dispatch(UpdateRQCommunicationRating(rating));
                },
                itemCount: 5,
                itemSize: 20.0,
                unratedColor: myColor.TA_Border,
                direction: Axis.horizontal,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                GlobleString.RQ_Excellent,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _question3(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.RQ_question3_title,
          style: MyStyles.SemiBold(14, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            GlobleString.RQ_question3,
            style: MyStyles.Regular(13, myColor.text_color),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                GlobleString.RQ_Poor,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              RatingBar.builder(
                initialRating: refQueState.RespectfulnessRating,
                allowHalfRating: false,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: myColor.blue,
                ),
                onRatingUpdate: (rating) {
                  _store.dispatch(UpdateRQRespectfulnessRating(rating));
                },
                itemCount: 5,
                itemSize: 20.0,
                unratedColor: myColor.TA_Border,
                direction: Axis.horizontal,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                GlobleString.RQ_Excellent,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _question4(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.RQ_question4_title,
          style: MyStyles.SemiBold(14, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            GlobleString.RQ_question4,
            style: MyStyles.Regular(13, myColor.text_color),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                GlobleString.RQ_Poor,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              RatingBar.builder(
                initialRating: refQueState.PaymentPunctualityRating,
                allowHalfRating: false,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: myColor.blue,
                ),
                onRatingUpdate: (rating) {
                  _store.dispatch(UpdateRQPaymentPunctualityRating(rating));
                },
                itemCount: 5,
                itemSize: 20.0,
                unratedColor: myColor.TA_Border,
                direction: Axis.horizontal,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                GlobleString.RQ_Excellent,
                style: MyStyles.Regular(12, myColor.RQ_rating),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recommendtenant(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.RQ_question5_title,
          style: MyStyles.SemiBold(14, myColor.text_color),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _store.dispatch(UpdateRQYesNo(true));
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/ic_like.png",
                      width: 20,
                      height: 20,
                      color: refQueState.yesNo == null
                          ? myColor.black
                          : refQueState.yesNo!
                              ? myColor.blue
                              : myColor.black,
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      GlobleString.RQ_Yes,
                      style: MyStyles.Medium(
                          14,
                          refQueState.yesNo == null
                              ? myColor.text_color
                              : refQueState.yesNo!
                                  ? myColor.blue
                                  : myColor.text_color),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  _store.dispatch(UpdateRQYesNo(false));
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/ic_unlike.png",
                      width: 20,
                      height: 20,
                      color: refQueState.yesNo == null
                          ? myColor.black
                          : refQueState.yesNo == false
                              ? myColor.blue
                              : myColor.black,
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      GlobleString.RQ_No,
                      style: MyStyles.Medium(
                          14,
                          refQueState.yesNo == null
                              ? myColor.text_color
                              : refQueState.yesNo == false
                                  ? myColor.blue
                                  : myColor.text_color),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _otherComment(ReferenceQuestionnaireState refQueState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              GlobleString.RQ_Other_Comments,
              style: MyStyles.SemiBold(16, myColor.text_color),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              GlobleString.Optional,
              style: MyStyles.Regular(13, myColor.optional),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLength: 500,
          initialValue: refQueState.OtherComments,
          textAlign: TextAlign.start,
          style: MyStyles.Regular(14, myColor.text_color),
          maxLines: 5,
          decoration: InputDecoration(
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
              ),
              hintText: GlobleString.RQ_Other_Comments_hint,
              hintStyle: MyStyles.Regular(14, myColor.RQ_hint),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              fillColor: myColor.white,
              filled: true),
          onChanged: (value) {
            _store.dispatch(UpdateRQOtherComments(value.toString()));
          },
        ),
      ],
    );
  }

  Widget _submitButton(ReferenceQuestionnaireState refQueState) {
    return InkWell(
      onTap: () {
        if (refQueState.lenth_tenancy == null ||
            refQueState.lenth_tenancy == 0) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_LengthofTenancy, false);
        } else if (refQueState.ReasonDeparture == null ||
            refQueState.ReasonDeparture.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_reasonfordeparture, false);
        } else if (refQueState.CleanlinessRating == null ||
            refQueState.CleanlinessRating == 0) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_Cleanliness, false);
        } else if (refQueState.CommunicationRating == null ||
            refQueState.CommunicationRating == 0) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_communication, false);
        } else if (refQueState.RespectfulnessRating == null ||
            refQueState.RespectfulnessRating == 0) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_respectfulness, false);
        } else if (refQueState.PaymentPunctualityRating == null ||
            refQueState.PaymentPunctualityRating == 0) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_PaymentPunctuality, false);
        } else if (refQueState.yesNo == null) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_recommendtenant, false);
        }
        /*else if (refQueState.OtherComments == null ||
            refQueState.OtherComments.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.RQ_Error_OtherComments, false);
        }*/
        else {
          //ToastUtils.showCustomToast(context, "Success", true);

          if (refQueState.isUpdate) {
            updateQuestionnairai(refQueState);
          } else {
            insertQuestionnairai(refQueState);
          }
        }
      },
      child: CustomeWidget.FillButton(35, GlobleString.TVD_Submit, true),
    );
  }

  updateQuestionnairai(ReferenceQuestionnaireState refQueState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    UpdateReferenceAnswersID commonID = new UpdateReferenceAnswersID();
    commonID.AdditionalReferencesID = Prefs.getString(PrefsName.RC_Referenceid);

    InsertReferenceAnswers insertReferenceAnswers =
        new InsertReferenceAnswers();
    insertReferenceAnswers.additionalReferencesID =
        Prefs.getString(PrefsName.RC_Referenceid);
    insertReferenceAnswers.lengthOfTenancy =
        refQueState.lenth_tenancy.toString();
    insertReferenceAnswers.reasonForDeparture =
        refQueState.ReasonDeparture.toString();
    insertReferenceAnswers.cleanliness =
        refQueState.CleanlinessRating.toString();
    insertReferenceAnswers.communication =
        refQueState.CommunicationRating.toString();
    insertReferenceAnswers.respectfulness =
        refQueState.RespectfulnessRating.toString();
    insertReferenceAnswers.paymentPunctuality =
        refQueState.PaymentPunctualityRating.toString();
    insertReferenceAnswers.isRecommendedTenant = refQueState.yesNo;
    insertReferenceAnswers.otherComments = refQueState.OtherComments.toString();

    ApiManager().UpdateReferenceAnswere(
        context, commonID, insertReferenceAnswers, (error, respoce) async {
      if (error) {
        UpdateReferenceReceiveDateAndNotification(refQueState);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  insertQuestionnairai(ReferenceQuestionnaireState refQueState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    InsertReferenceAnswers insertReferenceAnswers =
        new InsertReferenceAnswers();
    insertReferenceAnswers.additionalReferencesID =
        Prefs.getString(PrefsName.RC_Referenceid);
    insertReferenceAnswers.lengthOfTenancy =
        refQueState.lenth_tenancy.toString();
    insertReferenceAnswers.reasonForDeparture =
        refQueState.ReasonDeparture.toString();
    insertReferenceAnswers.cleanliness =
        refQueState.CleanlinessRating.toString();
    insertReferenceAnswers.communication =
        refQueState.CommunicationRating.toString();
    insertReferenceAnswers.respectfulness =
        refQueState.RespectfulnessRating.toString();
    insertReferenceAnswers.paymentPunctuality =
        refQueState.PaymentPunctualityRating.toString();
    insertReferenceAnswers.isRecommendedTenant = refQueState.yesNo;
    insertReferenceAnswers.otherComments = refQueState.OtherComments.toString();

    ApiManager().InsertReferenceAnswere(context, insertReferenceAnswers,
        (error, respoce) async {
      if (error) {
        UpdateReferenceReceiveDateAndNotification(refQueState);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  UpdateReferenceReceiveDateAndNotification(
      ReferenceQuestionnaireState refQueState) {
    String date =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString();

    if (Prefs.getBool(PrefsName.RC_FillOUT) != null &&
        Prefs.getBool(PrefsName.RC_FillOUT)) {
      ApiManager().UpdateReferenceReceiveDate(
          context, refQueState.ApplicationId, refQueState.ReferenceId, date,
          (error, respoce) async {
        if (error) {
          loader.remove();
          successdailogShow(refQueState);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, respoce, false);
        }
      });
    } else {
      ApiManager().NotificationReferenceReceive(
          context, refQueState.ApplicationId, refQueState.ReferenceId, date,
          (error, respoce) async {
        if (error) {
          loader.remove();
          successdailogShow(refQueState);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, respoce, false);
        }
      });
    }
  }

  successdailogShow(ReferenceQuestionnaireState refQueState) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.dailog_reference_questionanry_close,
          title: GlobleString.dailog_reference_questionanry,
          onPressed: () async {
            Navigator.of(context).pop();
            if (Prefs.getBool(PrefsName.RC_FillOUT) != null &&
                Prefs.getBool(PrefsName.RC_FillOUT)) {
              await Prefs.setBool(PrefsName.RC_FillOUT, false);
              await Prefs.setString(PrefsName.RC_Referenceid, "");
              await Prefs.setString(PrefsName.RC_ApplicantID, "");
              await Prefs.setString(PrefsName.RC_ApplicationID, "");

              Navigator.pushNamed(context, RouteNames.Portal);
            } else {
              await Prefs.clear();

              //await navigateTo(context, RouteNames.Login);
              //html.window.location.replace(Weburl.CustomerFeaturedPage + "login");

              if (refQueState.CustomerFeatureListingURL != null &&
                  refQueState.CustomerFeatureListingURL != "") {
                Helper.Log("CustomerFeatureListingURL",
                    refQueState.CustomerFeatureListingURL);

                Helper.Log(
                    "Url: ",
                    Weburl.CustomerFeaturedPage +
                        refQueState.CustomerFeatureListingURL);

                html.window.history.pushState(
                    null, "", "/" + refQueState.CustomerFeatureListingURL);

                //html.window.location.replace("http://localhost:52031/#/" + tenancyFormState.CustomerFeatureListingURL);
                html.window.location.replace(Weburl.CustomerFeaturedPage +
                    refQueState.CustomerFeatureListingURL);

                /* html.window.open(
                    Weburl.CustomerFeaturedPage +
                        refQueState.CustomerFeatureListingURL,
                    "_self");*/
              } else {
                html.window.location.replace(Weburl.silverhomes_url);
              }
            }
          },
        );
      },
    );
  }
}

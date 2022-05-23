import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/animation/animated_wave.dart';
import 'package:silverhome/common/basic_page.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancy_varification_doc_actions.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/screens/landlord/varificationDocument/varification_document.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

import '../../../models/landlord_models/tenancy_varification_doc_state.dart';

class TenancyVerificationDocumentScreen extends BasePage {
  final String? applicantID;

  TenancyVerificationDocumentScreen({
    this.applicantID,
  });

  @override
  _TenancyVerificationDocumentScreenState createState() =>
      _TenancyVerificationDocumentScreenState();
}

class _TenancyVerificationDocumentScreenState
    extends BaseState<TenancyVerificationDocumentScreen> with BasicPage {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  bool isloading = true;
  late OverlayEntry loader;

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    await Prefs.clear();
    await ClearAllState();

    await Prefs.setString(
        PrefsName.TCF_ApplicantID, widget.applicantID.toString());

    //await Prefs.setString(PrefsName.TCF_ApplicantID, "2263");

    HttpClientCall().CallAPIToken(context, (error, respoce) async {
      if (error) {
        Helper.Log("respoce", respoce);
        await Prefs.setString(PrefsName.userTokan, respoce);

        if (widget.applicantID != null && widget.applicantID != "") {
          await Prefs.setString(
              PrefsName.TCF_ApplicantID, widget.applicantID.toString());
          ApiManager().getTenancyVarificationDocumentData(
              context, Prefs.getString(PrefsName.TCF_ApplicantID),
              (status, responce) async {
            if (status) {
              await ApiManager().getTenancyVarificationDocumentList(
                  context,
                  Prefs.getString(PrefsName.TCF_ApplicantID),
                  (status, responce) {});
              updatemethod();
            } else {
              if (responce == "1") {
                dailogShow();
              }
              Helper.Log("respoce", responce);
            }
          });
        }
      } else {
        Helper.Log("respoce", respoce);
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

  ClearAllState() {
    _store.dispatch(UpdateTVDDocs1FileName(""));
    _store.dispatch(UpdateTVDDocs1FileExtension(""));
    _store.dispatch(UpdateTVDUint8ListDocs1File(null));
    _store.dispatch(UpdateTVDIsbuttonActive(false));

    _store.dispatch(UpdateTVDDocs2FileName(""));
    _store.dispatch(UpdateTVDDocs2FileExtension(""));
    _store.dispatch(UpdateTVDUint8ListDocs2File(null));

    _store.dispatch(UpdateTVDDocs3FileName(""));
    _store.dispatch(UpdateTVDDocs3FileExtension(""));
    _store.dispatch(UpdateTVDUint8ListDocs3File(null));

    _store.dispatch(UpdateTVDDocs4FileName(""));
    _store.dispatch(UpdateTVDDocs4FileExtension(""));
    _store.dispatch(UpdateTVDUint8ListDocs4File(null));

    _store.dispatch(UpdateTVDNotapplicableDoc3(false));
    _store.dispatch(UpdateTVDNotapplicableDoc4(false));
    _store.dispatch(UpdateTVDPropertyAddress(""));
    _store.dispatch(UpdateTVDApplicantID(""));

    _store.dispatch(UpdateTVDMIDDoc1(""));
    _store.dispatch(UpdateTVDMIDDoc2(""));
    _store.dispatch(UpdateTVDMIDDoc3(""));
    _store.dispatch(UpdateTVDMIDDoc4(""));

    _store.dispatch(UpdateTVDMediaInfo1(null));
    _store.dispatch(UpdateTVDMediaInfo2(null));
    _store.dispatch(UpdateTVDMediaInfo3(null));
    _store.dispatch(UpdateTVDMediaInfo4(null));

    _store.dispatch(UpdateTVDCompanyName(""));
    _store.dispatch(UpdateTVDHomePagelink(""));
    _store.dispatch(UpdateTVDCompanyLogo(null));
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
      child: ConnectState<TenancyVarificationDocumentState>(
          map: (state) => state.tenancyVarificationDocumentState,
          where: notIdentical,
          builder: (TVDState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    TVDState!.CompanyLogo != null &&
                            TVDState.CompanyLogo!.id != null
                        ? InkWell(
                            onTap: () {
                              Helper.urlload(TVDState.HomePagelink);
                            },
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Container(
                              width: 250,
                              height: 80,
                              margin: EdgeInsets.only(top: 20.0, left: 30),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                  alignment: Alignment.topLeft,
                                  fit: BoxFit.contain,
                                  image: CustomNetworkImage(
                                    Weburl.image_API +
                                        TVDState.CompanyLogo!.id.toString(),
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
                        : Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 20.0, left: 30),
                            child: Image.asset(
                              "assets/images/silverhome.png",
                              width: 250,
                              height: 50,
                              alignment: Alignment.topLeft,
                            ),
                          ),
                    _headerView(TVDState)
                  ],
                ),
                SizedBox(
                  height: 120,
                ),
                VarificationDocumentView(
                  onPressedSave: () {
                    opensuccessDialog(TVDState);
                  },
                ),
              ],
            );
          }),
    );
  }

  Widget _headerView(TenancyVarificationDocumentState? TVDState) {
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
            //maxLines: 2,
            //overflow: TextOverflow.ellipsis,
            text: TextSpan(
                text: GlobleString.TAF_PROPERT_ADDRESS,
                style: MyStyles.Medium(18, myColor.text_color),
                children: [
                  TextSpan(
                    text: " ",
                  ),
                  TextSpan(
                    text: TVDState!.propertyAddress,
                    style: MyStyles.Regular(18, myColor.text_color),
                  )
                ]),
          ),
        ),
      ],
    );
  }

  opensuccessDialog(TenancyVarificationDocumentState tvdState) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.dailog_finish,
          title: GlobleString.dailog_varification_document,
          onPressed: () async {
            Navigator.of(context).pop();

            final String id = '__file_picker_web-file-input';
            var element = html.document.getElementById(id);
            if (element != null) {
              element.remove();
            }

            callNavigate(tvdState);
          },
        );
      },
    );
  }

  callNavigate(TenancyVarificationDocumentState tvdState) async {
    await Prefs.clear();

    if (tvdState.CustomerFeatureListingURL != null &&
        tvdState.CustomerFeatureListingURL != "") {
      Helper.Log(
          "CustomerFeatureListingURL", tvdState.CustomerFeatureListingURL);

      Helper.Log("Url: ",
          Weburl.CustomerFeaturedPage + tvdState.CustomerFeatureListingURL);

      html.window.open(
          Weburl.CustomerFeaturedPage + tvdState.CustomerFeatureListingURL,
          "_self");
    } else {
      html.window.location.replace(Weburl.silverhomes_url);
    }
  }

  checkbuttonActive(TenancyVarificationDocumentState? TVDState) {
    if (TVDState!.docs1_filename != "" &&
        TVDState.docs2_filename != "" &&
        (TVDState.docs3_filename != "" || TVDState.notapplicable_doc3) &&
        (TVDState.docs4_filename != "" || TVDState.notapplicable_doc4)) {
      _store.dispatch(UpdateTVDIsbuttonActive(true));
    } else {
      _store.dispatch(UpdateTVDIsbuttonActive(false));
    }
  }
}

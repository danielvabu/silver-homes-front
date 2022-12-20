import 'dart:html' as html;
import 'dart:math';

import 'package:file_picker/file_picker.dart';
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
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancy_lease_agreement_actions.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/landlord_models/tenancy_lease_agreement_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';

class TenancyLeaseAgreementScreen extends BasePage {
  final String? ApplicationID;

  TenancyLeaseAgreementScreen({
    this.ApplicationID,
  });

  @override
  _TenancyLeaseAgreementScreenState createState() =>
      _TenancyLeaseAgreementScreenState();
}

class _TenancyLeaseAgreementScreenState
    extends BaseState<TenancyLeaseAgreementScreen> with BasicPage {
  final _store = getIt<AppStore>();
  double height = 0, width = 0;
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
        PrefsName.TCF_ApplicationID, widget.ApplicationID.toString());

    //await Prefs.setString(PrefsName.TCF_ApplicationID, "2256");

    HttpClientCall().CallAPIToken(context, (error, respoce) async {
      if (error) {
        Helper.Log("Tokan", respoce);
        await Prefs.setString(PrefsName.userTokan, respoce);

        if (widget.ApplicationID != null && widget.ApplicationID != "") {
          await Prefs.setString(
              PrefsName.TCF_ApplicationID, widget.ApplicationID.toString());

          ApiManager().getLeaseDetailsView(
              context, Prefs.getString(PrefsName.TCF_ApplicationID),
              (status, responce) async {
            if (status) {
              await ApiManager().LeaseAgreementDoc(
                  context, Prefs.getString(PrefsName.TCF_ApplicationID),
                  (status, responce) {
                updatemethod();
              });
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

  ClearAllState() {
    _store.dispatch(UpdateTLADocsFileName(""));
    _store.dispatch(UpdateTLADocsFileExtension(""));
    _store.dispatch(UpdateTLAUint8ListDocsFile(null));
    _store.dispatch(UpdateTLAIsbuttonActive(false));
    _store.dispatch(UpdateTLAIsDocAvailable(false));

    _store.dispatch(UpdateTLAPropertyAddress(""));
    _store.dispatch(UpdateTLAProp_ID(""));
    _store.dispatch(UpdateTLAOwner_ID(""));
    _store.dispatch(UpdateTLAApplicantID(""));

    _store.dispatch(UpdateTLAMIDDoc1(""));
    _store.dispatch(UpdateTLAMIDDoc2(""));

    _store.dispatch(UpdateTLAMediaInfo1(null));
    _store.dispatch(UpdateTLAMediaInfo2(null));

    _store.dispatch(UpdateTLACompanyName(""));
    _store.dispatch(UpdateTLAHomePagelink(""));
    _store.dispatch(UpdateTLACompanyLogo(null));
  }

  void updatemethod() {
    setState(() {
      isloading = false;
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
      child: ConnectState<TenancyLeaseAgreementState>(
          map: (state) => state.tenancyLeaseAgreementState,
          where: notIdentical,
          builder: (leaseagreementstate) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    leaseagreementstate!.CompanyLogo != null &&
                            leaseagreementstate.CompanyLogo!.id != null
                        ? InkWell(
                            onTap: () {
                              Helper.urlload(leaseagreementstate.HomePagelink);
                            },
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: 20.0, left: 30),
                              width: 250,
                              height: 80,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                  alignment: Alignment.topLeft,
                                  fit: BoxFit.contain,
                                  image: CustomNetworkImage(
                                    Weburl.image_API +
                                        leaseagreementstate.CompanyLogo!.id
                                            .toString(),
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
                    _headerView(leaseagreementstate)
                  ],
                ),
                SizedBox(
                  height: 120,
                ),
                _documentAttech(leaseagreementstate)
              ],
            );
          }),
    );
  }

  Widget _headerView(TenancyLeaseAgreementState leaseagreementstate) {
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
                    text: leaseagreementstate.propertyAddress != null
                        ? leaseagreementstate.propertyAddress
                        : "",
                    style: MyStyles.Regular(18, myColor.text_color),
                  )
                ]),
          ),
        ),
      ],
    );
  }

  Widget _documentAttech(TenancyLeaseAgreementState leaseagreementstate) {
    return Container(
      width: 1200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              GlobleString.TLA_title,
              style: MyStyles.Medium(20, myColor.text_color),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  GlobleString.TLA_doc1,
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () {
                      if (leaseagreementstate.MediaDoc1 != null) {
                        Helper.launchURL(
                            leaseagreementstate.MediaDoc1!.url.toString());
                      }
                    },
                    child: Text(
                      Helper.FileName(leaseagreementstate.MediaDoc1!.url!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyStyles.Medium(12, myColor.blue),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (leaseagreementstate.MediaDoc1 != null &&
                            leaseagreementstate.MediaDoc1!.url != null &&
                            leaseagreementstate.MediaDoc1!.url != "") {
                          await Helper.download(
                              context,
                              leaseagreementstate.MediaDoc1!.url.toString(),
                              leaseagreementstate.MediaDoc1!.id.toString(),
                              Helper.FileNameWithTime(
                                  leaseagreementstate.MediaDoc1!.url!),
                              1);
                        }
                      },
                      child:
                          CustomeWidget.LeaseButton(GlobleString.TLA_Download),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      GlobleString.TLA_doc2,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      child: leaseagreementstate.docs_filename == ""
                          ? Container(
                              width: 20,
                              height: 20,
                            )
                          : Image.asset(
                              "assets/images/ic_circle_check.png",
                              width: 20,
                              height: 20,
                              alignment: Alignment.topLeft,
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: CustomeWidget.LeaseButton(GlobleString.TVD_Attach),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 250,
                      child: leaseagreementstate.docs_filename == ""
                          ? Text(
                              "",
                              style: MyStyles.Medium(12, myColor.blue),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            )
                          : Text(
                              leaseagreementstate.docs_filename,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: MyStyles.Medium(12, myColor.blue),
                              textAlign: TextAlign.start,
                            ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    leaseagreementstate.docs_filename == ""
                        ? SizedBox()
                        : InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              deleteAttechment();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/ic_delete.png",
                                height: 25,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_submitButton(leaseagreementstate)],
          ),
        ],
      ),
    );
  }

  deleteAttechment() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.TVD_Document_Delet,
          positiveText: GlobleString.TVD_Document_btn_yes,
          negativeText: GlobleString.TVD_Document_btn_No,
          onPressedYes: () {
            Navigator.of(context1).pop();

            _store.dispatch(UpdateTLADocsFileName(""));
            _store.dispatch(UpdateTLADocsFileExtension(""));
            _store.dispatch(UpdateTLAUint8ListDocsFile(null));
            _store.dispatch(UpdateTLAIsbuttonActive(false));
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      if ((file.size / 1024) > 10240) {
        ToastUtils.showCustomToast(
            context, GlobleString.TVD_Document_Image_Size_error, false);
      } else if ((file.name.split('.').last).contains("pdf") ||
          (file.name.split('.').last).contains("PDF")) {
        _store.dispatch(UpdateTLADocsFileExtension("pdf"));
        _store.dispatch(UpdateTLADocsFileName(file.name.toString()));
        _store.dispatch(UpdateTLAUint8ListDocsFile(file.bytes));
        _store.dispatch(UpdateTLAIsbuttonActive(true));

        setState(() {});
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.TVD_Agreement_Image_error, false);
      }
    }

    final String id = '__file_picker_web-file-input';
    var element = html.document.getElementById(id);
    if (element != null) {
      element.remove();
    }
  }

  Widget _submitButton(TenancyLeaseAgreementState leaseagreementstate) {
    return InkWell(
      onTap: () {
        if (leaseagreementstate.isbuttonActive) {
          validation(leaseagreementstate);
        }
      },
      child: CustomeWidget.FillButton(
          35, GlobleString.TVD_Submit, leaseagreementstate.isbuttonActive),
    );
  }

  validation(TenancyLeaseAgreementState leaseagreementstate) {
    if (leaseagreementstate.docs_file == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.TLA_Document_error, false);
    } else {
      ApiCallDocument(leaseagreementstate);
    }
  }

  ApiCallDocument(TenancyLeaseAgreementState? leaseagreementstate) {
    if (leaseagreementstate!.IsDocAvailable) {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      CommonID? mediadoc1 = null;

      if (leaseagreementstate.MediaDoc2 != null) {
        mediadoc1 = new CommonID();
        mediadoc1.ID = leaseagreementstate.MediaDoc2!.id.toString();
      }

      DeletePropertyDocument applicantDoc = new DeletePropertyDocument();
      applicantDoc.Applicant_ID = leaseagreementstate.ApplicantID;
      applicantDoc.Prop_ID = leaseagreementstate.Prop_ID;
      applicantDoc.IsOwneruploaded = "false";

      ApiManager().TLAMediaInfoDelete(context, mediadoc1, applicantDoc,
          (status, responce) {
        if (status) {
          loader.remove();
          insertApiCall(leaseagreementstate);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      insertApiCall(leaseagreementstate);
    }
  }

  insertApiCall(TenancyLeaseAgreementState? leaseagreementstate) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().TenantLeaseAgreementUpload(
        context,
        leaseagreementstate!.docs_file,
        leaseagreementstate.docs_filename, (status, responce) {
      if (status) {
        InsertPropertyDocument ipd = new InsertPropertyDocument();
        ipd.Prop_ID = leaseagreementstate.Prop_ID;
        ipd.Media_ID = responce;
        ipd.IsOwneruploaded = false;
        ipd.Applicant_ID = leaseagreementstate.ApplicantID;
        ipd.Owner_ID = leaseagreementstate.Owner_ID;
        ipd.Application_ID = leaseagreementstate.Application_ID;

        ApiManager().InsetPropertyDocument(context, ipd, (status, responce) {
          if (status) {
            NotificationCall(leaseagreementstate);
          } else {
            loader.remove();
            ToastUtils.showCustomToast(context, responce, false);
          }
        });
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  NotificationCall(TenancyLeaseAgreementState leaseagreementstate) {
    ApiManager().NotificationLeaseReceive(
        context, Prefs.getString(PrefsName.TCF_ApplicationID),
        (status, responce) async {
      if (status) {
        loader.remove();
        successDailog(leaseagreementstate);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.Error1, false);
      }
    });
  }

  successDailog(TenancyLeaseAgreementState leaseagreementstate) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MessageDialogBox(
          buttontitle: GlobleString.dailog_lease_agreement_close,
          title: GlobleString.dailog_lease_agreement,
          onPressed: () {
            Navigator.of(context1).pop();

            final String id = '__file_picker_web-file-input';
            var element = html.document.getElementById(id);
            if (element != null) {
              element.remove();
            }

            callNavigate(leaseagreementstate);
          },
        );
      },
    );
  }

  callNavigate(TenancyLeaseAgreementState leaseagreementstate) async {
    await Prefs.clear();

    //await navigateTo(context, RouteNames.Login);

    //html.window.location.replace(Weburl.CustomerFeaturedPage + "login");

    if (leaseagreementstate.CustomerFeatureListingURL != null &&
        leaseagreementstate.CustomerFeatureListingURL != "") {
      Helper.Log("CustomerFeatureListingURL",
          leaseagreementstate.CustomerFeatureListingURL);

      Helper.Log(
          "Url: ",
          Weburl.CustomerFeaturedPage +
              leaseagreementstate.CustomerFeatureListingURL);

      html.window.open(
          Weburl.CustomerFeaturedPage +
              leaseagreementstate.CustomerFeatureListingURL,
          "_self");
    } else {
      html.window.location.replace(Weburl.silverhomes_url);
    }
  }
}

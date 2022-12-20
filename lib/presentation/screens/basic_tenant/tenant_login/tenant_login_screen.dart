import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:silverhome/animation/animated_wave.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_portal_action.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';
import 'package:silverhome/widget/basic_tenant/tenant_forgot_pw_dialogbox.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';

class TenantLoginScreen extends StatefulWidget {
  const TenantLoginScreen({
    this.Companyname,
  });

  final String? Companyname;

  @override
  _TenantLoginScreenState createState() => _TenantLoginScreenState();
}

class _TenantLoginScreenState extends State<TenantLoginScreen> {
  final _store = getIt<AppStore>();

  bool passwordVisible = true;
  final _textloginEmail = TextEditingController();
  final _textloginPass = TextEditingController();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  final FocusNode fnemail = FocusNode();
  final FocusNode fnpass = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  double height = 0, width = 0;

  bool isloading = true;
  bool isError = false;
  bool isNoDatafound = false;

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();
    await Prefs.clear();

    //_textloginEmail.text = "techextensor958@gmail.com";
    //_textloginPass.text = "Kk@123456";

    if (widget.Companyname != null && widget.Companyname!.isNotEmpty) {
      HttpClientCall().CallAPIToken(context, (error, respoce) async {
        if (error) {
          Helper.Log("responce", respoce);
          await Prefs.setString(PrefsName.userTokan, respoce);

          await Prefs.setString(
              PrefsName.BT_CustomerFeatureListingURL, widget.Companyname!);

          ApiManager().CompanyDetailsDSQCall(
              context, widget.Companyname.toString(), (error1, respoce2) async {
            if (error1) {
              updateLoding();
            } else {
              updateError();
            }
          });
        } else {
          Helper.Log("respoce", respoce);
        }
      });
    } else {
      updateError();
    }
  }

  void updateError() {
    setState(() {
      isloading = false;
      isError = true;
    });
  }

  void updateLoding() {
    setState(() {
      isloading = false;
      isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
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
            : isError
                ? _errorPage()
                : loginview(),
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

  Widget _errorPage() {
    return Container(
      width: width,
      height: height,
      color: Colors.black12,
      alignment: Alignment.center,
      child: Container(
        width: width / 2,
        height: 300,
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: myColor.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 80, minHeight: 80, maxWidth: 380, minWidth: 380),
                child: Image.asset(
                  "assets/images/silverhome.png",
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Sorry, the page you are looking for is currently unavailable. Please contact us for guidance.",
              textAlign: TextAlign.center,
              style: MyStyles.Bold(20, myColor.black),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Helper.launchURL(Weburl.silverhomes_contact_mail);
              },
              child: Text(
                Weburl.silverhomes_contact_url,
                textAlign: TextAlign.center,
                style: MyStyles.Medium(20, myColor.email_color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginview() {
    return Container(
      width: width / 2,
      height: 427,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: myColor.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Prefs.getString(PrefsName.BT_CompanyLogoid) != null &&
                  Prefs.getString(PrefsName.BT_CompanyLogoid).isNotEmpty
              ? Container(
                  width: 380,
                  height: 80,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      image: CustomNetworkImage(
                        Weburl.image_API +
                            Prefs.getString(PrefsName.BT_CompanyLogoid),
                        scale: 1.5,
                        headers: {
                          'Authorization':
                              'bearer ' + Prefs.getString(PrefsName.userTokan),
                          'ApplicationCode': Weburl.API_CODE,
                        },
                      ),
                    ),
                  ),
                )
              : Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 80,
                        minHeight: 80,
                        maxWidth: 380,
                        minWidth: 380),
                    child: Image.asset(
                      "assets/images/silverhome.png",
                    ),
                  ),
                ),
          SizedBox(height: 15),
          // Prefs.getString(PrefsName.BT_CompanyName) != null &&
          //         Prefs.getString(PrefsName.BT_CompanyName).isNotEmpty
          //     ? Text(
          //         Prefs.getString(PrefsName.BT_CompanyName),
          //         textAlign: TextAlign.center,
          //         style: MyStyles.Medium(14, myColor.black),
          //       )
          //     : Container(),
          Text(
            GlobleString.LogIn_title,
            textAlign: TextAlign.center,
            style: MyStyles.Medium(20, myColor.black),
          ),
          emailPasswordWidget(),
          SizedBox(
            height: 10,
          ),
          loginbutton(),
          forgotpassword(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget emailPasswordWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 10),
      child: FocusScope(
        node: _focusScopeNode,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textloginEmail,
              focusNode: fnemail,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: myColor.blue, width: 2.0),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 1.0)),
                fillColor: myColor.white,
                hintText: GlobleString.email,
                hintStyle: MyStyles.Regular(16, myColor.Circle_main),
                labelStyle: MyStyles.Regular(16, myColor.Circle_main),
              ),
              onSubmitted: (value) {
                fnemail.unfocus();
                FocusScope.of(context).requestFocus(fnpass);
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _textloginPass,
              focusNode: fnpass,
              obscureText: passwordVisible,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: myColor.blue, width: 2),
                ),
                focusColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 1.0),
                ),
                fillColor: myColor.white,
                hintText: GlobleString.password,
                hintStyle: MyStyles.Regular(16, myColor.Circle_main),
                labelStyle: MyStyles.Regular(16, myColor.Circle_main),
              ),
              onSubmitted: (value) {
                fnpass.unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget loginbutton() {
    return InkWell(
      onTap: () {
        String email = _textloginEmail.text.toString().trim();
        String password = _textloginPass.text.toString().trim();

        if (email.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.login_error_email, false);
        } else if (Helper.ValidEmail(email) != true) {
          ToastUtils.showCustomToast(
              context, GlobleString.login_error_valid_email, false);
        } else if (password.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.login_error_password, false);
        } else {
          apiCall(email, password, context);
        }
      },
      child: Container(
        height: 45,
        padding: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: myColor.Circle_main,
        ),
        child: Text(
          GlobleString.LogIn,
          style: MyStyles.Medium(14, myColor.white),
        ),
      ),
    );
  }

  Widget forgotpassword() {
    return Container(
      height: 20,
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black45,
                useSafeArea: true,
                barrierDismissible: false,
                builder: (BuildContext context1) {
                  return TenantForgotPWDialogBox(
                    onPressedSave: () {
                      Navigator.of(context1).pop();
                    },
                    onPressedClose: () {
                      Navigator.of(context1).pop();
                    },
                  );
                },
              );
            },
            child: Text(
              GlobleString.forgotpassword,
              style: MyStyles.Medium(14, myColor.blue),
            ),
          )
        ],
      ),
    );
  }

  apiCall(String email, String password, BuildContext context) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().TenantLoginApi(context, email, password,
        (error, respoce1) async {
      if (error) {
        String UserID = respoce1;
        CheckUserData check = new CheckUserData();
        check.UserID = respoce1;

        var myjson = {
          "DSQID": Weburl.DSQ_tenant_Details.toString(),
          "LoadLookupValues": true,
          "Reqtokens": {"UserID": UserID}
        };

        String json = jsonEncode(myjson);

        ApiManager().tenant_Details_DSQCall(context, json, (error, respoce2) {
          if (error) {
            ApiManager().getApplicationByApplicant(
                context, Prefs.getString(PrefsName.BT_ApplicantID),
                (error, respoce3) {
              if (error) {
                ApiManager().getSystemEnumCallDSQ(context,
                    (error, respoce4) async {
                  if (error) {
                    loader.remove();
                    _store.dispatch(UpdateTenantPortalPage(
                        0, GlobleString.NAV_admin_Overview));

                    await Prefs.setString(
                        PrefsName.BT_CustomerFeatureListingURL,
                        widget.Companyname!);

                    Navigator.pushNamed(
                        context,
                        "/" +
                            Prefs.getString(
                                PrefsName.BT_CustomerFeatureListingURL) +
                            "/" +
                            RouteNames.Basic_Tenant_Portal);
                  } else {
                    loader.remove();
                    ToastUtils.showCustomToast(context, respoce4, false);
                  }
                });
              } else {
                if (respoce3 == "1") {
                  loader.remove();
                  AdminInActiveDialog();
                } else {
                  loader.remove();
                  ToastUtils.showCustomToast(context, respoce3, false);
                }
              }
            });
          } else {
            loader.remove();
            ToastUtils.showCustomToast(
                context, GlobleString.login_error, false);
          }
        });
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.new_login_error, false);
        Helper.Log("respoce", respoce1);
      }
    });
  }

  AdminInActiveDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MessageDialogBox(
          buttontitle: GlobleString.tenant_inactive_OK,
          title: GlobleString.tenant_inactive,
          onPressed: () async {
            Navigator.of(context).pop();

            await Prefs.setString(PrefsName.BT_UserID, "");
            await Prefs.setString(PrefsName.BT_ApplicantID, "");
            await Prefs.setString(PrefsName.BT_PersonID, "");
            await Prefs.setString(PrefsName.BT_Email, "");
            await Prefs.setString(PrefsName.BT_fname, "");
            await Prefs.setString(PrefsName.BT_lname, "");
            await Prefs.setString(PrefsName.BT_phoneno, "");
            await Prefs.setString(PrefsName.BT_Country_Code, "");
            await Prefs.setString(PrefsName.BT_Dial_Code, "");
          },
        );
      },
    );
  }
}

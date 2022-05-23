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
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';

class TenantResetPWScreen extends StatefulWidget {
  const TenantResetPWScreen({
    this.ID,
    this.Companyname,
  });

  final String? ID;
  final String? Companyname;

  @override
  _TenantResetPWScreenState createState() => _TenantResetPWScreenState();
}

class _TenantResetPWScreenState extends State<TenantResetPWScreen> {
  bool newpasswordVisible = true;
  bool cnfpasswordVisible = true;
  final _textloginnewpass = TextEditingController();
  final _textloginCnfPass = TextEditingController();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  final FocusNode newpass = FocusNode();
  final FocusNode cnfpasss = FocusNode();

  double height = 0, width = 0;

  bool isloading = true;
  bool isError = false;

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    if (widget.ID != null && widget.ID != "") {
      HttpClientCall().CallAPIToken(context, (error, respoce) async {
        if (error) {
          Helper.Log("respoce", respoce);
          await Prefs.setString(PrefsName.userTokan, respoce);

          if (widget.ID != null && widget.ID != "") {
            ApiManager()
                .CompanyDetailsDSQCall(context, widget.Companyname.toString(),
                    (error1, respoce2) async {
              if (error1) {
                updateLoding();
              } else {
                updateError();
              }
            });
          } else {
            updateError();
          }
        } else {
          updateError();
          Helper.Log("responce", respoce);
        }
      });
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
      body: isloading
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
              : Center(
                  child: Container(
                    width: width / 2,
                    height: 420,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: myColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Prefs.getString(PrefsName.BT_CompanyLogoid) != null &&
                                Prefs.getString(PrefsName.BT_CompanyLogoid)
                                    .isNotEmpty
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
                                          Prefs.getString(
                                              PrefsName.BT_CompanyLogoid),
                                      scale: 1.5,
                                      headers: {
                                        'Authorization': 'bearer ' +
                                            Prefs.getString(
                                                PrefsName.userTokan),
                                        'ApplicationCode': Weburl.API_CODE,
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                child: Image.asset(
                                  "assets/images/silverhome.png",
                                  height: 80,
                                  //width: 180,
                                ),
                              ),
                        SizedBox(height: 15),
                        Text(
                          GlobleString.RP_title,
                          textAlign: TextAlign.center,
                          style: MyStyles.Medium(20, myColor.black),
                        ),
                        passwordWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        submitbutton(),
                      ],
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

  Widget passwordWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _entryFieldNewPassword(),
          _entryFieldConfirmPassword(),
        ],
      ),
    );
  }

  Widget _entryFieldNewPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _textloginnewpass,
            focusNode: newpass,
            autofocus: true,
            obscureText: newpasswordVisible,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8),
              suffixIcon: IconButton(
                icon: Icon(
                  newpasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black38,
                ),
                onPressed: () {
                  setState(() {
                    newpasswordVisible = !newpasswordVisible;
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
              hintText: GlobleString.RP_newpassword,
              hintStyle: MyStyles.Regular(16, myColor.Circle_main),
              labelStyle: MyStyles.Regular(16, myColor.Circle_main),
            ),
            onSubmitted: (value) {
              newpass.unfocus();
              FocusScope.of(context).requestFocus(cnfpasss);
            },
          )
        ],
      ),
    );
  }

  Widget _entryFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              controller: _textloginCnfPass,
              focusNode: cnfpasss,
              obscureText: cnfpasswordVisible,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                suffixIcon: IconButton(
                  icon: Icon(
                    cnfpasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    setState(() {
                      cnfpasswordVisible = !cnfpasswordVisible;
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
                hintText: GlobleString.RP_confirmpassword,
                hintStyle: MyStyles.Regular(16, myColor.Circle_main),
                labelStyle: MyStyles.Regular(16, myColor.Circle_main),
              ),
              onSubmitted: (value) {
                cnfpasss.unfocus();
              })
        ],
      ),
    );
  }

  Widget submitbutton() {
    return InkWell(
      onTap: () {
        apiWithValidation();
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
          GlobleString.FP_Submit,
          style: MyStyles.Medium(14, myColor.white),
        ),
      ),
    );
  }

  apiWithValidation() {
    String newpass = _textloginnewpass.text.toString().trim();
    String cnfpass = _textloginCnfPass.text.toString().trim();

    if (newpass.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.RP_newpassword_error, false);
    } else if (!Helper.isPasswordCompliant(newpass)) {
      ToastUtils.showCustomToast(context, GlobleString.password_error, false);
    } else if (cnfpass.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.RP_confirmpassword_error, false);
    } else if (newpass != cnfpass) {
      ToastUtils.showCustomToast(
          context, GlobleString.RP_password_not_match, false);
    } else {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      var myjson = {
        "DSQID": Weburl.DSQ_tenant_Details.toString(),
        "LoadLookupValues": true,
        "Reqtokens": {"UserID": widget.ID}
      };

      String json = jsonEncode(myjson);

      ApiManager().getTenantEmail_DSQCall(context, json, (error, respoce) {
        if (error) {
          if (respoce.isNotEmpty) {
            ApiManager().ResetPasswordAPI(context, respoce.toString(), newpass,
                (error, respoce1) {
              if (error) {
                loader.remove();
                ToastUtils.showCustomToast(
                    context, GlobleString.RP_reset_success, true);
                Navigator.of(context).pushReplacementNamed("/" +
                    widget.Companyname! +
                    "/" +
                    RouteNames.Basic_Tenant_Login);
              } else {
                loader.remove();
                ToastUtils.showCustomToast(
                    context, GlobleString.Error_server, false);
              }
            });
          } else {
            loader.remove();
            ToastUtils.showCustomToast(
                context, GlobleString.forgot_error_user, false);
          }
        } else {
          loader.remove();
          ToastUtils.showCustomToast(
              context, GlobleString.forgot_error_user, false);
        }
      });
    }
  }
}

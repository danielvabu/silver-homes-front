import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
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
import 'package:silverhome/widget/message_dialogbox.dart';

class TenantSignupScreen extends StatefulWidget {
  const TenantSignupScreen({
    this.Companyname,
    this.ID,
  });

  final String? ID;
  final String? Companyname;

  @override
  State<StatefulWidget> createState() => _TenantSignupScreen();
}

class _TenantSignupScreen extends State<TenantSignupScreen> {
  double height = 0, width = 0;
  final _textFullName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  final _textConfirmPassword = TextEditingController();

  FocusNode _fnFullName = FocusNode();
  FocusNode _fnEmail = FocusNode();
  FocusNode _fnPassword = FocusNode();
  FocusNode _fnCOnfirmPassword = FocusNode();

  bool _isPasswordVisible = true;
  bool _isCPasswordVisible = true;
  bool _isAcceptPrivacyPolicy = false;

  bool isloading = true;
  bool isError = false;

  late OverlayEntry loader;

  @override
  void initState() {
    initFocusListener();
    apiManagerCall();
    super.initState();
  }

  @override
  void dispose() {
    _fnPassword.removeListener(() {});
    _fnCOnfirmPassword.removeListener(() {});
    super.dispose();
  }

  initFocusListener() {
    _fnPassword.addListener(() => setState(() {}));
    _fnCOnfirmPassword.addListener(() => setState(() {}));
  }

  apiManagerCall() async {
    await Prefs.init();
    await Prefs.clear();

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
              var myjson = {
                "DSQID": Weburl.DSQ_tenant_Details.toString(),
                "LoadLookupValues": true,
                "Reqtokens": {"ID": widget.ID}
              };
              String json = jsonEncode(myjson);

              ApiManager().tenant_Details_DSQCall(context, json,
                  (error, respoce2) {
                if (error) {
                  _textFullName.text = Prefs.getString(PrefsName.BT_fname) +
                      " " +
                      Prefs.getString(PrefsName.BT_lname);
                  _textEmail.text = Prefs.getString(PrefsName.BT_Email);
                  updateLoding();
                } else {
                  updateError();
                }
              });
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: myColor.FV_Background,
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
                : isError
                    ? _errorPage()
                    : Container(
                        width: 500,
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                        decoration: BoxDecoration(
                          color: myColor.white,
                          border:
                              Border.all(color: myColor.TA_Border, width: 1),
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Prefs.getString(PrefsName.BT_CompanyLogoid) !=
                                          null &&
                                      Prefs.getString(
                                              PrefsName.BT_CompanyLogoid)
                                          .isNotEmpty
                                  ? Container(
                                      height: 80,
                                      alignment: Alignment.center,
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
                                              'ApplicationCode':
                                                  Weburl.API_CODE,
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: 80, minHeight: 80),
                                        child: Image.asset(
                                          "assets/images/silverhome.png",
                                          height: 80,
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    GlobleString.lbl_tenant_signup_title,
                                    textAlign: TextAlign.center,
                                    style: MyStyles.Medium(14, myColor.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              Text(
                                GlobleString.lbl_tenant_fullname,
                                style: MyStyles.Medium(15, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                              _fullnameTextField(),
                              SizedBox(height: 20),
                              Text(
                                GlobleString.lbl_tenant_email,
                                style: MyStyles.Medium(15, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                              _emailTextField(),
                              SizedBox(height: 20),
                              Text(
                                GlobleString.lbl_tenant_password,
                                style: MyStyles.Medium(
                                    15,
                                    _fnPassword.hasFocus
                                        ? myColor.blue
                                        : myColor.black),
                                textAlign: TextAlign.start,
                              ),
                              _passwordTextField(),
                              SizedBox(height: 20),
                              Text(
                                GlobleString.lbl_tenant_cpassword,
                                style: MyStyles.Medium(
                                    15,
                                    _fnCOnfirmPassword.hasFocus
                                        ? myColor.blue
                                        : myColor.black),
                                textAlign: TextAlign.start,
                              ),
                              _confirmPasswordTextField(),
                              SizedBox(height: 20),
                              _acceptPrivacyPolicy(),
                              SizedBox(height: 20),
                              _signupButton(),
                              SizedBox(height: 15),
                              _alredyHaveAccount(),
                            ],
                          ),
                        ),
                      ),
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

  Widget _fullnameTextField() {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: _textFullName,
        focusNode: _fnFullName,
        readOnly: true,
        keyboardType: TextInputType.name,
        style: MyStyles.Medium(15, myColor.disablecolor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 0),
          border: UnderlineInputBorder(borderSide: BorderSide()),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: myColor.disablecolor)),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: _textEmail,
        focusNode: _fnEmail,
        readOnly: true,
        keyboardType: TextInputType.emailAddress,
        style: MyStyles.Medium(15, myColor.disablecolor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 0),
          border: UnderlineInputBorder(borderSide: BorderSide()),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: myColor.disablecolor)),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: _textPassword,
        focusNode: _fnPassword,
        keyboardType: TextInputType.text,
        obscureText: _isPasswordVisible,
        style: MyStyles.Medium(15, Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 0),
          border: UnderlineInputBorder(borderSide: BorderSide()),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: myColor.blue)),
          suffixIcon: Container(
            height: 30,
            width: 40,
            alignment: Alignment.topCenter,
            child: IconButton(
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              color: Colors.black38,
              iconSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmPasswordTextField() {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: _textConfirmPassword,
        focusNode: _fnCOnfirmPassword,
        keyboardType: TextInputType.text,
        obscureText: _isCPasswordVisible,
        style: MyStyles.Medium(15, Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 0),
          border: UnderlineInputBorder(borderSide: BorderSide()),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: myColor.blue)),
          suffixIcon: Container(
            alignment: Alignment.topCenter,
            width: 40,
            height: 30,
            child: IconButton(
              onPressed: () =>
                  setState(() => _isCPasswordVisible = !_isCPasswordVisible),
              icon: Icon(
                _isCPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              color: Colors.black38,
              iconSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _acceptPrivacyPolicy() {
    return Row(
      children: [
        Checkbox(
          value: _isAcceptPrivacyPolicy,
          onChanged: (bool? change) =>
              setState(() => _isAcceptPrivacyPolicy = change!),
          side: BorderSide(color: Colors.black54),
          splashRadius: 0,
          activeColor: myColor.Circle_main,
        ),
        RichText(
          text: TextSpan(
            text: GlobleString.tenent_I_accept_the,
            // text: "",
            style: MyStyles.Medium(12, Colors.black),
            children: [
              TextSpan(
                text: GlobleString.tenent_Terms,
                style: MyStyles.Medium(12, Color(0XFF4b74ff)),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    Helper.launchURL(Weburl.PrivacyPolicy_and_TermsConditions);
                  },
              ),
              TextSpan(text: GlobleString.tenent_terms_policy_end),
              TextSpan(
                text: GlobleString.tenent_Privacy_Policy,
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    Helper.launchURL(Weburl.PrivacyPolicy_and_TermsConditions);
                    print("privacy policy click");
                  },
                style: MyStyles.Medium(12, Color(0XFF4b74ff)),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _signupButton() {
    return InkWell(
      onTap: () {
        checkvalidation();
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
          "Sign up",
          style: MyStyles.Medium(14, myColor.white),
        ),
      ),
    );
  }

  Widget _alredyHaveAccount() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: MyStyles.Bold(12, Colors.black),
        children: [
          TextSpan(
            text: "Login",
            style: MyStyles.Medium(12, Color(0XFF4b74ff)),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushReplacementNamed("/" +
                    widget.Companyname! +
                    "/" +
                    RouteNames.Basic_Tenant_Login);

                print("Login");
              },
          )
        ],
      ),
    );
  }

  void checkvalidation() {
    String email = _textEmail.text.toString().trim();
    String password = _textPassword.text.toString().trim();
    String Cpassword = _textConfirmPassword.text.toString().trim();

    if (password.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.register_error_password, false);
    } else if (!Helper.isPasswordCompliant(password)) {
      ToastUtils.showCustomToast(context, GlobleString.password_error, false);
    } else if (Cpassword.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.register_error_confirmpassword, false);
    } else if (password != Cpassword) {
      ToastUtils.showCustomToast(
          context, GlobleString.register_error_password_not_match, false);
    } else if (!_isAcceptPrivacyPolicy) {
      ToastUtils.showCustomToast(
          context, GlobleString.register_error_tmpp, false);
    } else {
      _apiCall(email, password, context);
    }
  }

  _apiCall(String email, String password, BuildContext context) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().RegisterApi(context, email, password, Weburl.Member_Role,
        (error, respoce) async {
      if (error) {
        String UserID = respoce.toString();
        updateUserDetails(UserID, context);
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.register_error, false);
        print("respoce >>" + respoce);
      }
    });
  }

  updateUserDetails(String UserID, BuildContext context) {
    CommonID commonID = new CommonID();
    commonID.ID = widget.ID;

    UserInfoID userInfoID = new UserInfoID();
    userInfoID.UserID = UserID;

    ApiManager().UpdateUserIdApplicant(context, commonID, userInfoID,
        (error, respoce) {
      if (error) {
        ApiManager().welcomeMailWorkflow(context, UserID,
            (error, respoce) async {
          if (error) {
            loader.remove();
            dailogShow();
          } else {
            loader.remove();
            ToastUtils.showCustomToast(context, respoce, false);
          }
        });
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
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
          buttontitle: GlobleString.tenant_invite_Mail_dailog_OK,
          title: GlobleString.tenant_invite_Mail_dailog_Success,
          onPressed: () async {
            Navigator.of(context).pop();

            Navigator.of(context).pushReplacementNamed("/" +
                widget.Companyname! +
                "/" +
                RouteNames.Basic_Tenant_Login);
          },
        );
      },
    );
  }
}

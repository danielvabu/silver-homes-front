import 'dart:html';

import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_pojo.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _store = getIt<AppStore>();

  bool passwordVisible = true;
  final _textloginEmail = TextEditingController();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  final FocusNode fnemail = FocusNode();

  double height = 0, width = 0;

  @override
  void initState() {
    Prefs.init();
    _textloginEmail.text = "";
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    HttpClientCall().CallAPIToken(context, (error, respoce) async {
      if (error) {
        Helper.Log("Tokan", respoce);
        await Prefs.setString(PrefsName.userTokan, respoce);
        loader.remove();
      } else {
        loader.remove();
        Helper.Log("respoce", respoce);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          width: width / 2,
          height: 382,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: myColor.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  "assets/images/silverhome.png",
                  height: 80,
                  //width: 180,
                ),
              ),
              SizedBox(height: 15),
              Text(
                GlobleString.FP_title,
                textAlign: TextAlign.center,
                style: MyStyles.Medium(20, myColor.black),
              ),
              emailPasswordWidget(),
              SizedBox(
                height: 10,
              ),
              loginbutton(),
              backtologin()
            ],
          ),
        ),
      ),
    );
  }

  Widget emailPasswordWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _entryFieldEmail(),
        ],
      ),
    );
  }

  Widget _entryFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            },
          )
        ],
      ),
    );
  }

  Widget loginbutton() {
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

  Widget backtologin() {
    return Container(
      height: 20,
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Text(
            GlobleString.FP_Backto,
            style: MyStyles.Regular(16, myColor.black),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteNames.Login);
            },
            child: Text(
              GlobleString.Signin,
              style: MyStyles.Bold(16, myColor.blue),
            ),
          )
        ],
      ),
    );
  }

  apiWithValidation() {
    String email = _textloginEmail.text.toString().trim();

    if (email.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.forgot_error_email, false);
    } else if (Helper.ValidEmail(email) != true) {
      ToastUtils.showCustomToast(
          context, GlobleString.forgot_error_valid_email, false);
    } else {
      ForgotPassword forgotPassword = new ForgotPassword();
      forgotPassword.UserName = email;

      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      ApiManager().checkEmailalreadyExit(context, forgotPassword,
          (error, respoce) async {
        if (error) {
          if (respoce != null) {
            String url = window.location.href.toString();

            String url1 = await url.replaceAll(RouteNames.ForgotPassword,
                RouteNames.ResetPassword + "/" + respoce.userId.toString());

            Helper.Log("ResetPassword Link", url1);

            ApiManager().ResetPassWordAPIworkflow(
                context, respoce.userId.toString(), (error, respoce) {
              if (error) {
                loader.remove();
                ToastUtils.showCustomToast(
                    context, GlobleString.forgot_emailsend, true);
                Navigator.pushNamed(context, RouteNames.Login);
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

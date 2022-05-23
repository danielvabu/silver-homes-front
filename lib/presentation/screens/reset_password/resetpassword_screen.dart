import 'package:flutter/material.dart';
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

class ResetPaswordScreen extends StatefulWidget {
  const ResetPaswordScreen({
    this.ID,
  });

  final String? ID;

  @override
  _ResetPaswordScreenState createState() => _ResetPaswordScreenState();
}

class _ResetPaswordScreenState extends State<ResetPaswordScreen> {
  bool newpasswordVisible = true;
  bool cnfpasswordVisible = true;
  final _textloginnewpass = TextEditingController();
  final _textloginCnfPass = TextEditingController();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  final FocusNode newpass = FocusNode();
  final FocusNode cnfpasss = FocusNode();

  double height = 0, width = 0;

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    if (widget.ID != null && widget.ID != "") {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);
      HttpClientCall().CallAPIToken(context, (error, respoce) async {
        if (error) {
          Helper.Log("respoce", respoce);
          await Prefs.setString(PrefsName.userTokan, respoce);
          loader.remove();
        } else {
          loader.remove();
          Helper.Log("responce", respoce);
        }
      });
    }
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
          height: 420,
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
                GlobleString.RP_title,
                textAlign: TextAlign.center,
                style: MyStyles.Medium(20, myColor.black),
              ),
              passwordWidget(),
              SizedBox(
                height: 10,
              ),
              submitbutton(),
              _gobacktologin(),
            ],
          ),
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

  Widget _gobacktologin() {
    return Container(
      height: 15,
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteNames.Login);
            },
            child: Text(
              GlobleString.RP_gobacktologin,
              style: MyStyles.Medium(14, myColor.blue),
            ),
          )
        ],
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
      UserInfoID userInfoID = new UserInfoID();
      userInfoID.UserID = widget.ID;

      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      ApiManager().checkEmailalreadyExit(context, userInfoID, (error, respoce) {
        if (error) {
          if (respoce != null) {
            ApiManager()
                .ResetPasswordAPI(context, respoce.userName.toString(), newpass,
                    (error, respoce) {
              if (error) {
                loader.remove();
                ToastUtils.showCustomToast(
                    context, GlobleString.RP_reset_success, true);
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

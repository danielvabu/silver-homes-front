import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';

import '../_network_image_web.dart';

class TenantForgotPWDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  TenantForgotPWDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _TenantForgotPWDialogBoxState createState() =>
      _TenantForgotPWDialogBoxState();
}

class _TenantForgotPWDialogBoxState extends State<TenantForgotPWDialogBox> {
  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  final _textloginEmail = TextEditingController();

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 700, maxWidth: 700, minHeight: 360, maxHeight: 360),
            child: Container(
              width: 700,
              height: 560,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            widget._callbackClose();
                          },
                          child: Icon(Icons.clear, size: 25),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 40, right: 20, bottom: 20, left: 20),
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
                          GlobleString.FP_title,
                          textAlign: TextAlign.center,
                          style: MyStyles.Medium(20, myColor.black),
                        ),
                        emailPasswordWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        loginbutton(),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
            focusNode: FocusNode(),
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
              FocusNode().unfocus();
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

  apiWithValidation() {
    String email = _textloginEmail.text.toString().trim();

    if (email.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.forgot_error_email, false);
    } else if (Helper.ValidEmail(email) != true) {
      ToastUtils.showCustomToast(
          context, GlobleString.forgot_error_valid_email, false);
    } else {
      /*  ForgotPassword forgotPassword = new ForgotPassword();
      forgotPassword.UserName = email;*/

      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      String url = Weburl.Domain_URL +
          Prefs.getString(PrefsName.BT_CustomerFeatureListingURL) +
          "/" +
          RouteNames.TenantResetpassword +
          "/";

      String CompanyLogo;
      if (Prefs.getString(PrefsName.BT_CompanyLogoURL) != null &&
          Prefs.getString(PrefsName.BT_CompanyLogoURL).isNotEmpty) {
        CompanyLogo = Prefs.getString(PrefsName.BT_CompanyLogoURL);
      } else {
        CompanyLogo =
            "http://161.97.104.204:8013/Attachments/Files/20210720135003287_logo.png";
      }

      ApiManager().Tenant_forgotpassWorkflow(
          context, email, url, Weburl.API_CODE, CompanyLogo, (error, respoce) {
        if (error) {
          loader.remove();
          widget._callbackSave();
          ToastUtils.showCustomToast(
              context, GlobleString.forgot_emailsend, true);
          //Navigator.pushNamed(context, RouteNames.Login);
        } else {
          loader.remove();
          if (respoce == "1") {
            ToastUtils.showCustomToast(
                context, GlobleString.forgot_error_user, false);
          } else {
            ToastUtils.showCustomToast(
                context, GlobleString.Error_server, false);
          }
        }
      });
    }
  }
}

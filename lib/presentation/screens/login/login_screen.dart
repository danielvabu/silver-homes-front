import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/actions.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/domain/actions/landlord_action/propertylist_actions.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/inactive_alert_dialogbox.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  void initState() {
    apiManagerCall();

    // Supper Admin Credential
    //_textloginEmail.text = "extensor01@gmail.com";
    //_textloginPass.text = "Admin@123";

    // Landlord Credential
    //_textloginEmail.text = "kk@gmail.com";
    //_textloginPass.text = "123456";
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();
    await Prefs.clear();
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
          height: 423,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: myColor.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
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
              Text(
                GlobleString.LogIn_title,
                textAlign: TextAlign.center,
                style: MyStyles.Medium(20, myColor.black),
              ),
              _emailPasswordWidget(),
              SizedBox(
                height: 10,
              ),
              _loginbutton(),
              _registerAndforgotpassword(),
              SizedBox(
                width: 10,
              ),
              /*InkWell(
                onTap: () {
                  _store.dispatch(UpdateCustomerPortal_pageindex(0));
                  navigateTo(context, RouteNames.CustomerPropertyPage);
                },
                child: Text(
                  "Custome Page",
                  style: MyStyles.Medium(14, myColor.blue),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
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
                    borderSide:
                        const BorderSide(color: myColor.blue, width: 2.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black12, width: 1.0)),
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
                  loginValidation();
                },
              ),
            ],
          ),
        ));
  }

  Widget _loginbutton() {
    return InkWell(
      onTap: () {
        loginValidation();
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

  Widget _registerAndforgotpassword() {
    return Container(
      height: 20,
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                GlobleString.register_msg,
                style: MyStyles.Regular(16, myColor.black),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.Register);
                },
                child: Text(
                  GlobleString.register,
                  style: MyStyles.Bold(16, myColor.blue),
                ),
              )
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteNames.ForgotPassword);
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

  loginValidation() {
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
      _apiCall(email, password, context);
    }
  }

  _apiCall(String email, String password, BuildContext context) async {
    await Prefs.clear();
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().LoginApi(context, email, password, (error, respoce1) async {
      if (error) {
        String UserID = respoce1;
        CheckUserData check = new CheckUserData();
        check.UserID = respoce1;

        ApiManager().userLoginDSQCall(context, UserID, (error, respoce2) {
          if (error) {
            ApiManager().getSystemEnumCallDSQ(context, (error, respoce3) async {
              if (error) {
                loader.remove();

                if (respoce2 == Weburl.Super_Admin_RoleID) {
                  _store.dispatch(UpdateAdminPortalPage(
                      0, GlobleString.NAV_admin_Overview));
                  Navigator.pushNamed(context, RouteNames.Admin_Portal);
                } else {
                  _store.dispatch(UpdatePropertyStatus_UnitsHeld(0));
                  _store.dispatch(UpdatePropertyStatus_UnitsRented(0));
                  _store.dispatch(UpdatePropertyStatus_VacantUnits(0));
                  _store.dispatch(
                      UpdatePortalPage(1, GlobleString.NAV_Properties));
                  Navigator.pushNamed(context, RouteNames.Portal);
                }
              } else {
                loader.remove();
                ToastUtils.showCustomToast(context, respoce3, false);
              }
            });
          } else {
            loader.remove();
            if (respoce2 == "1") {
              InActiveDialog(UserID);
            } else if (respoce2 == "2") {
              AdminInActiveDialog();
            } else if (respoce2 == "3") {
              ToastUtils.showCustomToast(
                  context, "User details not found.", false);
            } else {
              ToastUtils.showCustomToast(context, respoce2, false);
            }
          }
        });
      } else {
        HttpClientCall().CallAPIToken(context, (error, responceToken) async {
          if (error) {
            await Prefs.setString(PrefsName.userTokan, responceToken);
            ApiManager().CheckUserAccountExistDSQCall(
              context,
              email,
              (status, response) {
                loader.remove();
                if (status) {
                  ToastUtils.showCustomToast(
                      context, GlobleString.forgot_password_suggestion, false);
                } else {
                  ToastUtils.showCustomToast(
                      context, GlobleString.new_login_error, false);
                }
              },
            );
          } else {
            loader.remove();
            ToastUtils.showCustomToast(
                context, GlobleString.new_login_error, false);
          }
        });
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
          buttontitle: GlobleString.user_inactive_admin_OK,
          title: GlobleString.user_inactive_admin,
          onPressed: () async {
            Navigator.of(context).pop();
            await Prefs.clear();
          },
        );
      },
    );
  }

  InActiveDialog(String UserID) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return InActiveAlertDialogBox(
          title: GlobleString.Welcome_Mail_dailog_Success1,
          positiveText: GlobleString.Welcome_Mail_dailog_Resend,
          negativeText: GlobleString.Welcome_Mail_dailog_Cancel,
          onPressedYes: () {
            Navigator.of(context1).pop();

            loader = Helper.overlayLoader(context);
            Overlay.of(context)!.insert(loader);
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
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  dailogShow() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.Welcome_Mail_dailog_OK,
          title: GlobleString.Welcome_Mail_dailog_Success_login,
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

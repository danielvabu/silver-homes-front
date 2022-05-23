import 'dart:html' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _store = getIt<AppStore>();

  double height = 0, width = 0;

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  bool passwordVisible = true, isTermCond = false;
  final _textregisfname = TextEditingController();
  final _textregislname = TextEditingController();
  final _textregisEmail = TextEditingController();
  final _textregisPass = TextEditingController();

  final FocusNode fnfname = FocusNode();
  final FocusNode fnlname = FocusNode();
  final FocusNode fnemail = FocusNode();
  final FocusNode fnpass = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  Uint8List? companyimage;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          width: width / 2,
          height: 537,
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: myColor.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
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
                  GlobleString.register_title,
                  textAlign: TextAlign.center,
                  style: MyStyles.Medium(20, myColor.black),
                ),
                SizedBox(height: 15),
                //_companyLogo(),
                _edittextboxWidget(),
                registerbutton(),
                login()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void PickImage() async {
    print("click  >>>");

    final String id = '__file_picker_web-file-input';
    var element1 = html.document.getElementById(id);
    if (element1 != null) {
      element1.remove();
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
      ],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      print("file name >>>" + file.name);

      //print(file.bytes);
      //print("file size >>>" +file.size.toString());
      //print("file extension >>>" + file.extension);
      //print("file path >>>" +file.path);

      // Convert Uint8List to image
      //pickimage = Image.memory(file.bytes);

      if ((file.name.split('.').last).contains("jpg") ||
          (file.name.split('.').last).contains("JPG") ||
          (file.name.split('.').last).contains("png") ||
          (file.name.split('.').last).contains("PNG")) {
        companyimage = file.bytes!;

        final String id = '__file_picker_web-file-input';
        var element = html.document.getElementById(id);
        if (element != null) {
          element.remove();
        }

        setState(() {});
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.PS3_Property_Image_error, false);
      }
    }

    final String id1 = '__file_picker_web-file-input';
    var element = html.document.getElementById(id1);
    if (element != null) {
      element.remove();
    }
  }

  Widget _companyLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          GlobleString.company_log,
          textAlign: TextAlign.center,
          style: MyStyles.Regular(16, myColor.Circle_main),
        ),
        SizedBox(height: 10),
        companyimage != null
            ? Container(
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: myColor.white,
                  border: Border.all(width: 2, color: Colors.black12),
                ),
                child: Image.memory(
                  companyimage!,
                  fit: BoxFit.contain,
                  width: 148,
                  height: 148,
                ),
              )
            : Container(
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: myColor.white,
                  border: Border.all(width: 2, color: Colors.black12),
                ),
                padding: EdgeInsets.all(2),
                child: Image.asset(
                  "assets/images/imageplace.png",
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                ),
              ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            PickImage();
          },
          child: Container(
            height: 35,
            width: 130,
            padding: EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: myColor.Circle_main,
            ),
            child: Text(
              GlobleString.LL_Profile_Uploadlogo,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _edittextboxWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15),
      child: FocusScope(
        node: _focusScopeNode,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textregisfname,
                    autofocus: true,
                    focusNode: fnfname,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      focusColor: Colors.transparent,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: myColor.blue, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1.0)),
                      fillColor: myColor.white,
                      hintText: GlobleString.fname,
                      hintStyle: MyStyles.Regular(16, myColor.Circle_main),
                      labelStyle: MyStyles.Regular(16, myColor.Circle_main),
                    ),
                    onSubmitted: (value) {
                      fnfname.unfocus();
                      FocusScope.of(context).requestFocus(fnlname);
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: _textregislname,
                    focusNode: fnlname,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      focusColor: Colors.transparent,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: myColor.blue, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1.0)),
                      fillColor: myColor.white,
                      hintText: GlobleString.lname,
                      hintStyle: MyStyles.Regular(16, myColor.Circle_main),
                      labelStyle: MyStyles.Regular(16, myColor.Circle_main),
                    ),
                    onSubmitted: (value) {
                      fnlname.unfocus();
                      FocusScope.of(context).requestFocus(fnemail);
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _textregisEmail,
              focusNode: fnemail,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: myColor.blue, width: 2),
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
              controller: _textregisPass,
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
                //submitLogin();
              },
            ),
            SizedBox(
              height: 10,
            ),
            termsandCondition(),
          ],
        ),
      ),
    );
  }

  Widget termsandCondition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                activeColor: myColor.Circle_main,
                checkColor: myColor.white,
                value: isTermCond,
                onChanged: (value) {
                  setState(() {
                    isTermCond = value!;
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                GlobleString.I_accept_the,
                style: MyStyles.Regular(16, myColor.black),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  Helper.launchURL(Weburl.PrivacyPolicy_and_TermsConditions);
                },
                child: Text(
                  GlobleString.Terms,
                  style: MyStyles.Bold(16, myColor.blue),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                GlobleString.terms_policy_end,
                style: MyStyles.Regular(16, myColor.black),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  Helper.launchURL(Weburl.PrivacyPolicy_and_TermsConditions);
                },
                child: Text(
                  GlobleString.Privacy_Policy,
                  style: MyStyles.Bold(16, myColor.blue),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget registerbutton() {
    return InkWell(
      onTap: () {
        String fname = _textregisfname.text.toString().trim();
        String lname = _textregislname.text.toString().trim();
        String email = _textregisEmail.text.toString().trim();
        String password = _textregisPass.text.toString().trim();

        if (fname.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.register_error_fname, false);
        } else if (lname.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.register_error_lname, false);
        } else if (email.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.register_error_email, false);
        } else if (Helper.ValidEmail(email) != true) {
          ToastUtils.showCustomToast(
              context, GlobleString.register_error_valid_email, false);
        } else if (password.isEmpty) {
          ToastUtils.showCustomToast(
              context, GlobleString.register_error_password, false);
        } else if (!Helper.isPasswordCompliant(password)) {
          ToastUtils.showCustomToast(
              context, GlobleString.password_error, false);
        } else if (!isTermCond) {
          ToastUtils.showCustomToast(
              context, GlobleString.register_error_tmpp, false);
        } else {
          _apiCall(fname, lname, email, password, context);
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
          GlobleString.Signup,
          style: MyStyles.Medium(14, myColor.white),
        ),
      ),
    );
  }

  Widget login() {
    return Container(
      height: 20,
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Text(
            GlobleString.login_msg,
            style: MyStyles.Regular(16, myColor.black),
          ),
          SizedBox(
            width: 10,
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

  _apiCall(String fname, String lname, String email, String password,
      BuildContext context) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().RegisterApi(context, email, password, Weburl.Role,
        (error, respoce) async {
      if (error) {
        String UserID = respoce.toString();

        if (companyimage != null) {
          ApiManager().AddSingleImage(context, companyimage!,
              (status, responce) {
            if (status) {
              final String id = '__file_picker_web-file-input';
              var element = html.document.getElementById(id);
              if (element != null) {
                element.remove();
              }

              inserUserDetails(
                  fname, lname, email, password, UserID, responce, context);
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, responce, false);
            }
          });
        } else {
          inserUserDetails(
              fname, lname, email, password, UserID, null, context);
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.register_error, false);
        print("respoce >>" + respoce);
      }
    });
  }

  inserUserDetails(String fname, String lname, String email, String password,
      String UserID, String? mid, BuildContext context) {
    PersonId personId = new PersonId();
    personId.firstName = fname;
    personId.lastName = lname;
    personId.email = email;

    UserData userData = new UserData();
    userData.Roles = Weburl.RoleID;
    userData.UserID = UserID;
    userData.PersonID = personId;
    userData.UserName = email;
    userData.Company_logo = mid;
    userData.CustomerFeatureListingURL = Helper.generate20RandomString();

    ApiManager().InsetNewUser(context, userData, (error, respoce) {
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
          buttontitle: GlobleString.Welcome_Mail_dailog_OK,
          title: GlobleString.Welcome_Mail_dailog_Success_register,
          onPressed: () async {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, RouteNames.Login);
          },
        );
      },
    );
  }
}

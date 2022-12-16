import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/admin_action/admin_add_newmember_action.dart';
import 'package:silverhome/presentation/models/admin_models/admin_add_newmember_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';

class AddNewMemberDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  AddNewMemberDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _AddNewMemberDialogBoxState createState() => _AddNewMemberDialogBoxState();
}

class _AddNewMemberDialogBoxState extends State<AddNewMemberDialogBox> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late OverlayEntry loader;
  final _store = getIt<AppStore>();
  bool isloading = true;

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();
    RefreshstartTime();
  }

  RefreshstartTime() async {
    new Timer(Duration(seconds: 2), updateLoading);
  }

  updateLoading() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 500,
              maxWidth: 500,
              minHeight: 537,
              maxHeight: 537,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: isloading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/silverhome.png",
                            height: 100,
                            //width: 180,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    )
                  : ConnectState<AdminAddNewMemberState>(
                      map: (state) => state.adminAddNewMemberState,
                      where: notIdentical,
                      builder: (adminAddNewMemberState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      top: 20, left: 30, right: 30),
                                  child: Text(
                                    GlobleString.TM_Member_Information,
                                    style:
                                        MyStyles.Medium(20, myColor.text_color),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, left: 30, right: 30),
                                      child: InkWell(
                                        onTap: () {
                                          widget._callbackClose();
                                        },
                                        child: Icon(Icons.clear, size: 25),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            memberForm(adminAddNewMemberState!),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 30, right: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _checkValidation(
                                          context, adminAddNewMemberState);
                                    },
                                    child: Container(
                                      height: 35,
                                      padding:
                                          EdgeInsets.only(left: 25, right: 25),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: myColor.Circle_main,
                                      ),
                                      child: Text(
                                        GlobleString.NL_SAVE,
                                        style:
                                            MyStyles.Medium(14, myColor.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget memberForm(AdminAddNewMemberState newMemberState) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Container(
          //height: 450,
          padding: EdgeInsets.only(left: 30, right: 30),
          child: FocusScope(
            node: _focusScopeNode,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.TM_Member_First_name,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            initialValue: newMemberState.firstname,
                            textAlign: TextAlign.start,
                            autofocus: true,
                            style: MyStyles.Medium(14, myColor.text_color),
                            decoration: InputDecoration(
                                //border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: newMemberState.error_firstname
                                          ? myColor.errorcolor
                                          : myColor.blue,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: newMemberState.error_firstname
                                          ? myColor.errorcolor
                                          : myColor.gray,
                                      width: 1.0),
                                ),
                                isDense: true,
                                hintText:
                                    GlobleString.TM_Member_hint_First_name,
                                hintStyle:
                                    MyStyles.Regular(12, myColor.hintcolor),
                                contentPadding: EdgeInsets.all(15),
                                fillColor: myColor.white,
                                filled: true),
                            onChanged: (value) {
                              _store.dispatch(
                                  UpdateAdminTM_AM_firstname(value.toString()));
                              _store.dispatch(
                                  UpdateAdminTM_AM_error_firstname(false));
                            },
                          ),
                          if (newMemberState.error_firstname)
                            SizedBox(
                              height: 5,
                            ),
                          if (newMemberState.error_firstname)
                            Text(
                              GlobleString.TM_Member_error_First_name,
                              style: MyStyles.Regular(12, myColor.errorcolor),
                              textAlign: TextAlign.start,
                            ),
                        ],
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.TM_Member_Last_name,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            initialValue: newMemberState.lastname,
                            textAlign: TextAlign.start,
                            style: MyStyles.Medium(14, myColor.text_color),
                            decoration: InputDecoration(
                                //border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: newMemberState.error_lastname
                                          ? myColor.errorcolor
                                          : myColor.blue,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: newMemberState.error_lastname
                                          ? myColor.errorcolor
                                          : myColor.gray,
                                      width: 1.0),
                                ),
                                isDense: true,
                                hintText: GlobleString.TM_Member_hint_Last_name,
                                hintStyle:
                                    MyStyles.Regular(12, myColor.hintcolor),
                                contentPadding: EdgeInsets.all(15),
                                fillColor: myColor.white,
                                filled: true),
                            onChanged: (value) {
                              _store.dispatch(
                                  UpdateAdminTM_AM_lastname(value.toString()));
                              _store.dispatch(
                                  UpdateAdminTM_AM_error_lastname(false));
                            },
                          ),
                          if (newMemberState.error_lastname)
                            SizedBox(
                              height: 5,
                            ),
                          if (newMemberState.error_lastname)
                            Text(
                              GlobleString.TM_Member_error_Last_name,
                              style: MyStyles.Regular(12, myColor.errorcolor),
                              textAlign: TextAlign.start,
                            ),
                        ],
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.TM_Member_Email,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            initialValue: newMemberState.email,
                            textAlign: TextAlign.start,
                            style: MyStyles.Medium(14, myColor.text_color),
                            decoration: InputDecoration(
                                //border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: newMemberState.error_email
                                          ? myColor.errorcolor
                                          : myColor.blue,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: newMemberState.error_email
                                          ? myColor.errorcolor
                                          : myColor.gray,
                                      width: 1.0),
                                ),
                                isDense: true,
                                hintText:
                                    GlobleString.TM_Member_hint_Enter_email,
                                hintStyle:
                                    MyStyles.Regular(12, myColor.hintcolor),
                                contentPadding: EdgeInsets.all(15),
                                fillColor: myColor.white,
                                filled: true),
                            onChanged: (value) {
                              _store.dispatch(
                                  UpdateAdminTM_AM_email(value.toString()));
                              _store.dispatch(
                                  UpdateAdminTM_AM_error_email(false));
                            },
                          ),
                          if (newMemberState.error_email)
                            SizedBox(
                              height: 5,
                            ),
                          if (newMemberState.error_email)
                            Text(
                              newMemberState.error_message,
                              style: MyStyles.Regular(12, myColor.errorcolor),
                              textAlign: TextAlign.start,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                //if(Prefs.getBool(PrefsName.admin_addTeam))
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.TM_Member_Password,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            initialValue: newMemberState.password,
                            readOnly: true,
                            textAlign: TextAlign.start,
                            style: MyStyles.Medium(14, myColor.disablecolor),
                            decoration: InputDecoration(
                                //border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: myColor.disablecolor, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: myColor.disablecolor, width: 1.0),
                                ),
                                isDense: true,
                                hintText:
                                    GlobleString.TM_Member_hint_Enter_email,
                                hintStyle:
                                    MyStyles.Regular(12, myColor.hintcolor),
                                contentPadding: EdgeInsets.all(15),
                                fillColor: myColor.white,
                                filled: true),
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //if(Prefs.getBool(PrefsName.admin_addTeam))
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                GlobleString.TM_Member_Phone_Number,
                                style: MyStyles.Medium(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                GlobleString.Optional,
                                style: MyStyles.Medium(10, myColor.optional),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: newMemberState.error_phone
                                    ? myColor.errorcolor
                                    : myColor.gray,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CountryCodePicker(
                                  onChanged: (value) {
                                    _store.dispatch(UpdateAdminTM_AM_dialcode(
                                        value.dialCode!));
                                    _store.dispatch(
                                        UpdateAdminTM_AM_countrycode(
                                            value.code!));
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: newMemberState.countrycode,
                                  showFlag: true,
                                  textStyle:
                                      MyStyles.Medium(14, myColor.text_color),
                                  dialogTextStyle:
                                      MyStyles.Medium(14, myColor.text_color),
                                  //showDropDownButton: true,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: newMemberState.phone,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      MaskedInputFormatter("(000) 000 0000")
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.all(15),
                                      isDense: true,
                                    ),
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    onChanged: (value) {
                                      _store.dispatch(UpdateAdminTM_AM_phone(
                                          value.toString()));
                                      _store.dispatch(
                                          UpdateAdminTM_AM_error_phone(false));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (newMemberState.error_phone)
                            SizedBox(
                              height: 5,
                            ),
                          if (newMemberState.error_phone)
                            Text(
                              GlobleString.TM_Member_error_valid_phone,
                              style: MyStyles.Regular(12, myColor.errorcolor),
                              textAlign: TextAlign.start,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkValidation(
      BuildContext context, AdminAddNewMemberState newMemberState) {
    if (newMemberState.firstname == null || newMemberState.firstname.isEmpty) {
      _store.dispatch(UpdateAdminTM_AM_error_firstname(true));

      ToastUtils.showCustomToast(
          context, GlobleString.TM_Member_error_First_name, false);
    } else if (newMemberState.lastname == null ||
        newMemberState.lastname.isEmpty) {
      _store.dispatch(UpdateAdminTM_AM_error_lastname(true));
      ToastUtils.showCustomToast(
          context, GlobleString.TM_Member_error_Last_name, false);
    } else if (newMemberState.email == null || newMemberState.email.isEmpty) {
      _store.dispatch(UpdateAdminTM_AM_error_email(true));
      _store.dispatch(UpdateAdminTM_AM_error_Message(
          GlobleString.TM_Member_error_Enter_email));
      ToastUtils.showCustomToast(
          context, GlobleString.TM_Member_error_Enter_email, false);
    } else if (Helper.ValidEmail(newMemberState.email.trim().toString()) !=
        true) {
      _store.dispatch(UpdateAdminTM_AM_error_email(true));
      _store.dispatch(UpdateAdminTM_AM_error_Message(
          GlobleString.TM_Member_error_valid_email));
      ToastUtils.showCustomToast(
          context, GlobleString.TM_Member_error_valid_email, false);
    } else if (newMemberState.phone != null &&
        newMemberState.phone.isNotEmpty &&
        Helper.ValidPhonenumber(newMemberState.phone)) {
      _store.dispatch(UpdateAdminTM_AM_error_phone(true));
      ToastUtils.showCustomToast(
          context, GlobleString.TM_Member_error_valid_phone, false);
    } else {
      _apiCall(newMemberState);
    }
  }

  _apiCall(AdminAddNewMemberState newMemberState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    if (Prefs.getBool(PrefsName.admin_addTeam)) {
      ApiManagerAdmin().AdminRegisterApi(
          context, newMemberState.email, newMemberState.password,
          (error, respoce) async {
        if (error) {
          String UserID = respoce.toString();

          PersonId personId = new PersonId();
          personId.firstName = newMemberState.firstname;
          personId.lastName = newMemberState.lastname;
          personId.email = newMemberState.email;
          personId.Country_Code = newMemberState.countrycode;
          personId.Dial_Code = newMemberState.dialcode;
          personId.mobileNumber = newMemberState.phone;

          AdminUserData userData = new AdminUserData();
          userData.Roles = Weburl.Super_Admin_RoleID;
          userData.UserID = UserID;
          userData.PersonID = personId;
          userData.UserName = newMemberState.email;
          userData.IsActive = true;

          ApiManagerAdmin().InsetNewAdminUser(context, userData,
              (error, respoce) {
            if (error) {
              loader.remove();
              widget._callbackSave();
            } else {
              loader.remove();
              ToastUtils.showCustomToast(
                  context, GlobleString.NL_error_insertcall, false);
            }
          });
        } else {
          loader.remove();
          ToastUtils.showCustomToast(
              context, GlobleString.register_error, false);
          Helper.Log("respoce", respoce);
        }
      });
    } else {
      PersonIdInfo personIdInfo = new PersonIdInfo();
      personIdInfo.ID = newMemberState.Persionid;
      personIdInfo.FirstName = newMemberState.firstname;
      personIdInfo.LastName = newMemberState.lastname;
      personIdInfo.Email = newMemberState.email;
      personIdInfo.MobileNumber = newMemberState.phone;
      personIdInfo.Country_Code = newMemberState.countrycode;
      personIdInfo.Dial_Code = newMemberState.dialcode;

      UpdateAdminUserInfo upersonInfo = new UpdateAdminUserInfo();
      upersonInfo.UserName = newMemberState.email;
      upersonInfo.PersonID = personIdInfo;

      CommonID commonID = new CommonID();
      commonID.ID = newMemberState.OwnerId;

      ApiManagerAdmin().UpdateAdminTeamProfile(context, commonID, upersonInfo,
          (status, responce) {
        if (status) {
          loader.remove();
          widget._callbackSave();
        } else {
          loader.remove();
        }
      });
    }
  }
}

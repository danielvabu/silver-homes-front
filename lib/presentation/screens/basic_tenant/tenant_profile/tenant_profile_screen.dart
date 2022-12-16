import 'dart:convert';
import 'dart:html' as html;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_personal_action.dart';
import 'package:silverhome/domain/actions/basictenant_action/tenant_portal_action.dart';
import 'package:silverhome/presentation/models/basic_tenant/tenant_personal_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';

class TenantProfileScreen extends StatefulWidget {
  @override
  _TenantProfileScreenState createState() => _TenantProfileScreenState();
}

class _TenantProfileScreenState extends State<TenantProfileScreen> {
  double ssheight = 0, sswidth = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;

  final _textCurrentPwd = TextEditingController();
  final _textNewPwd = TextEditingController();
  final _textConfirmPwd = TextEditingController();
  bool CpasswordVisible = true;
  bool NpasswordVisible = true;
  bool NCpasswordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      width: sswidth,
      height: ssheight,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            height: ssheight,
            width: sswidth,
            decoration: BoxDecoration(
              color: myColor.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: myColor.application_boreder, width: 1),
            ),
            padding: EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
            child: ConnectState<TenantPersonalState>(
              map: (state) => state.tenantPersonalState,
              where: notIdentical,
              builder: (tenantPersonalState) {
                return SingleChildScrollView(
                  child: Container(
                    width: sswidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.BT_Profile_title,
                          style: MyStyles.SemiBold(16, myColor.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        profileImage(tenantPersonalState!),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 800,
                          child: FocusScope(
                            node: new FocusScopeNode(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.BT_Profile_Firstname,
                                            style: MyStyles.Medium(14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            initialValue: tenantPersonalState.perFirstname,
                                            textAlign: TextAlign.start,
                                            readOnly: true,
                                            style: MyStyles.Regular(14, myColor.disablecolor),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(25),
                                              /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                            ],
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.disablecolor, width: 2),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.disablecolor, width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding: EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(UpdateTenantPersonal_perFirstname(value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.BT_Profile_Lastname,
                                            style: MyStyles.Medium(14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            initialValue: tenantPersonalState.perLastname,
                                            textAlign: TextAlign.start,
                                            readOnly: true,
                                            style: MyStyles.Regular(14, myColor.disablecolor),
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.disablecolor, width: 2),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.disablecolor, width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding: EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(UpdateTenantPersonal_perLastname(value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
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
                                            GlobleString.BT_Profile_Email,
                                            style: MyStyles.Medium(14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            initialValue: tenantPersonalState.perEmail,
                                            textAlign: TextAlign.start,
                                            readOnly: true,
                                            style: MyStyles.Regular(14, myColor.disablecolor),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(50),
                                              /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                            ],
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.disablecolor, width: 2),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.disablecolor, width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding: EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(UpdateTenantPersonal_perEmail(value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString.BT_Profile_Phonenumber,
                                                style: MyStyles.Medium(14, myColor.black),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                GlobleString.Optional,
                                                style: MyStyles.Regular(12, myColor.optional),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: myColor.black,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                CountryCodePicker(
                                                  onChanged: (value) {
                                                    //widget.newleadlist.insert(widget.pos, widget.dmodel);

                                                    _store.dispatch(UpdateTenantPersonal_perDialCode(value.dialCode.toString()));
                                                    _store.dispatch(UpdateTenantPersonal_perCountryCode(value.code.toString()));
                                                  },
                                                  initialSelection: tenantPersonalState.perCountryCode,
                                                  showFlag: true,
                                                  textStyle: MyStyles.Medium(14, myColor.text_color),
                                                  enabled: true,
                                                  dialogTextStyle: MyStyles.Medium(14, myColor.text_color),
                                                  //showDropDownButton: true,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    initialValue: tenantPersonalState.perPhoneNumber,
                                                    keyboardType: TextInputType.phone,
                                                    inputFormatters: [MaskedInputFormatter("(000) 000 0000")],
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(color: myColor.disablecolor),
                                                      contentPadding: EdgeInsets.all(10),
                                                      isDense: true,
                                                    ),
                                                    style: MyStyles.Medium(14, myColor.black),
                                                    onChanged: (value) {
                                                      _store.dispatch(UpdateTenantPersonal_perPhoneNumber(value));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        savePersonDetails(tenantPersonalState);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        padding: EdgeInsets.only(left: 15, right: 15),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: myColor.Circle_main,
                                        ),
                                        child: Text(
                                          GlobleString.BT_Profile_Save,
                                          style: MyStyles.Medium(14, myColor.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      GlobleString.BT_Change_Password,
                                      style: MyStyles.Medium(20, myColor.Circle_main),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
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
                                                GlobleString.BT_old_Password,
                                                style: MyStyles.Medium(14, myColor.black),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextField(
                                                controller: _textCurrentPwd,
                                                textAlign: TextAlign.start,
                                                style: MyStyles.Regular(14, myColor.Circle_main),
                                                obscureText: CpasswordVisible,
                                                decoration: InputDecoration(
                                                    //border: InputBorder.none,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        CpasswordVisible ? Icons.visibility_off : Icons.visibility,
                                                        color: Colors.black38,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          CpasswordVisible = !CpasswordVisible;
                                                        });
                                                      },
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: myColor.blue, width: 2),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: myColor.disablecolor, width: 1.0),
                                                    ),
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.all(12),
                                                    fillColor: myColor.white,
                                                    filled: true),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
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
                                                GlobleString.BT_new_Password,
                                                style: MyStyles.Medium(14, myColor.black),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextField(
                                                controller: _textNewPwd,
                                                textAlign: TextAlign.start,
                                                style: MyStyles.Regular(14, myColor.Circle_main),
                                                obscureText: NpasswordVisible,
                                                decoration: InputDecoration(
                                                    //border: InputBorder.none,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        NpasswordVisible ? Icons.visibility_off : Icons.visibility,
                                                        color: Colors.black38,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          NpasswordVisible = !NpasswordVisible;
                                                        });
                                                      },
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: myColor.blue, width: 2),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: myColor.disablecolor, width: 1.0),
                                                    ),
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.all(12),
                                                    fillColor: myColor.white,
                                                    filled: true),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
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
                                                GlobleString.BT_confirm_Password,
                                                style: MyStyles.Medium(14, myColor.black),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextField(
                                                controller: _textConfirmPwd,
                                                textAlign: TextAlign.start,
                                                style: MyStyles.Regular(14, myColor.Circle_main),
                                                obscureText: NCpasswordVisible,
                                                decoration: InputDecoration(
                                                    //border: InputBorder.none,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        NCpasswordVisible ? Icons.visibility_off : Icons.visibility,
                                                        color: Colors.black38,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          NCpasswordVisible = !NCpasswordVisible;
                                                        });
                                                      },
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: myColor.blue, width: 2),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: myColor.disablecolor, width: 1.0),
                                                    ),
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.all(12),
                                                    fillColor: myColor.white,
                                                    filled: true),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        SavePassword();
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 90,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(7)),
                                          color: myColor.Circle_main,
                                        ),
                                        child: Text(
                                          GlobleString.BT_Submitpassword,
                                          style: MyStyles.Medium(14, myColor.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImage(TenantPersonalState tenantPersonalState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              GlobleString.BT_Profile_Image,
              style: MyStyles.Medium(14, myColor.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              GlobleString.Optional,
              style: MyStyles.Regular(12, myColor.optional),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        tenantPersonalState.propertyImage != null && tenantPersonalState.propertyImage!.id != null
            ? Container(
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: myColor.white,
                  border: Border.all(width: 2, color: myColor.blue),
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: CustomNetworkImage(Weburl.image_API + tenantPersonalState.propertyImage!.id.toString(), scale: 1, headers: {
                      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
                      'ApplicationCode': Weburl.API_CODE,
                    }),
                  ),
                ),
              )
            : tenantPersonalState.appimage != null
                ? Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: myColor.white,
                      border: Border.all(width: 2, color: myColor.blue),
                    ),
                    child: Image.memory(
                      tenantPersonalState.appimage!,
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
                      border: Border.all(width: 2, color: myColor.blue),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    /* child: Image.asset(
            "assets/images/imageplace.png",
            width: 70,
            height: 70,
            alignment: Alignment.center,
          ),*/
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 150,
                    ),
                  ),
        SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () {
            PickImage();
          },
          child: Container(
            height: 35,
            width: 150,
            padding: EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: myColor.Circle_main,
            ),
            child: Text(
              GlobleString.BT_Profile_Uploadlogo,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ),
        )
      ],
    );
  }

  void PickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      if ((file.name.split('.').last).contains("jpg") ||
          (file.name.split('.').last).contains("JPG") ||
          (file.name.split('.').last).contains("png") ||
          (file.name.split('.').last).contains("PNG") ||
          (file.name.split('.').last).contains("jpeg") ||
          (file.name.split('.').last).contains("JPEG")) {
        _store.dispatch(UpdateTenantPersonal_appimage(file.bytes!));
        _store.dispatch(UpdateTenantPersonal_propertyImage(null));

        final String id = '__file_picker_web-file-input';
        var element = html.document.getElementById(id);
        if (element != null) {
          element.remove();
        }
      } else {
        ToastUtils.showCustomToast(context, GlobleString.PS3_Property_Image_error, false);
      }
    }
    final String id = '__file_picker_web-file-input';
    var element = html.document.getElementById(id);
    if (element != null) {
      element.remove();
    }
  }

  void savePersonDetails(TenantPersonalState tenantPersonalState) {
    if (tenantPersonalState.perFirstname == null || tenantPersonalState.perFirstname.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.LL_Profile_error_firstname, false);
    } else if (tenantPersonalState.perLastname == null || tenantPersonalState.perLastname.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.LL_Profile_error_lastname, false);
    } else if (tenantPersonalState.perEmail == null || tenantPersonalState.perEmail.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.LL_Profile_error_email, false);
    } else if (tenantPersonalState.perPhoneNumber != null &&
        tenantPersonalState.perPhoneNumber.isNotEmpty &&
        Helper.ValidPhonenumber(tenantPersonalState.perPhoneNumber.toString())) {
      ToastUtils.showCustomToast(context, GlobleString.LL_Profile_error_validphone, false);
    } else {
      _addSaveAndFinishCall(tenantPersonalState);
    }
  }

  _addSaveAndFinishCall(TenantPersonalState tenantPersonalState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    if (tenantPersonalState.appimage != null) {
      ApiManager().AddSingleImage(context, tenantPersonalState.appimage!, (status, responce) {
        if (status) {
          final String id = '__file_picker_web-file-input';
          var element = html.document.getElementById(id);
          if (element != null) {
            element.remove();
          }

          updateProfile(tenantPersonalState, responce);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      updateProfile(tenantPersonalState, "");
    }
  }

  updateProfile(TenantPersonalState tenantPersonalState, String mid) {
    PersonDataId personid = new PersonDataId();
    personid.id = Prefs.getString(PrefsName.BT_PersonID);
    personid.firstName = tenantPersonalState.perFirstname;
    personid.lastName = tenantPersonalState.perLastname;
    personid.email = tenantPersonalState.perEmail;
    personid.mobileNumber = tenantPersonalState.perPhoneNumber;
    personid.Country_Code = tenantPersonalState.perCountryCode;
    personid.Dial_Code = tenantPersonalState.perDialCode;

    ApplicantProfileData uPojo = new ApplicantProfileData();
    uPojo.profile = mid == ""
        ? tenantPersonalState.propertyImage != null
            ? tenantPersonalState.propertyImage!.id.toString()
            : ""
        : mid;

    uPojo.personId = personid;

    CommonID cPojo = new CommonID();
    cPojo.ID = Prefs.getString(PrefsName.BT_ApplicantID);

    ApiManager().UpdateTenantProfileData(context, cPojo, uPojo, (error, respoce) async {
      if (error) {
        var myjson = {
          "DSQID": Weburl.DSQ_tenant_Details.toString(),
          "LoadLookupValues": true,
          "Reqtokens": {"UserID": Prefs.getString(PrefsName.BT_UserID)}
        };

        String json = jsonEncode(myjson);

        ApiManager().tenant_Details_DSQCall(context, json, (error, respoce2) {
          if (error) {
            loader.remove();
            ToastUtils.showCustomToast(context, GlobleString.LL_Profile_success, true);
            _store.dispatch(UpdateTenantPortalPage(0, GlobleString.NAV_tenant_LeaseDetails));
          } else {
            loader.remove();
            ToastUtils.showCustomToast(context, respoce2, false);
          }
        });
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  void SavePassword() {
    String curpass = _textCurrentPwd.text.toString().trim();
    String newpass = _textNewPwd.text.toString().trim();
    String confirmpass = _textConfirmPwd.text.toString().trim();

    if (curpass.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.tenant_cuurent_error, false);
    } else if (newpass.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.tenant_new_error, false);
    } else if (newpass == curpass) {
      ToastUtils.showCustomToast(context, GlobleString.tenant_password_same_error, false);
    } else if (!Helper.isPasswordCompliant(newpass)) {
      ToastUtils.showCustomToast(context, GlobleString.password_error, false);
    } else if (confirmpass.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.tenant_newconfirm_error, false);
    } else if (newpass != confirmpass) {
      ToastUtils.showCustomToast(context, GlobleString.tenant_confirm_password_error, false);
    } else {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      ApiManager().ChangePasswordAPI(context, Prefs.getString(PrefsName.BT_Email), curpass, newpass, (error, respoce) {
        if (error) {
          loader.remove();
          ToastUtils.showCustomToast(context, GlobleString.tenant_password_success, true);
          _store.dispatch(UpdateTenantPortalPage(0, GlobleString.NAV_tenant_LeaseDetails));
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, GlobleString.tenant_password_error, false);
        }
      });
    }
  }
}

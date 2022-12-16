import 'dart:html' as html;
import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
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
import 'package:silverhome/domain/actions/admin_action/admin_landlord_account_actions.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_account_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';

class AdminLandlordsDetailsAccount extends StatefulWidget {
  @override
  _AdminLandlordsDetailsAccountState createState() =>
      _AdminLandlordsDetailsAccountState();
}

class _AdminLandlordsDetailsAccountState
    extends State<AdminLandlordsDetailsAccount> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;

  double drawer_width = 230;
  double header_height = 70;

  @override
  void initState() {
    Prefs.init();
    apimanager();
    super.initState();
  }

  void apimanager() async {
    html.document.onContextMenu.listen((event) => event.preventDefault());

    _store.dispatch(UpdateLandlordAccount_isloading(true));
    await ApiManagerAdmin()
        .getLandlordAccountdetails(context, Prefs.getString(PrefsName.OwnerID));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height - 190,
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: ConnectState<AdminLandlordAccountState>(
          map: (state) => state.adminLandlordAccountState,
          where: notIdentical,
          builder: (adminLandlordAccountState) {
            return Container(
              width: width,
              child: adminLandlordAccountState!.isloading
                  ? Container(
                      width: width,
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        "Please wait.....",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: MyStyles.Medium(18, myColor.Circle_main),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        width: 700,
                        alignment: Alignment.topLeft,
                        child: FocusScope(
                          node: new FocusScopeNode(),
                          child: Container(
                            width: 700,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        GlobleString.ALLD_TAB_Account,
                                        style: MyStyles.Medium(
                                            20, myColor.Circle_main),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "-",
                                        style: MyStyles.Medium(
                                            20, myColor.Circle_main),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        GlobleString
                                            .ALLD_Account_Profile_contact_information,
                                        style: MyStyles.Regular(
                                            16, myColor.optional),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 250,
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GlobleString.LL_Profile_Companylogo,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      adminLandlordAccountState.companylogo !=
                                                  null &&
                                              adminLandlordAccountState
                                                      .companylogo!.id !=
                                                  null
                                          ? Container(
                                              width: 150.0,
                                              height: 150.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: myColor.white,
                                                border: Border.all(
                                                    width: 2,
                                                    color: myColor.gray),
                                              ),
                                              alignment: Alignment.center,
                                              child: Container(
                                                width: 140.0,
                                                height: 140.0,
                                                decoration: new BoxDecoration(
                                                  image: new DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: CustomNetworkImage(
                                                        Weburl.image_API +
                                                            adminLandlordAccountState
                                                                .companylogo!.id
                                                                .toString(),
                                                        scale: 1,
                                                        headers: {
                                                          'Authorization': 'bearer ' +
                                                              Prefs.getString(
                                                                  PrefsName
                                                                      .userTokan),
                                                          'ApplicationCode':
                                                              Weburl.API_CODE,
                                                        }),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 150.0,
                                              height: 150.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: myColor.white,
                                                border: Border.all(
                                                    width: 2,
                                                    color: myColor.gray),
                                              ),
                                            ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        GlobleString.ALLD_Account_ID,
                                        style:
                                            MyStyles.Medium(14, myColor.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: adminLandlordAccountState
                                            .OwnerId.toString(),
                                        textAlign: TextAlign.start,
                                        autofocus: true,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(25),
                                        ],
                                        decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: myColor.gray,
                                                  width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: myColor.gray,
                                                  width: 1.0),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(12),
                                            fillColor: myColor.white,
                                            filled: true),
                                        onChanged: (value) {},
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (adminLandlordAccountState
                                              .CustomerFeatureListingURL
                                              .isEmpty)
                                            Text(
                                              GlobleString
                                                  .LL_Profile_customerfeaturelist,
                                              style: MyStyles.Medium(
                                                  14, myColor.black),
                                              textAlign: TextAlign.start,
                                            ),
                                          if (adminLandlordAccountState
                                              .CustomerFeatureListingURL
                                              .isNotEmpty)
                                            copytoClick(
                                                adminLandlordAccountState),
                                          if (adminLandlordAccountState
                                              .CustomerFeatureListingURL
                                              .isNotEmpty)
                                            SizedBox(
                                              height: 5,
                                            ),
                                          if (adminLandlordAccountState
                                              .CustomerFeatureListingURL
                                              .isNotEmpty)
                                            Text(
                                              GlobleString.LL_Copy_title,
                                              style: MyStyles.Regular(
                                                  13, Colors.grey),
                                              textAlign: TextAlign.start,
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 33,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: myColor.gray,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 33,
                                                  color: Colors.black12,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Text(
                                                    Weburl.CustomerFeaturedPage,
                                                    style: MyStyles.Medium(
                                                        14, myColor.black),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    onChanged: (newValue) {
                                                      _store.dispatch(
                                                          UpdateLandlordAccount_CustomerFeatureListingURL_Update(
                                                              newValue));
                                                    },
                                                    initialValue:
                                                        adminLandlordAccountState
                                                            .CustomerFeatureListingURL_update,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-zA-Z0-9]"))
                                                    ],
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: GlobleString
                                                          .LL_cfl_hint,
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.all(12),
                                                      isDense: true,
                                                    ),
                                                    style: MyStyles.Medium(
                                                        14, myColor.text_color),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (adminLandlordAccountState
                                                          .CustomerFeatureListingURL_update ==
                                                      null ||
                                                  adminLandlordAccountState
                                                          .CustomerFeatureListingURL_update ==
                                                      "") {
                                                ToastUtils.showCustomToast(
                                                    context,
                                                    GlobleString
                                                        .TM_Member_error_customerfeaturelist,
                                                    false);
                                              } else if (Helper
                                                  .NoValidSpecialCharacters(
                                                      adminLandlordAccountState
                                                          .CustomerFeatureListingURL_update)) {
                                                ToastUtils.showCustomToast(
                                                    context,
                                                    GlobleString
                                                        .TM_Member_error_customerfeaturelist1,
                                                    false);
                                              } else {
                                                saveCustomerUrl(
                                                    adminLandlordAccountState);
                                              }
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 90,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7)),
                                                color: myColor.Circle_main,
                                              ),
                                              child: Text(
                                                GlobleString.LL_Profile_Save,
                                                style: MyStyles.Medium(
                                                    14, myColor.white),
                                              ),
                                            ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.LL_Profile_Companyname,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            initialValue:
                                                adminLandlordAccountState
                                                    .companyname,
                                            readOnly: true,
                                            textAlign: TextAlign.start,
                                            autofocus: true,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  25),
                                              /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                            ],
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString
                                                .LL_Profile_Homepagelink,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            initialValue:
                                                adminLandlordAccountState
                                                    .homepagelink,
                                            readOnly: true,
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {},
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString
                                                .ALLD_Account_First_name,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            initialValue:
                                                adminLandlordAccountState
                                                    .firstname
                                                    .toString(),
                                            textAlign: TextAlign.start,
                                            autofocus: true,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  25),
                                            ],
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.ALLD_Account_Last_name,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            initialValue:
                                                adminLandlordAccountState
                                                    .lastname
                                                    .toString(),
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {},
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString
                                                .ALLD_Account_Email_address,
                                            style: MyStyles.Medium(
                                                14, myColor.text_color),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {},
                                            readOnly: true,
                                            initialValue:
                                                adminLandlordAccountState.email
                                                    .toString(),
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            decoration: InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString
                                                .ALLD_Account_Phone_number,
                                            style: MyStyles.Medium(
                                                14, myColor.text_color),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: 33,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: myColor.gray,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                CountryCodePicker(
                                                  onChanged: (value) {},
                                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                  initialSelection:
                                                      adminLandlordAccountState
                                                          .countrycode
                                                          .toString(),
                                                  showFlag: true,
                                                  enabled: false,
                                                  textStyle: MyStyles.Regular(
                                                      14, myColor.text_color),
                                                  dialogTextStyle:
                                                      MyStyles.Regular(14,
                                                          myColor.text_color),
                                                  //showDropDownButton: true,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    onChanged: (newValue) {},
                                                    readOnly: true,
                                                    initialValue:
                                                        adminLandlordAccountState
                                                            .phoneno
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    inputFormatters: [
                                                      MaskedInputFormatter(
                                                          "(000) 000 0000")
                                                    ],
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.all(12),
                                                      isDense: true,
                                                    ),
                                                    style: MyStyles.Regular(
                                                        14, myColor.text_color),
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
                                  height: 40,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      GlobleString.AA_Password_Security,
                                      style: MyStyles.Medium(
                                          20, myColor.Circle_main),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      GlobleString.AA_Sendpassword_resetemail,
                                      style: MyStyles.Regular(
                                          16, myColor.text_color),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        dailogConfirmSendPassword(
                                            adminLandlordAccountState.email);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 90,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                          color: myColor.Circle_main,
                                        ),
                                        child: Text(
                                          GlobleString.AA_Sendpassword,
                                          style: MyStyles.Medium(
                                              14, myColor.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            );
          }),
    );
  }

  copytoClick(AdminLandlordAccountState adminLandlordAccountState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          GlobleString.LL_Profile_customerfeaturelist,
          style: MyStyles.Medium(14, myColor.black),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          width: 10,
        ),
        Listener(
          child: Text(
            Weburl.CustomerFeaturedPage +
                "" +
                adminLandlordAccountState.CustomerFeatureListingURL,
            style: MyStyles.Medium(14, myColor.blue),
            textAlign: TextAlign.center,
          ),
          onPointerDown: (event) async {
            if (event.kind == PointerDeviceKind.mouse &&
                event.buttons == kSecondaryMouseButton) {
              final overlay =
                  Overlay.of(context)!.context.findRenderObject() as RenderBox;
              final menuItem = await showMenu<int>(
                  context: context,
                  items: [
                    PopupMenuItem(
                      height: 30,
                      child: Text(
                        'Copy link',
                        style: MyStyles.Regular(12, myColor.black),
                      ),
                      value: 1,
                    ),
                  ],
                  position: RelativeRect.fromSize(
                      event.position & Size(48.0, 48.0), overlay.size));
              // Check if menu item clicked
              switch (menuItem) {
                case 1:
                  String url = Weburl.CustomerFeaturedPage +
                      "" +
                      adminLandlordAccountState.CustomerFeatureListingURL;

                  Helper.copyToClipboardHack(context, url);
                  //ToastUtils.showCustomToast(context, "Link Copied", true);
                  break;
                default:
              }
            }
          },
        ),
        /* SelectableText(
            Weburl.CustomerFeaturedPage +
                "" +
                adminLandlordAccountState
                    .CustomerFeatureListingURL,
            style: MyStyles.Medium(
                14, myColor.blue),
            textAlign: TextAlign.center,
            toolbarOptions: ToolbarOptions(
              copy: true,
              selectAll: true,
            ),
            showCursor: true,
            cursorWidth: 2,
            cursorColor: Colors.red,
            cursorRadius: Radius.circular(5),
          ),*/
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            String url = Weburl.CustomerFeaturedPage +
                "" +
                adminLandlordAccountState.CustomerFeatureListingURL;

            print("CustomerFeaturedPage" + url);

            Helper.copyToClipboardHack(context, url);
          },
          child: Tooltip(
            message: "Click to copy link",
            child: Container(
              decoration: BoxDecoration(
                color: myColor.pf_available,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(7),
              child: Icon(
                Icons.copy,
                color: myColor.black,
                size: 17,
              ),
            ),
          ),
        )
      ],
    );
  }

  dailogConfirmSendPassword(String email) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.Admin_sendpassword_msg,
          positiveText: GlobleString.Admin_sendpassword__yes,
          negativeText: GlobleString.Admin_sendpassword__NO,
          onPressedYes: () async {
            Navigator.of(context1).pop();
            sendresetemail(email);
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  void sendresetemail(String email) {
    ForgotPassword forgotPassword = new ForgotPassword();
    forgotPassword.UserName = email;

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().checkEmailalreadyExit(context, forgotPassword,
        (error, respoce) async {
      if (error) {
        if (respoce != null) {
          ApiManager().ResetPassWordAPIworkflow(
              context, respoce.userId.toString(), (error, respoce) {
            if (error) {
              loader.remove();
              ToastUtils.showCustomToast(
                  context, GlobleString.forgot_emailsend1, true);
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

  void saveCustomerUrl(AdminLandlordAccountState adminLandlordAccountState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManagerAdmin().customerUrlUpdateworkflow(
        context,
        adminLandlordAccountState.OwnerId.toString(),
        adminLandlordAccountState.CustomerFeatureListingURL_update.toString(),
        (error, respoce) {
      if (error) {
        loader.remove();
        _store.dispatch(UpdateLandlordAccount_CustomerFeatureListingURL(
            adminLandlordAccountState.CustomerFeatureListingURL_update));
        ToastUtils.showCustomToast(
            context, GlobleString.TM_Member_successfully, true);
      } else {
        loader.remove();
        String errormsg1 =
            respoce.replaceAll("One or more errors occurred. (", "");
        String errormsg = errormsg1.replaceAll(")", "");
        ToastUtils.showCustomToast(context, errormsg, false);
      }
    });
  }
}
